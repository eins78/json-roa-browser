# roaResponse Model - roa-response.js
Model = require('ampersand-state')
mixinTypeSemver = require('../../lib/ampersand-state-mixin-datatype-semver')
parseRoaTree = require('../../lib/roa-transform-tree')

RoaRelation = require('./roa-relation')
RoaRelations = require('./roa-relations')
RoaCollection = require('./roa-collection')

module.exports = Model.extend mixinTypeSemver,
  type: 'RoaObject'

  parse: (givenData)-> parseRoaTree(givenData)

  # > "A minimal valid JSON-ROA extension must contain the key version
  #    where the value must be formatted according to Semantic Versioning."
  #    It may further contain the keys
  #    relations, collection, name, and self-relation."
  props:
    version: {type: 'semver', required: true}
    name: 'string'

  # TODO: maybe 'children' would be better, but it initiates even when empty o_O
    'self-relation': RoaRelation
    collection: RoaCollection

  collections:
    relations: RoaRelations

  extraProperties: 'reject'
