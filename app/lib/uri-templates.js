import uriTemplates from 'uri-templates'

uriTemplates.isTemplated = (url) =>
  uriTemplates(url).varNames.length > 0

export default uriTemplates
