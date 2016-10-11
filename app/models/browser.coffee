# browser Model - browser.js
Model = require('ampersand-state')
app = require('ampersand-app')
hashchange = require('hashchange')
urlQuery = require('qs')
parseHeaders = require('parse-headers')
f = require('active-lodash')
curl = require('../lib/curl').default

RequestConfig = require('./request-config')
Response = require('./response')

module.exports = Model.extend
  DEFAULTS: ()-> app.DEFAULTS

  # props: NOTE: the browser has no 'props', only children, session and methods.

  # children: nested state; NOTE: instances are never swapped out, only changed!
  children:
    requestConfig: RequestConfig

  # properties that are only local (never serialized)
  # NOTE: When type=state, instances will be swapped out regularly (and change!)
  session:
    formAction: 'object'
    currentRequest: 'object'
    lastRequest: 'object'
    response: 'object' # TODO: Response

  # run on 'create' when option parse=true
  parse: (data) ->
    # takes request config as a query-string (typically from url hash)
    if typeof data is 'string'
      return {requestConfig: (try urlQuery.parse(data))}

  # instance methods:
  save: ()->
    # add and remove event listener to not trigger while saving
    hashchange.unbind(app.onHashChange)
    hashchange.updateHash(urlQuery.stringify(@requestConfig.serialize()))
    setTimeout((-> hashchange.update(app.onHashChange)), 10) # "next tick"

  clear: ()->
    @currentRequest?.curl.abort()
    @requestConfig.clear()
    Model::clear.call(@)

  onRequestSubmit: (url)->
    @requestConfig.set('url', url) if url?
    @save()
    @runRequest()

  # runs a "one-off" request (issued from a modal).
  # only affects `browser.requestConfig` in case of GET request (URL is set)
  runFormActionRequest: (config)->
    # build config from submitted form, current formAction und main request
    config = f.chain()
      .defaults(config, @formAction, @requestConfig.serialize())
      .pick('url', 'method', 'headers', 'body').run()

    # save some state, clear form, and execute request
    if config.method.toUpperCase() is 'GET' then @requestConfig.url = config.url
    @save()
    @formAction = null
    @runRequest(config)

  runRequest: (extraConfig = {})->
    config = f.chain(extraConfig)
      .defaults(@requestConfig.serialize(),
        method: 'GET')
      .merge(
        headers: (try parseHeaders(@requestConfig.headers))
      ,
        headers: (try parseHeaders(extraConfig.headers))
        body: (try JSON.parse(extraConfig.body)))
      .value()

    # reset current request
    @response = null
    if @currentRequest?
      @currentRequest.curl.abort() if f.isFunction(@currentRequest.curl.abort)
      @currentRequest = null

    # run and keep reference (with time), build new response when finished:
    @currentRequest =
      started: (new Date().getTime()),
      curl: curl config, (err, res)=>
        @lastRequest = @currentRequest
        @currentRequest = null
        @response = unless err
          new Response(f.assign(res, requestConfig: config))
        else
          new Response(error: err.toString())
