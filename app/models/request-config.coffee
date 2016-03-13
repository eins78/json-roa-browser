Model = require('ampersand-state')
f = require('active-lodash')
uriTemplates = require('../../lib/uri-templates')

module.exports = Model.extend
  props:
    url:
      type: 'string'
      default: '/api' # 'https://json-roa-demo.herokuapp.com/'
      required: true

    method:
      type: 'string'
      default: 'GET'

    headers:
      type: 'string'
      default: 'Accept: application/json-roa+json\n'

    templatedUrlVars: # each var is a key in a hash
      type: 'object'
      default: {}


  # combine internal config with extra config.
  # need still for formAction
  # half of it should move to @derivedConfig
  combineWith: (extraConfig = {})->
    f.chain(extraConfig)
      .merge({headers: (try parseHeaders(extraConfig.headers))})
      .defaults(@derivedConfig)
      .value()

  derived:
    urlIsTemplated:
      deps: ['url']
      fn: ()-> uriTemplates.isTemplated(@url)

    templatedUrlVarsPreset:
      deps: ['url', 'urlIsTemplated']
      fn: ()->
        if @urlIsTemplated
          f.object(f.map(uriTemplates(@url).varNames, (k)-> [k, null]))

    # derived request config as handed to request-running library
    derivedConfig:
      deps: ['url', 'headers', 'method', 'urlIsTemplated']
      fn: ()->
        derivedUrl = if !@urlIsTemplated then @url
        else uriTemplates(@url).fill(@templatedUrlVars)

        url: derivedUrl
        method: @method
        headers: parseHeaders(@headers)
