uriTemplates = require('uri-templates')

uriTemplates.isTemplated = (url)->
  uriTemplates(url).varNames.length > 0

module.exports = uriTemplates
