React = require('react')
ampersandReactMixin = require('ampersand-react-mixin')
f = require('active-lodash')

# RequestConfig = require('./browser/RequestConfig.cjsx')
# ResponseInfo = require('./browser/ResponseInspector.cjsx')
# ErrorPanel = require('./browser/ErrorPanel.cjsx')
# RunningPanel = require('./browser/RunningPanel.cjsx')
# RoaObject = require('./browser/RoaObject.cjsx')
# ActionForm = require('./browser/ActionForm.cjsx')

RequestConfig = require('./browser/RequestConfig.js').default
ResponseInfo = require('./browser/ResponseInspector.js').default
ErrorPanel = require('./browser/ErrorPanel.js').default
RunningPanel = require('./browser/RunningPanel.js').default
RoaObject = require('./browser/RoaObject.js').default
ActionForm = require('./browser/ActionForm.js').default

browserModel = require('../models/browser')

# API Browser UI
module.exports = React.createClass
  displayName: 'ApiBrowser'
  mixins: [ampersandReactMixin]
  propTypes:
    browser: React.PropTypes.instanceOf(browserModel)

  onRequestConfigChange: (key, value)->
    @props.browser.requestConfig.set(key, value)

  # when the main 'GET' button is clicked:
  onRequestSubmit: (event)->
    @props.browser.onRequestSubmit()

  # when a modal is submitted:
  onFormActionSubmit: (event, config)->
    event.preventDefault()
    @props.browser.runFormActionRequest(config)

  # when a modal is dismissed
  onFormActionCancel: ()->
    @props.browser.unset('formAction')

  # when 'trash' button is clicked
  onClear: ()-> @props.browser.clear()

  render: ()->
    browser = @props.browser

    {# Browser Tab #}
    <div className='modal-container'>

      {# Per-Browser Modal for One-Time Forms #}
      {if f.presence(browser.formAction)?
        <ActionForm {...browser.formAction}
          onSubmit={@onFormActionSubmit}
          onClose={@onFormActionCancel}
          modalContainer={this}/>
      }

      {# Main Browser UI #}
      <div className='app--browser container-fluid'>
      <div className='row'>

        {# Left Side #}
        <div className='col-sm-7'>

          {# Request Config Panel #}
          <RequestConfig
            config={browser.requestConfig}
            onSubmit={@onRequestSubmit}
            onClear={@onClear}
            onConfigChange={@onRequestConfigChange}/>

          {# Main Section #}
          <div role='main'>
            <h2 className='sr-only'>Response Body</h2>
            {if (response = browser.response)
              <ResponseDeco response={response}/>}
          </div>

        </div>

        {# Right Side #}
        <div className='col-sm-5' role='main'>
          <h2 className='sr-only'>Debug Information</h2>
          {# Result: Running, Error or ResponseInfo #}
          {switch
            when browser.currentRequest?
              <RunningPanel request={browser.currentRequest}/>
            when browser.response?.error?
              <ErrorPanel title='Request Error!'
                message={browser.response.error}/>
            when browser.response?
              <ResponseInfo response={browser.response}/>}
        </div>

      </div>
      </div>
    </div>


ResponseDeco = ({response} = @props)->
  # Result: Error or RoaObject or notSupportedMessage or AppError
  AppError = <ErrorPanel title="App Error!" message="This is a bug!"/>
  switch
    when not f.present(response)
      AppError
    when (roaObject = response.roaObject)?
      <RoaObject roaObject={roaObject}/>
    when (roaError = response.roaError)?
      <ErrorPanel title="ROA Error!" message={roaError}/>
    when response && !response.isHandledByApp
      <ErrorPanel title="Unsupported Response!" level='warn'
        message="The response is not supported by this application."/>
    else
      AppError
