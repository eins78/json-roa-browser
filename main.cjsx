app = require('ampersand-app')
React = require('react') # used indirectly (via JSX)
ReactDOM = require('react-dom')
urlQuery = require('qs')
hashchange = require('hashchange')

AppView = require('./views/app')
Browser = require('./models/browser')

# add css to output:
require('./styles.less')

app.extend
  DEFAULTS: # TODO: config
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
    ReactDOM.render(<AppView app={app}/>, document.getElementById('app'))

    # run the initial request on startup
    do @browser.runRequest

# attach to browser console for development
window.app = app

# NOTE: React warns against directly redendering into document.body
#       - create the app container `document.getElementById('app')`
document.body.innerHTML = '<div id="app"></div>'

# kickoff
do app.init
