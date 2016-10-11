// application-specific visual config and elements
import f from 'active-lodash'

const methodStyleMap = { // bootstrap levels
  get: 'success',
  post: 'primary',
  put: 'info',
  patch: 'info',
  delete: 'danger',
  _else: 'warning'
}

f.mixin({
  // return object with keys sorted like word in array, extra keys at the end.
  sortKeysLike: (obj, keys) => f(keys)
    .map((k) => f(obj).get(k) && [ k, f(obj).get(k) ])
    .filter().zipObject().merge(obj).value()
}, {chain: false})

export const methodNameToBootstrapeLevel = (method) => {
  if (!f.isString(method)) throw TypeError
  return methodStyleMap[method.toLowerCase()] || methodStyleMap['_else']
}

export const sortMethods = (methods) => // for consistent ordering
  f(methods).sortKeysLike(f.keys(methodStyleMap))

export const validationStateJSON = (data) => {
  try { JSON.parse(data) } catch (e) { return 'error' }
}
