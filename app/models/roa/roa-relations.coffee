Collection = require('ampersand-collection')
roaRelation = require('./roa-relation')

module.exports = Collection.extend
  model: roaRelation
