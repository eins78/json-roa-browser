React = require('react')
ampersandReactMixin = require 'ampersand-react-mixin'
Browser = require('./Browser')

# Layout: wraps the `browser` which is attached to `app`

module.exports = React.createClass
  displayName: 'AppLayout'
  mixins: [ampersandReactMixin]

  render: ()->
    browser = @props.app.browser

    <div>

      <nav className="navbar navbar-default navbar-static-top">
        <div className="container-fluid">
          <h1>{app.DEFAULTS.strings.appTitle} <small>
            {app.DEFAULTS.version}</small>
          </h1>
        </div>
      </nav>

      <div className='app'>
        <Browser browser={browser}/>
      </div>

    </div>
