# application-specific visual config and elements
f = require('../../lib/fun')
methodStyleMap = # bootstrap levels
  get: 'success'
  post: 'primary'
  put: 'info'
  patch: 'info'
  delete: 'danger'
  _else: 'warning'


module.exports =
  methodNameToBootstrapeLevel: (method)->
    throw new Error 'TypeError' if not f.isString(method)
    methodStyleMap[method.toLowerCase()] or methodStyleMap['_else']

  sortMethods: (methods)-> # for consistent ordering
    f(methods).sortKeysLike(f.keys(methodStyleMap))

  validationStateJSON: (data)->
    if (try JSON.parse(data)) then null else 'error'
