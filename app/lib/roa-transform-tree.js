import {map, fromPairs, toPairs} from 'lodash'

// For the root object itself, and all properties of the root object which
// can have a `relations` key, recursivly transform those hashes to arrays.

const compact = (obj) =>
  fromPairs(toPairs(obj).filter(([k, v]) => v !== undefined))

const hashToArrayWithKey = (object) =>
  map(object, (val, key) => Object.assign({}, val, { keyName: key }))

const transformRoaRelationItem = (item) =>
  (typeof item !== 'object') ? item : compact(Object.assign(
    item, {
      relations: undefined,
      roaRelations: transformRoaRelations(item.relations) }))

const transformRoaRelations = (relations) =>  // recurses
  hashToArrayWithKey(relations).map((item) =>
    ((typeof item === 'object') && (typeof item.relations === 'object'))
      ? transformRoaRelationItem(item)
      : item)

// main
const roaTransformTree = (data = {}) =>
  compact(Object.assign(
    {}, data, {
      version: data.version,
      relations: undefined,
      roaRelations: transformRoaRelations(data.relations),
      collection: undefined,
      roaCollection: transformRoaRelations(data.collection),
      'self-relation': undefined,
      roaSelfRelation: !!data['self-relation'] && Object.assign(
        { keyName: 'self-relation' },
        transformRoaRelationItem(data['self-relation']))
    }
  ))

export default roaTransformTree
