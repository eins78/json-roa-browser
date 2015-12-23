Model = require('ampersand-state')

module.exports = Model.extend
  props:
    url:
      type: 'string'
      default: 'https://json-roa-demo.herokuapp.com/'
      required: true
    headers:
      type: 'string'
      default: 'Accept: application/json-roa+json\n'
