Model = require('ampersand-state')
f = require('active-lodash')

RoaMetaRelations = require('./roa-meta-relations')

RoaRelationBase = require('./_roa-relation-base')
module.exports = RoaRelationBase.extend
  type: 'RoaRelation'

  collections:
    roaRelations: RoaMetaRelations
