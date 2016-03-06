React = require('react')
ampersandReactMixin = require 'ampersand-react-mixin'
DataPanel = require('../lib/DataPanel')
Icon = require('../lib/Icon')

module.exports = React.createClass
  displayName: 'ResponseInspector'
  mixins: [ampersandReactMixin]

  render: ({response} = @props)->
    level = if response.statusCode < 400 then 'success' else 'danger'
    panelClass = "panel panel-#{level}"
    labelClass = "label label-#{level}"
    # if we can't decorate the response, always show the headers:
    showHeadersPanelOpen = !response.isHandledByApp

    <div className={panelClass}>

      <div className='panel-heading'>
        <h3><Icon icon='file-text'/> Response <samp className={labelClass}>
          <strong>{response.statusCode}</strong> {response.statusText}
          </samp>
        </h3>
      </div>

      <ul className="list-group">
        <DataPanel title='Request Config' dataObj={response.requestConfig}/>
        <DataPanel title='Headers'
            text={response.headersText} dataObj={response.headers}
            initialOpen={showHeadersPanelOpen}/>

        {if response.isJSON
          <DataPanel title='JSON Data' dataObj={response.jsonRaw}
            initialOpen={true} initialExpanded={true}/>}

        {if response.jsonRoaRaw? # always show, independent of (ROA-)errors!
          <DataPanel title='JSON-ROA Data' dataObj={response.jsonRoaRaw}/>}

      </ul>
    </div>
