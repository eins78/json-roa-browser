var f = require('active-lodash')

function upcaseParts(string, divider) {
  if (typeof string !== 'string') return string
  return f.map(string.split(divider), function (part) {
      return f.capitalize(part)
    }).join(divider)
}

function formatLine(line, maxKeyLenght) {
  return f.padRight(line[0], maxKeyLenght) + ': ' + line[1] + '\r\n'
}

module.exports = function stringifyHttpHeaders(headersObj, conf) {
  conf = f.defaults({}, conf, {padding: false})
  var maxKeyLenght = 0

  if (typeof headersObj !== 'object') return headersObj

  if (conf.padding) {
    maxKeyLenght = f(headersObj).map(function (val, key) {
      return key.length
    }).max()
  }

  return f(headersObj).map(function (val, key) {
      return [upcaseParts(key, '-'), val]
    }).reduce(function (result, line) {
      return result + formatLine(line, maxKeyLenght)
    }, '')
}
