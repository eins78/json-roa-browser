test = require('tape')

# very simple, but doubles as smokescreen if the models work at all
requestConfig = require('../../app/models/request-config')

test 'request-config', (t)->
  t.plan(2) # subtests

  t.test 'init with url, default headers', (t)->
    t.plan(2)
    rc = new requestConfig
      url: 'http://example.com'

    t.equal(rc.url, 'http://example.com',
      'correct given url')
    t.equal(rc.headers, 'Accept: application/json-roa+json\n',
      'correct default headers')

  t.test 'calls events on set', (t)->
      t.plan(2)
      rc = new requestConfig
        url: 'http://example.com'

      rc.on 'change', ()->
        t.pass('`change` is called')

      rc.on 'change:url', ()->
        t.pass('`change:url` is called')

      rc.url = 'something-else'
