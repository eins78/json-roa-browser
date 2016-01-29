Model = require('ampersand-state')
f = require('active-lodash')

# NOTE: This model is not used directly;
# but it is the base for RoaRelation and RoaMetaRelation!

module.exports = Model.extend
  # > "A relation is an object which must contain the key href.
  #    It may contain the keys embedded, name, methods, and relations."
  idAttribute: 'keyName'
  props:
    keyName: 'string' # Relation Identifier, from key of relation in relations
    href:
      type: 'string'
      required: true
      default: null
    name:
      type: 'string'
      default: -> @keyName
    methods:
      type: 'object' # TODO: allowed keys 'get, put, patch, post, and delete'
      default: -> {get: {}}

    # experimental:
    embedded: 'any'

  extraProperties: 'reject'

  derived:
    title:
      deps: ['keyName', 'name']
      fn: ()-> @name or @keyName
