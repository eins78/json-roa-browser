# browser Model - browser.js
Model = require('ampersand-state')
app = require('ampersand-app')
parseHeaders = require('parse-headers')
hashchange = require('hashchange')
urlQuery = require('qs')
f = require('lodash')
curl = require('../lib/curl')

RequestConfig = require('./request-config')
Response = require('./response')

module.exports = Model.extend
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
    response: 'state'

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

  clear: () ->
    @currentRequest?.curl.abort()
    @requestConfig.clear()
    Model::clear.call(@)

  runRequest: ()->
    @response = null

    if @currentRequest?
      @currentRequest.curl.abort()
      @currentRequest = null

    opts = {
      method: 'GET'
      url: @requestConfig.url
      headers: parseHeaders(@requestConfig.headers)
      # username: @requestConfig.user
      # password: @requestConfig.pass
    }

    @currentRequest = f.assign {started: (new Date().getTime())},
      curl: curl opts, (err, res)=>
        @lastRequest = @currentRequest
        @currentRequest = null
        @response = unless err
          new Response(res)
        else
          new Response(error: err.toString())
