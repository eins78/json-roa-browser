# browser Model - browser.js
Model = require('ampersand-model')
parseHeaders = require('parse-headers')
curl = require('../lib/curl')
hashchange = require('hashchange')
urlQuery = require('qs')

module.exports = Model.extend({
  # define props and session (like props, but not persisted):
  props:
    requestUrl:
      type: 'string'
      default: 'https://json-roa-demo.herokuapp.com/'
      required: true
    requestHeaders:
      type: 'string'
      default: 'Accept: application/json-roa+json\n'
      required: false

  session:
    responseBody: 'object' # tmp

  # runs after 'create' (this = new instance with all attributes):
  initialize: () ->
    do @runRequest # run the initial request

  # instance methods:
  saveConfigToUrl: ()->
    hashchange.updateHash(urlQuery.stringify(@toJSON()))

  runRequest: ()->
    do @saveConfigToUrl
    opts = {
      url: @requestUrl
      method: 'GET'
      headers: parseHeaders(@requestHeaders)
    }
    curl opts, (err, res, body)=>
      @set('responseBody', raw)
      # @response.set {err: err, res: res, body: body}
})
