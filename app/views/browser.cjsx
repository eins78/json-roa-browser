React = require('react')
ampersandReactMixin = require('ampersand-react-mixin')
f = require('active-lodash')
RequestConfig = require('./browser/request-config')
ResponseInfo = require('./browser/response-info')
ErrorPanel = require('./browser/error-panel')
RunningPanel = require('./browser/running-panel')
RoaObject = require('./browser/roa-object')
ActionForm = require('./browser/action-form')

# API Browser UI
module.exports = React.createClass
  displayName: 'ApiBrowser'
  mixins: [ampersandReactMixin]

  onRequestConfigChange: (key, value)->
    @props.browser.requestConfig.set(key, value)

  # when the main 'GET' button is clicked:
  onRequestSubmit: (event)->
    @props.browser.onRequestSubmit()

  onFormActionSubmit: (event, config)->
    event.preventDefault()
    @props.browser.runFormActionRequest(config)

  onFormActionCancel: ()->
    @props.browser.unset('formAction')

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
                errorText={roaError}/>
          }
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
              <ResponseInfo response={browser.response}/>
          }
        </div>

      </div>
    </div>
