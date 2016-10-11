import React from 'react'
import ampersandReactMixin from 'ampersand-react-mixin'
import Browser from './Browser'
import f from 'active-lodash'

// Layout: wraps the `browser` which is attached to `app`
const AppLayout = React.createClass({
  mixins: [ampersandReactMixin],

  render ({app} = this.props) {
    return (<div>

      <nav className='navbar navbar-default navbar-static-top'>
        <div className='container-fluid'>

          <h1 className='navbar-brand'>{app.DEFAULTS.appName} <small>
            {app.VERSION}</small>
          </h1>

          <ul className='nav navbar-nav navbar-right'>
            {f.map(app.DEFAULTS.topNav, (item) =>
              <li key={'' + item.title + item.url}>
                <a href={item.url} className='navbar-link'>{item.title}</a>
              </li>
            )}
          </ul>

        </div>
      </nav>

      <div className='app'>
        <Browser browser={app.browser} />
      </div>

    </div>)
  }
})

export default AppLayout
