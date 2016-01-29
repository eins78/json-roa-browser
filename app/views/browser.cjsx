React = require('react')
ampersandReactMixin = require('ampersand-react-mixin')
f = require('active-lodash')
RequestConfig = require('./browser/RequestConfig')
ResponseInfo = require('./browser/ResponseInspector')
ErrorPanel = require('./browser/ErrorPanel')
RunningPanel = require('./browser/RunningPanel')
RoaObject = require('./browser/RoaObject')
ActionForm = require('./browser/ActionForm')

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
      <div className='app--browser container-fluid row'>

        {# Left Side #}
        <div className='col-sm-7'>

          {# Request Cofig Panel #}
          <RequestConfig
            config={browser.requestConfig}
            onSubmit={@onRequestSubmit}
            onClear={@onClear}
            onConfigChange={@onRequestConfigChange}/>

          {# ROA Result: Error or RoaObject or nothing #}
          {switch
            when (roaObject = browser.response?.roaObject)?
              <RoaObject roaObject={roaObject} onMethodSubmit={@onMethodSubmit}/>
            when (roaError = browser.response?.roaError)?
              <ErrorPanel title="ROA Error!"
                errorText={roaError}/>}
        </div>

        {# Right Side #}
        <div className='col-sm-5'>
          {# Result: Running, Error or ResponseInfo #}
          {switch
            when browser.currentRequest?
              <RunningPanel request={browser.currentRequest}/>
            when browser.response?.error?
              <ErrorPanel title='Request Error!'
                errorText={browser.response.error}/>
            when browser.response?
              <ResponseInfo response={browser.response}/>}
        </div>

      </div>
    </div>

ResultPanel = ({currentRequest, response} = @props)->
