/*
renders a modal form to issue a (non-GET) ROA request
- when templated URL: enter variables
- except when GET or DELETE: enter body
- except when DELETE: enter content type
- show URL
- show method (in submit button)
*/

import { Component, PropTypes } from 'react'
import css from 'classnames'
import Button from 'react-bootstrap/lib/Button'
// import ButtonGroup from 'react-bootstrap/lib/ButtonGroup'
import Input from 'react-bootstrap/lib/Input'
import Modal from 'react-bootstrap/lib/Modal'

import f from 'active-lodash'
import deco from '../lib/decorators'
import uriTemplates from '../../lib/uri-templates'

const fancyEditor = true
import DataInput from '../lib/DataInput'

const parseUrlParamsForm = (hash) =>
  f.mapValues(hash, (value) =>
    f.isObject(value) ? JSON.stringify(value) : value)

class ActionForm extends Component {
  constructor (props) {
    super(props)

    const tUrl = props.templatedUrl
    this.state = (!tUrl) ? null : {
      url: uriTemplates(tUrl).fill({}),
      formData: {
        urlVars: JSON.stringify( // NOTE: varNames -> ['foo'] -> {foo:null}
          f.object(f.map(uriTemplates(tUrl).varNames, (k) => [k, null])),
        0, 2)
      }
    }

    this.getFormValue = this.getFormValue.bind(this)
    this.handleChange = this.handleChange.bind(this)
    this.onClose = this.onClose.bind(this)
    this.onSubmit = this.onSubmit.bind(this)

    // ;['getFormValue', 'handleChange', 'onClose', 'onSubmit']
    //   .forEach((m) => this[m] = this[m].bind(this))
  }

  // NOTE: This could also be done using ReactLink: <http://facebook.github.io/react/docs/two-way-binding-helpers.html>
  getFormValue (key) {
    return f.get(this.state, ['formData', key]) ||
      f.get(this.props, ['defaults', key]) || ''
  }

  handleChange () {
    // NOTE: `getValue` comes either from react-bootstrap's <input>
    //       OR the codemirror wrapper (which mirrors the method)
    // TODO: just use the input value directly (if needed at all!)
    const getVal = (name) => {
      const getter = f.presence(f.get(this, ['refs', name, 'getValue']))
      return f.isFunction(getter) ? getter() : null
    }
    const changed = {
      formData: ['contentType', 'body', 'urlVars']
        .reduce((o, key) => Object.assign(o, {[key]: getVal(key)}), {})
    }

    // build the URL
    if (this.props.templatedUrl) {
      if (changed.formData.urlVars === this.state.formData.urlVars) return
      const parsed = (() => {
        try { return JSON.parse(changed.formData.urlVars) } catch (e) {}
      })()
      const filled = parseUrlParamsForm(parsed)
      changed.url = uriTemplates(this.props.templatedUrl).fill(filled || {})
    }
    this.setState(f.merge(this.state, changed))
  }

  onClose () { this.props.onClose() }

  onSubmit (event) {
    this.props.onSubmit(
      event,
      f.merge(this.props.defaults, this.state.formData, {url: this.state.url}))
  }

  render ({method, url, templatedUrl, defaults, modalContainer} = this.props) {
    if (!(url || templatedUrl)) throw new Error('No URL!')
    if (templatedUrl) url = this.state.url
    const title = 'Issue Request'
    const submitTitle = method.toUpperCase()
    const submitLevel = deco.methodNameToBootstrapeLevel(method)

    // TODO: contain modal in browser, but open in middle of viewport…
    modalContainer = undefined

    return (<Modal show onHide={this.onClose}
      container={modalContainer}
      backdrop='static'>

      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <form onSubmit={this.props.onSubmit}>

          {/* URL vars (JSON) */}
          {templatedUrl && (() => {
            const urlVars = this.getFormValue('urlVars')
            const helpText = (<p>
              The request URL is templated, see <a
                href='http://tools.ietf.org/html/rfc6570'>
              RFC6570 URI Template</a>.
              The parameters can be submitted via the above JSON data.
              Values of <code>null</code> will remove the corresponding parameter.
              Non-simple values (<code>{'{}'}</code>, <code>[]</code>) are stringfied.
            </p>)

            if (fancyEditor) {
              // no type=textarea, but custom children!
              return <Input
                label='Templated URL Expansion Variables'
                help={helpText}
                bsStyle={deco.validationStateJSON(urlVars)}
                ariaInvalid={!url}>
                <DataInput
                  ref='urlVars'
                  value={urlVars}
                  onChange={this.handleChange} />
              </Input>
            } else {
              return <Input ref='urlVars'
                type='textarea'
                label='Templated URL Expansion Variables'
                placeholder='JSON DATA'
                help={helpText}
                bsStyle={deco.validationStateJSON(urlVars)}
                ariaInvalid={!url}
                rows={urlVars.split('\n').length}
                onChange={this.handleChange} />
            }
          })()}

          {/* Body (JSON) */}
          {!f.includes(['get', 'delete'], method) && (() => {
            const body = this.getFormValue('body')

            return <Input ref='body'
              label='Request Body'
              placeholder='JSON DATA'
              help='Must be valid JSON data.'
              type='textarea'
              rows={'body'.split('\n').length}
              value={body}
              onChange={this.handleChange} />
          })()}

          {/* URL (readonly) */}
          <div className={css('form-group form-group-sm', {'has-error': !url})}>
            <label className='control-label'>
              {url ? 'URL' : 'URL (templated)'}</label>
            <input type='text' className='form-control'
              readOnly
              value={url || templatedUrl}
              ariaInvalid={!url} />
          </div>

          {/* Content-Type (Text) */}
          {!((method === 'get') || (method === 'delete')) &&
            <Input ref='contentType'
              label='Content-Type'
              type='text'
              bsSize='small'
              value={this.getFormValue('contentType')}
              onChange={this.handleChange} />}

        </form>
      </Modal.Body>

      <Modal.Footer>
        <Button onClick={this.onClose}>Close</Button>
        <Button onClick={this.onSubmit} bsStyle={submitLevel}>
          <samp><b>{submitTitle}</b></samp></Button>
      </Modal.Footer>

    </Modal>)
  }
}

ActionForm.propTypes = {
  method: PropTypes.string.isRequired,
  // TODO: *one of the urls* is required:
  url: PropTypes.string,
  templatedUrl: PropTypes.string,
  defaults: PropTypes.shape({
    contentType: PropTypes.string,
    body: PropTypes.string
  }).isRequired,
  modalContainer: PropTypes.object.isRequired,
  // handlers:
  onSubmit: PropTypes.func.isRequired,
  onClose: PropTypes.func
}

ActionForm.defaultProps = {
  onClose: () => {}
}

export default ActionForm
