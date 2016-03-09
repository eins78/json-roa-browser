React = require('react')

Codemirror = require('react-codemirror')
require('codemirror/addon/edit/closebrackets')
require('codemirror/mode/javascript/javascript')

module.exports = React.createClass
  displayName: 'DataInput'
  propTypes:
    value: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    readOnly: React.PropTypes.bool

  getValue: ()->
    @refs.editor?.getCodeMirror?()?.getValue?()

  render: ()->
    {value, onChange, mode, readOnly} = @props

    options = {
      viewportMargin: Infinity # recommended because of our styling
      readOnly: readOnly
      mode: 'application/json'
      lineNumbers: false
      # fancy stuff:
      matchBrackets: true
      explode: ['[]', '{}'].join('')
      autoCloseBrackets: ['[]', '{}', "''", '""'].join('')
    }

    <Codemirror ref="editor"
      value={value}
      onChange={onChange}
      options={options}/>
