Model = require('ampersand-state')
app = require('ampersand-app')
httpStatusText = require('node-status-codes')
typer = require('media-typer') # NOTE: <npm.im/content-type> would be more correct but doe not include subtype o_O
SemVer = require('semver')
f = require('active-lodash')
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
    props = f.assign(@jsonRoaRaw, baseUrl: @requestConfig.url)
    try
      @roaObject= new RoaObject(props, parse: on)
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
    runningTime: 'number'

    roaObject: 'object' # TODO: RoaObject datatype
    roaError: 'string'

  derived:
    statusText:
      deps: ['statusCode']
      fn: ()-> httpStatusText[@statusCode] or 'Unknown'

    headersText:
      deps: ['headers']
      fn: ()-> stringifyHeaders(@headers, padding: true)

    mediaType:
      deps: ['headers']
      fn: ()->
        contentType = f.get(@headers, 'content-type')
        (try typer.parse(contentType)) or {type: 'text', subtype: 'html'}

    isJSON:
      deps: ['mediaType']
      fn: ()-> (@mediaType.subtype is 'json') or (@mediaType.suffix is 'json')

    jsonBody:
      deps: ['body', 'isJSON']
      fn: ()-> if @isJSON then @body

    jsonRaw:
      deps: ['isJSON', 'jsonBody']
      fn: ()-> if @isJSON then f.presence f.omit(@jsonBody, ROA_PROP)

    jsonRoaRaw:
      deps: ['isJSON', 'jsonBody']
      fn: ()-> if @isJSON then f.presence f.get(@jsonBody, ROA_PROP)
