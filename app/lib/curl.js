import httpRequest from 'nets'
import {chain, merge, isFunction} from 'lodash'
import {Try} from './util'

export default function curl (opts, callback) {
  const conf = chain({})
    .merge(opts)
    .merge({
      headers: merge({}, opts.headers, { 'Content-Type': opts.contentType })
    })
    .omit('contentType')
    .value()

  return httpRequest(conf, (err, res, body) => {
    body = Try(() => body.toString())
    body = (Try(() => JSON.parse(body)) || body)
    isFunction(callback) &&
      callback(
        err,
        Object.assign({}, res, {body, encoding: 'UTF-8'}),
        body)
  })
}
