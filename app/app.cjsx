app = require('ampersand-app')
React = require('react') # used indirectly (via JSX)
ReactDOM = require('react-dom')
urlQuery = require('qs')
hashchange = require('hashchange')
PKG = require('../package.json')

AppView = require('./views/App')
Browser = require('./models/browser')

# add css to output:
require('./styles.less')

# NOTE: React warns against direct redendering into `document.body`
container = document.getElementsByTagName('app')[0]
throw new Error('No <app> mountpoint found!') if not container

app.extend
  VERSION: PKG.version
  DEFAULTS: # TODO: make configurable
    appName: 'Madek API Browser'
    topNav: [
      {
        title: 'About'
        url: 'http://github.com/eins78/json-roa-browser/'
      }
    ]
    formAction:
      contentType: 'application/json; charset=UTF-8'
      body: '{\n  \n}'

  init: ()->
    # init browser model, sets initial config from URL hash fragment:
    @browser = new Browser(window.location.hash.slice(1), parse: true)

    # whenever the url hash changes, update model and run the request:
    @onHashChange = (hashFragment)=>
      @browser.set(requestConfig: urlQuery.parse(hashFragment))
      @browser.runRequest()
    hashchange.update(@onHashChange)

    # init react view (auto-refreshes on model changes):
    ReactDOM.render(<AppView app={app}/>, container)

    # run the initial request on startup
    do @browser.runRequest

# attach to browser console for development
window.app = app

# kickoff
do app.init
