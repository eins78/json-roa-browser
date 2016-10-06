import React from 'react'
import ampersandReactMixin from 'ampersand-react-mixin'
import Icon from '../lib/Icon'
import f from 'active-lodash'

const RequestConfig = React.createClass({
  // react methods:
  displayName: 'RequestConfig',
  mixins: [ampersandReactMixin],

  defaultProps: {
    onSubmit: () => {},
    onClear: () => {}
  },

  getInitialState () {
    return { formData: {} }
  },

  // event handlers:
  onClearClick (_event) { this.props.onClear() },

  updateConfigKey (key, event) {
    const value = event.target.value
    // set internal state so UI does not hang
    this.setState({formData: f.set(f.clone(this.state.formData), key, value)})
    // callback parent (saves config to model)
    this.props.onConfigChange(key, value)
  },

  onSubmit (event) { this.props.onSubmit(event) },

  render (conf = this.props.config) {
    return (<div className='panel panel-default'>
      <div className='panel-heading'>
        <h2 className='h3'><Icon icon='server' /> Request
          <div className='btn-group btn-group-xs pull-right' role='group'>
            <button className='btn'
              title='reset' onClick={this.onClearClick}>
              <Icon icon='trash' /></button>
          </div>
        </h2>
      </div>

      <form role='form' onSubmit={this.onSubmit}>

        <div className='panel-body'>

          <div className='form-group'>
            <label htmlhtmlFor='request-headers'>HTTP Headers</label>
            <textarea className='form-control small'
              id='request-headers'
              rows={(conf.headers || '').split('\n').length}
              value={conf.headers}
              onChange={f.curry(this.updateConfigKey)('headers')} />
          </div>

        </div>

        <div className='panel-footer'>
          <div className='form-group'>
            <div className='input-group'>
              <input className='form-control small'
                id='url'
                type='text'
                value={conf.url}
                onChange={f.curry(this.updateConfigKey)('url')}
                placeholder='Enter the URL of a JSON-ROA enabled API here!' />
              <span className='input-group-btn'>
                <button className='btn btn-success' id='get' type='submit'>
                  <samp>GET</samp>
                </button>
              </span>
            </div>
          </div>
        </div>

      </form>
    </div>)
  }
})

export default RequestConfig
