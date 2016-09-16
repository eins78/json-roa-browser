import React from 'react'
import ampersandReactMixin from 'ampersand-react-mixin'
import DataPanel from '../lib/DataPanel'
import Icon from '../lib/Icon'

const ResponseInspector = React.createClass({
  displayName: 'ResponseInspector',
  mixins: [ampersandReactMixin],

  render ({response} = this.props) {
    const level = response.statusCode < 400 ? 'success' : 'danger'
    const panelClass = `panel panel-${level}`
    const labelClass = `label label-${level}`
    // if we can't decorate the response, always show the headers:
    const showHeadersPanelOpen = !response.isHandledByApp

    return (<div className={panelClass}>

      <div className='panel-heading'>
        <h3>
          <Icon icon='file-text' /> Response <samp className={labelClass}>
            <strong>{response.statusCode}</strong> {response.statusText}
          </samp>
        </h3>
      </div>

      <ul className='list-group'>
        <DataPanel title='Request Config' dataObj={response.requestConfig} />
        <DataPanel title='Headers'
          text={response.headersText} dataObj={response.headers}
          initialOpen={showHeadersPanelOpen} />

        {response.isJSON &&
          <DataPanel title='JSON Data' dataObj={response.jsonRaw}
            initialOpen initialExpanded />}

        {/* always show, independent of (ROA-)errors! */}
        {response.jsonRoaRaw &&
          <DataPanel title='JSON-ROA Data' dataObj={response.jsonRoaRaw} />}

      </ul>
    </div>)
  }
})

export default ResponseInspector
