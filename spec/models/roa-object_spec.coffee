test = require('tape')
f = require('../../lib/fun')

roaObject = require('../../models/roa/roa-object')

testData = f.merge require('../fixtures/roa-example.json'), {
  # added by us:
  url: 'http://example.com',
  # TODO: contentType: ""
}

test 'roa model ', (t)->
  t.plan(1) # subtests

  t.test 'from parsing data', (t)->
    t.plan(4)
    roa = new roaObject(testData, parse: true)

    t.equal(roa.type, 'RoaObject', 'is a RoaObject')

    t.test 'self-relation', (t)->
      t.plan(4)
      sr = roa.roaSelfRelation
      t.equal(sr.type, 'RoaRelation', 'is a RoaRelation')
      t.equal(sr.name, 'Messages', 'has correct name')
      t.equal(sr.roaRelations.length, 1, 'has 1 meta-relation')
      t.equal(sr.roaRelations.models[0].type, 'RoaMetaRelation',
        'first meta-relation is a RoaMetaRelation')

    t.test 'collection', (t)->
      t.plan(4)
      col = roa.roaCollection
      t.ok(col.isState, 'is state')
      t.equal(col.next.type, 'RoaRelation', 'next is a RoaRelation')
      t.equal(col.roaRelations.length, 3, 'has 3 relations')
      t.test 'first item', (t)->
        t.plan(2)
        item = col.roaRelations.models[0]
        t.equal(item.keyName, '1', 'has correct keyName')
        t.test 'meta-relations', (t)->
          t.plan(3)
          mrel = item.roaRelations
          t.equal(mrel.length, 1, 'has 1 meta-relation')
          t.equal(mrel.models[0].type, 'RoaMetaRelation',
            'first meta-relation is a RoaMetaRelation')
          t.equal(mrel.models[0].name, 'API-Doc',
            'first meta-relation has correct name')


    t.test 'relations', (t)->
      t.plan(5)
      rel = roa.roaRelations

      t.ok(rel.isCollection, 'is collection')
      t.equal(rel.length, 3, 'has 3 relations')
      t.looseEqual(f.find(rel.models, keyName: 'message').methods,
        { delete: {}, get: {} },
        'relation `message` has correct methods')
      t.looseEqual(f.find(rel.models, keyName: 'messages').methods,
        { get: {}, post: {} },
        'relation `messages` has correct methods')

      t.test 'root relation', (t)->
        t.plan(2)
        rootrel = f.find(rel.models, keyName: 'root')

        t.looseEqual(rootrel.methods,
          { get: {} },
          'has correct methods')

        t.test 'meta-relations', (t)->
          t.plan(3)
          mrel = rootrel.roaRelations
          t.equal(mrel.length, 1, 'has 1 meta-relation')
          t.equal(mrel.models[0].type, 'RoaMetaRelation',
            'first meta-relation is a RoaMetaRelation')
          t.equal(mrel.models[0].name, 'API-Doc',
            'first meta-relation has correct name')



  # t.test 'from invalid data', (t)->
  #     t.plan(1)

      # t.throws ()->
      #   new roaObject(f.omit(testData, 'version'), parse: true)
      # , /pending/
      # , 'throws without version'
      #
      # t.throws ()->
      #   new roaObject(f.omit(testData, 'url'), parse: true)
      # , /pending/
      # , 'throws without url'

      # t.throws ()->
      #   new roaObject(f.merge({}, testData, foo: 'bar'), parse: true)
      # , /TypeError: No \"foo\" property defined/
      # , 'throws with extra props'

      # TODO: refactor validation from response into roa object…
      # t.throws ()->
      #   new roaObject(f.merge({}, contentType: 'wrong'), parse: true)
      # , 'throws with wrong content-type'

      # t.throws ()->
      #   new roaObject(f.merge({}, version: '1337'), parse: true)
      # , 'throws with non-semver version'
