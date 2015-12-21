# roaResponse Model - roa-response.js
Model = require('ampersand-state')
mixinTypeSemver = require('../../lib/ampersand-state-mixin-datatype-semver')
parseRoaTree = require('../../lib/roa-transform-tree')

RoaRelation = require('./roa-relation')
RoaRelations = require('./roa-relations')
RoaCollection = require('./roa-collection')

module.exports = Model.extend mixinTypeSemver,
  type: 'RoaObject'

  parse: parseRoaTree # more friendly: keynames; arrays for preserving order

  props:
    # > "A minimal valid JSON-ROA extension must contain the key version
    #    where the value must be formatted according to Semantic Versioning."
    #    It may further contain the keys
    #    relations, collection, name, and self-relation."
    version: {type: 'semver', required: true}
    name: 'string'
    # The URL of the object itself (where it comes from) is also needed
    url: {type: 'string', required: true}

  # TODO: dont init when empty
  children:
    roaSelfRelation: RoaRelation
    roaCollection: RoaCollection

  collections:
    roaRelations: RoaRelations

  extraProperties: 'reject'
