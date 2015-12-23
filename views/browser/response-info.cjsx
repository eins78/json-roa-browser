React = require('react')
ampersandReactMixin = require 'ampersand-react-mixin'
DataPanel = require('../data-panel')
Icon = require('../icon')

module.exports = React.createClass
  displayName: 'ResponseInfo'
  mixins: [ampersandReactMixin]

  render: ({response} = @props)->
    level = if response.statusCode < 400 then 'success' else 'danger'
    panelClass = "panel panel-#{level}"
    labelClass = "label label-#{level}"

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
            text={response.headersText} dataObj={response.headers}/>

        {if response.jsonRaw?
          <DataPanel title='JSON Data' dataObj={response.jsonRaw}/>}

        {if response.jsonRoaRaw?
          <DataPanel title='JSON-ROA Data' dataObj={response.jsonRoaRaw}/>}

      </ul>
    </div>
