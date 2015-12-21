Model = require('ampersand-state')
RoaRelation = require('./roa-relation')
RoaRelations = require('./roa-relations')

module.exports = Model.extend
  type: 'RoaCollection'
  # > "The collection object must contain a relations key which contains
  #    as described in the section relations object."
  collections:
    roaRelations: RoaRelations
  # > "The collection can contain a next key with the value of a relation object
  #   with the following restriction: the included url may not be templated."
  children:
    next: RoaRelation

  extraProperties: 'reject'

# > "Any of the following two conditions signals the end of the collection for a client:
#   - The relations object is empty.
#   - There is no next key."
  derived:
    hasMore:
      deps: ['next', 'relations']
      fn: () ->
        (not @next?) or (@relations.length < 1)
