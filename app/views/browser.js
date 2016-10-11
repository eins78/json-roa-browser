import React from 'react'
import ampersandReactMixin from 'ampersand-react-mixin'
import f from 'active-lodash'

import RequestConfig from './browser/RequestConfig.js'
import ResponseInfo from './browser/ResponseInspector.js'
import ErrorPanel from './browser/ErrorPanel.js'
import RunningPanel from './browser/RunningPanel.js'
import RoaObject from './browser/RoaObject.js'
import ActionForm from './browser/ActionForm.js'

import browserModel from '../models/browser'

const ResponseDeco = (props) => {
  // Result: Error or RoaObject or notSupportedMessage or AppError
  const {response} = props
  const AppError = <ErrorPanel title='App Error!' message='This is a bug!' />

  if (!f.present(response)) { return AppError }

  if (f.present(response.roaObject)) {
    return <RoaObject roaObject={response.roaObject} />
  }
  if (f.present(response.roaError)) {
    return <ErrorPanel title='ROA Error!' message={response.roaError} />
  }
  if (response && !response.isHandledByApp) {
    return (<ErrorPanel title='Unsupported Response!' level='warn'
      message='The response is not supported by this application.' />)
  }
  return AppError // else
}

// API Browser UI
const ApiBrowser = React.createClass({
  displayName: 'ApiBrowser',
  mixins: [ampersandReactMixin],
  propTypes: {
    browser: React.PropTypes.instanceOf(browserModel)
  },
  onRequestConfigChange (key, value) {
    this.props.browser.requestConfig.set(key, value)
  },
  // when the main 'GET' button is clicked:
  onRequestSubmit (event) {
    this.props.browser.onRequestSubmit()
  },
  // when a modal is submitted:
  onFormActionSubmit (event, config) {
    event.preventDefault()
    this.props.browser.runFormActionRequest(config)
  },
  // when a modal is dismissed
  onFormActionCancel () {
    this.props.browser.unset('formAction')
  },
  // when 'trash' button is clicked
  onClear () { this.props.browser.clear() },

  render ({browser} = this.props) {
    // Browser Tab
    return <div className='modal-container'>

      {/* Per-Browser Modal for One-Time Forms */}
      {f.present(browser.formAction) &&
        <ActionForm {...browser.formAction}
          onSubmit={this.onFormActionSubmit}
          onClose={this.onFormActionCancel}
          modalContainer={this}
        />}

      {/* Main Browser UI */}
      <div className='app--browser container-fluid'>
        <div className='row'>

          {/* Left Side */}
          <div className='col-sm-7'>
            {/* Request Config Panel */}
            <RequestConfig
              config={browser.requestConfig}
              onSubmit={this.onRequestSubmit}
              onClear={this.onClear}
              onConfigChange={this.onRequestConfigChange}
            />

            {/* Main Section */}
            <div role='main'>
              <h2 className='sr-only'>Response Body</h2>
              {!!browser.response &&
                <ResponseDeco response={browser.response} />}
            </div>
          </div>

          {/* Right Side */}
          <div className='col-sm-5' role='main'>
            <h2 className='sr-only'>Debug Information</h2>

            {/* Result: Running, Error or ResponseInfo */}
            {f.present(browser.currentRequest)
              ? <RunningPanel request={browser.currentRequest} />

              : f.present(f.get(browser, 'response.error'))
              ? <ErrorPanel title='Request Error!' message={browser.response.error} />

              : f.present(browser.response)
              ? <ResponseInfo response={browser.response} />

              : null
            }
          </div>
        </div>
      </div>
    </div>
  }
})

export default ApiBrowser
