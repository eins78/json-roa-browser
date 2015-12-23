React = require('react')
ampersandReactMixin = require 'ampersand-react-mixin'
Btn = require('react-bootstrap/lib/Button')
BtnGroup = require('react-bootstrap/lib/ButtonGroup')
Icon = require('../icon')
f = require('../../lib/fun')

module.exports = React.createClass
  # react methods:
  displayName: 'RequestConfig'
  mixins: [ampersandReactMixin]

  getInitialState: ()-> {formData: {}}

  # event handlers:
  onClearClick: (_event) -> @props.onClear()

  updateConfigKey: (key, event) ->
    value = event.target.value
    # set internal state so UI does not hang
    @setState(formData: f.set(f.clone(@state.formData), key, value))
    # callback parent (saves config to model)
    @props.onConfigChange(key, value)

  onSubmit: (event)-> @props.onSubmit?(event)

  render: ()->
    conf = @props.config

    <div className='panel panel-default'>
      <div className='panel-heading'>
        <h3><Icon icon='server'/> Request
          <BtnGroup bsSize='xs' className='pull-right'>
            <Btn title='reset' onClick={@onClearClick}>
              <Icon icon='trash'/></Btn>
          </BtnGroup>
        </h3>
      </div>

      <form role="form" onSubmit={@onSubmit}>

        <div className='panel-body'>

          <div className="form-group">
            <label htmlhtmlFor="request-headers">HTTP Headers</label>
            <textarea className="form-control small"
              id="request-headers"
              rows='3'
              value={conf.headers}
              onChange={f.curry(@updateConfigKey)('headers')}/>
          </div>

        </div>

        <div className='panel-footer'>
        <div className="form-group">
          <div className="input-group">
            <input className="form-control small"
              id="url"
              type="text"
              value={conf.url}
              onChange={f.curry(@updateConfigKey)('url')}
              placeholder="Enter the URL of a JSON-ROA enabled API here!"/>
            <span className="input-group-btn">
              <button className="btn btn-success" id="get" type="submit">
                <samp>GET</samp>
              </button>
            </span>
          </div>
        </div>
        </div>

      </form>
    </div>
