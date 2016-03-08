React = require('react')
ampersandReactMixin = require 'ampersand-react-mixin'
Browser = require('./Browser')
f = require('active-lodash')

# Layout: wraps the `browser` which is attached to `app`

module.exports = React.createClass
  displayName: 'AppLayout'
  mixins: [ampersandReactMixin]

  render: ()->
    browser = @props.app.browser

    <div>

      <nav className="navbar navbar-default navbar-static-top">
      <div className="container-fluid">
      <div classname="navbar-header">

        <h1 className="navbar-brand">{app.DEFAULTS.appName} <small>
          {app.VERSION}</small>
        </h1>

        <ul className="nav navbar-nav navbar-right">
          {f.map app.DEFAULTS.topNav, (item)->
            key = ''+item.title+item.url
            <li key={key}><a href={item.url} className="navbar-link">
              {item.title}</a></li>}</ul>
      </div>
      </div>
      </nav>

      <div className='app'>
        <Browser browser={browser}/>
      </div>

    </div>
