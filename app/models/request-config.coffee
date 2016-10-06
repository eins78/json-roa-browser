Model = require('ampersand-state')

f = require('active-lodash')
parseHeaders = require('parse-headers')
uriTemplates = require('../lib/uri-templates').default

module.exports = Model.extend
  props:
    url:
      type: 'string'
      default: '/api' # 'https://json-roa-demo.herokuapp.com/'
      required: true
    headers:
      type: 'string'
      default: 'Accept: application/json-roa+json\n'
