Model = require('ampersand-state')
app = require('ampersand-app')
httpStatusText = require('node-status-codes')
SemVer = require('semver')
f = require('../lib/fun')
stringifyHeaders = require('../lib/stringify-http-headers')
RoaObject = require('./roa/roa-object')

ROA_TYPE = 'application/json-roa+json'
ROA_PROP = '_json-roa'
ROA_VERSION = SemVer('1.0.0')

module.exports = Model.extend
  initialize: () ->
    semver = (try SemVer(@jsonRoaRaw.version))
    # TODO: move to roa object model

    # abort if no ROA object present
    return unless @jsonRoaRaw?

    roaError = switch
      when not f(@headers['content-type']).startsWith(ROA_TYPE)
        'Response does not have JSON-ROA content-type'
      when not semver?
        'JSON-ROA version not valid SemVer: ' + @jsonRoaRaw.version
      when not (semver.major is ROA_VERSION.major)
        'Not compatible to JSON-ROA version ' + semver.version

    # fail hard if error
    if roaError?
      return @roaError = roaError

    # trigger warnings
    if semver.compare(ROA_VERSION) < 0
      app.trigger('warning', 'JSON-ROA Version newer than expected')

    # all prechecks are done, try to init models and catch errors as well
    try
      @roaObject= new RoaObject(f.assign(@jsonRoaRaw, url: @url), parse: on)
    catch error
      @roaError= error.toString()


  props:
    # NOTE: in case of request error only 'error' is set!
    error: 'string'

    body: 'any'
    statusCode: 'number'
    method: 'string'
    headers: 'object'
    requestConfig: 'object'
    url: 'string'
    runningTime: 'number'

    roaObject: RoaObject
    roaError: 'string'

  derived:
    statusText:
      deps: ['statusCode']
      fn: ()-> httpStatusText[@statusCode] or 'Unknown'

    headersText:
      deps: ['headers']
      fn: ()-> stringifyHeaders(@headers, padding: true)

    jsonRaw:
      deps: ['body']
      fn: ()-> f(this.body).omit(ROA_PROP).presence()

    jsonRoaRaw:
      deps: ['body']
      fn: ()-> f(this.body).get(ROA_PROP)
