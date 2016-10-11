import React from 'react'
import app from 'ampersand-app'
import ReactDOM from 'react-dom'
import urlQuery from 'qs'
import hashchange from 'hashchange'
import PKG from '../package.json'

import AppView from './views/App'
import Browser from './models/browser'

// add css to output (webpack!)
import './styles.less'

// NOTE: React warns against direct redendering into `document.body`
const container = document.getElementsByTagName('app')[0]
if (!container) throw new Error('No <app> mountpoint found!')

app.extend({
  VERSION: PKG.version,
  DEFAULTS: { // TODO: make configurable
    appName: 'Madek API Browser',
    topNav: [
      { title: 'About',
        url: 'http://github.com/eins78/json-roa-browser/' }
    ],
    formAction: {
      contentType: 'application/json; charset=UTF-8',
      body: '{\n  \n}'
    }
  },

  init () {
    // init browser model, sets initial config from URL hash fragment:
    this.browser = new Browser(window.location.hash.slice(1), {parse: true})

    // whenever the url hash changes, update model and run the request:
    this.onHashChange = (hashFragment) => {
      this.browser.set({requestConfig: urlQuery.parse(hashFragment)})
      this.browser.runRequest()
    }
    hashchange.update(this.onHashChange)

    // init react view (auto-refreshes on model changes):
    ReactDOM.render(React.createElement(AppView, {app}), container)

    // run the initial request on startup
    this.browser.runRequest()
  }
})

// attach to browser console for development
window.app = app

// needed by bootstrap's modal (???)
window.React = React

// kickoff
app.init()
