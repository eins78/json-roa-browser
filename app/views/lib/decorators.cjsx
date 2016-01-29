# application-specific visual config and elements
f = require('active-lodash')

methodStyleMap = # bootstrap levels
  get: 'success'
  post: 'primary'
  put: 'info'
  patch: 'info'
  delete: 'danger'
  _else: 'warning'

f.mixin {
  # return object with keys sorted like word in array, extra keys at the end.
  sortKeysLike: (obj, keys)->
    f(keys).map((k)-> if (v=f(obj).get(k))? then [k,v]).filter().zipObject()
      .merge(obj).value()
}, {chain: false}

module.exports =
  methodNameToBootstrapeLevel: (method)->
    throw new Error 'TypeError' if not f.isString(method)
    methodStyleMap[method.toLowerCase()] or methodStyleMap['_else']

  sortMethods: (methods)-> # for consistent ordering
    f(methods).sortKeysLike(f.keys(methodStyleMap))

  validationStateJSON: (data)->
    if (try JSON.parse(data)) then null else 'error'
