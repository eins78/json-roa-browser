React = require('react')
Button = require('react-bootstrap/lib/Button')
ButtonGroup = require('react-bootstrap/lib/ButtonGroup')
Input = require('react-bootstrap/lib/Input')
Modal = require('react-bootstrap/lib/Modal')
f = require('../../lib/fun')

module.exports = React.createClass
  displayName: 'ActionForm'

  getInitialState: ()-> {formData: {}}

  getFormValue: (key)->
    @state.formData[key] or @props.defaultFormData?[key] or null

  handleChange: ()->
    # NOTE: This could also be done using ReactLink: <http://facebook.github.io/react/docs/two-way-binding-helpers.html>
    @setState formData:
      contentType: f.presence @refs.contentType.getValue()
      body: f.presence @refs.body.getValue()

  onClose: ()-> @props.onClose?()
  onSubmit: (event)->
    @props.onSubmit event,
      f.merge(@props.defaultFormData, @props.config, @state.formData)

  render: ()->
    {container} = @props

    # TODO: contain modal in browser, but open in middle of viewport…
    container = undefined

    <Modal show={true} onHide={@onClose}
      container={container}
      backdrop='static'>

      <Modal.Header closeButton>
        <Modal.Title>Modal heading</Modal.Title>
      </Modal.Header>

      <Modal.Body>
        <form onSubmit={@props.onSubmit}>
          <Input ref='contentType'
            label='Content-Type'
            type='text'
            value={@getFormValue('contentType')}
            onChange={@handleChange} />

          <Input ref='body'
            label='Body'
            placeholder='Enter JSON Data'
            help='Must be valid JSON data.'
            type='textarea'
            rows={@getFormValue('body').split('\n').length}
            value={@getFormValue('body')}
            onChange={@handleChange} />
        </form>
      </Modal.Body>

      <Modal.Footer>
        <Button onClick={@onClose}>Close</Button>
        <Button onClick={@onSubmit}>POST</Button>
      </Modal.Footer>

    </Modal>
