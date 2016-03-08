###
renders a modal form to issue a (non-GET) ROA request
- when templated URL: enter variables
- except when GET or DELETE: enter body
- except when DELETE: enter content type
- show URL
- show method (in submit button)
###

React = require('react')
css = require('classnames')
Button = require('react-bootstrap/lib/Button')
ButtonGroup = require('react-bootstrap/lib/ButtonGroup')
Input = require('react-bootstrap/lib/Input')
Modal = require('react-bootstrap/lib/Modal')

f = require('active-lodash')
deco = require('../lib/decorators')
uriTemplates = require('../../lib/uri-templates')

fancyEditor = true
DataInput = require('../lib/DataInput')

parseUrlParamsForm = (formValue, nesting = false)->
  f.mapValues((try JSON.parse(formValue)), (value, key)->
    return value if (!value or nesting)
    ((try JSON.stringify(value)) or value))

module.exports = React.createClass
  displayName: 'ActionForm'
  propTypes:
    method: React.PropTypes.string.isRequired
    # TODO: *one of the urls* is required:
    url: React.PropTypes.string
    templatedUrl: React.PropTypes.string
    defaults: React.PropTypes.shape(
      contentType: React.PropTypes.string
      body: React.PropTypes.string
    ).isRequired
    modalContainer: React.PropTypes.object.isRequired
    # handlers:
    onSubmit: React.PropTypes.func.isRequired
    onClose: React.PropTypes.func

  getInitialState: ()->
    url: (if (url = @props.templatedUrl) then uriTemplates(url).fill({}))
    formData: f.defaults @props.defaults, {
      urlVars: (if (url = @props.templatedUrl)
        obj = f.object(f.map(uriTemplates(url).varNames, (k)-> [k, null]))
        JSON.stringify(obj, 0, 2)) }

  getFormValue: (key)->
    f.get(@state, ['formData', key]) or f.get(@props, ['defaults', key])

  handleChange: ()->
    # NOTE: This could also be done using ReactLink: <http://facebook.github.io/react/docs/two-way-binding-helpers.html>
    changed =
      formData:
        contentType: f.presence @refs.contentType?.getValue()
        body: f.presence @refs.body?.getValue()
        urlVars: f.presence @refs.urlVars?.getValue()

    # TMP: build url here… (moves to model)
    if @props.templatedUrl
      return if changed.formData.urlVars is @state.formData.urlVars
      filled = parseUrlParamsForm(changed.formData.urlVars)
      changed.url = uriTemplates(@props.templatedUrl).fill(filled or {})

    @setState(f.merge(@state, changed))

  onClose: ()-> @props.onClose?()

  onSubmit: (event)->
    @props.onSubmit(event,
      f.merge(@props.defaults, @state.formData, {url: @state.url}))

  render: ({method, url, templatedUrl, defaults, modalContainer} = @props)->
    throw new Error 'No URL!' if not (url or templatedUrl)
    if templatedUrl then url = @state.url
    title = 'Issue Request'
    submitTitle = method.toUpperCase()
    submitLevel = deco.methodNameToBootstrapeLevel(method)

    # TODO: contain modal in browser, but open in middle of viewport…
    modalContainer = undefined

    <Modal show={true} onHide={@onClose}
      container={modalContainer}
      backdrop='static'>

      <Modal.Header closeButton>
        <Modal.Title>{title}</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <form onSubmit={@props.onSubmit}>

          {# URL vars (JSON) }
          {if templatedUrl then do ()=>
            urlVars = @getFormValue('urlVars')
            helpText = <p>
              The request URL is templated, see <a
                href='http://tools.ietf.org/html/rfc6570'>
                RFC6570 URI Template</a>.
              The parameters can be submitted via the above JSON data.
              Values of <code>null</code> will remove the corresponding parameter.
              Non-simple values (<code>{'{}'}</code>, <code>[]</code>) are stringfied.
            </p>

            if fancyEditor
              # no type=textarea, but custom children!
              <Input
                label='Templated URL Expansion Variables'
                help={helpText}
                bsStyle={deco.validationStateJSON(urlVars)}
                ariaInvalid={not url}>
                <DataInput
                  ref='urlVars'
                  value={urlVars}
                  onChange={@handleChange}/>
              </Input>
            else
              <Input ref='urlVars'
                type='textarea'
                label='Templated URL Expansion Variables'
                placeholder='JSON DATA'
                help={helpText}
                bsStyle={deco.validationStateJSON(urlVars)}
                ariaInvalid={not url}
                rows={urlVars.split('\n').length}
                onChange={@handleChange} />}

          {# Body (JSON) }
          {if not f.includes(['get', 'delete'], method)
            body = @getFormValue('body')

            <Input ref='body'
              label='Request Body'
              placeholder='JSON DATA'
              help='Must be valid JSON data.'
              type='textarea'
              rows={'body'.split('\n').length}
              value={body}
              onChange={@handleChange} />}

          {# URL (readonly) }
          <div className={css('form-group form-group-sm', 'has-error': !url)}>
            <label className='control-label'>
              {if url then 'URL' else 'URL (templated)'}</label>
            <input type='text' className='form-control'
              readOnly
              value={url or templatedUrl}
              ariaInvalid={not url}/>
          </div>

          {# Content-Type (Text) }
          {if not ((method is 'get') or (method is 'delete'))
            <Input ref='contentType'
              label='Content-Type'
              type='text'
              bsSize='small'
              value={@getFormValue('contentType')}
              onChange={@handleChange} />}

        </form>
      </Modal.Body>

      <Modal.Footer>
        <Button onClick={@onClose}>Close</Button>
        <Button onClick={@onSubmit} bsStyle={submitLevel}>
          <samp><b>{submitTitle}</b></samp></Button>
      </Modal.Footer>

    </Modal>
