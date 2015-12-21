f = require('./fun')

# For the root object itself, and all properties of the root object which
# can have a `relations` key, recursivly transform those hashes to arrays.
# Note: `merge` just for cleaning up keys
module.exports = (data)->
  f.merge {}, f.assign {},
    version: data.version
    relations: undefined
    roaRelations: transformRoaRelations(data.relations),
    collection: undefined
    roaCollection: transformRoaRelationsFrom(data?.collection)
    'self-relation': undefined
    roaSelfRelation: if (selfRel=data?['self-relation'])?
      f.set(transformRoaRelationsFrom(selfRel), 'keyName', 'roaSelfRelation')

transformRoaRelations = (relations)-> # recurses
  hashToArrayWithKey(relations).map (item)->
    if ((typeof item is 'object') and (typeof item.relations is 'object'))
      transformRoaRelationsFrom(item)
    else
      item

transformRoaRelationsFrom = (item)->
  return item unless typeof item is 'object'
  f.merge {}, f.assign({}, item, relations: undefined),
    roaRelations: transformRoaRelations(item.relations)

hashToArrayWithKey = (object)->
  f.map(object, (val, key)-> f.assign(val, f.set({}, 'keyName', key)))
