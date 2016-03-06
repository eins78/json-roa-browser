React = require('react')
classList = require('classnames')
f = require('active-lodash')
# stringify = require('json-stringify-pretty-compact')
# Btn = require('react-bootstrap/lib/Button')
# Icon = require('./Icon')

Codemirror = require('react-codemirror')
require('codemirror/addon/edit/closebrackets')
# require('codemirror/addon/fold/brace-fold')
# require('codemirror/addon/fold/foldcode')
# require('codemirror/addon/fold/foldgutter')
# require('codemirror/addon/lint/json-lint')
# require('codemirror/keymap/sublime')
# require('codemirror/keymap/vim')
require('codemirror/mode/javascript/javascript')
# require('codemirror/mode/yaml/yaml')

module.exports = React.createClass
  displayName: 'DataInput'
  propTypes:
    value: React.PropTypes.string.isRequired
    onChange: React.PropTypes.func.isRequired
    readOnly: React.PropTypes.bool

  getValue: ()->
    @refs.editor?.getCodeMirror?()?.getValue?()

  render: ()->
    {value, onChange, readOnly} = @props

    baseOptions = {
      viewportMargin: Infinity # recomended because of our styling
      readOnly: readOnly
      mode: 'application/json'
      lineNumbers: false
      matchBrackets: true
      explode: ['[]', '{}'].join('')
      autoCloseBrackets: ['[]', '{}', "''", '""'].join('')
      # fold: true
      # foldGutter: true
      # gutters: ['CodeMirror-lint-markers']
      # keyMap: 'sublime'
      # lint: true
    }

    options = {
      base: baseOptions,
      sublime: f.merge(baseOptions, {
        keyMap: "sublime",
        theme: 'solarized light'}),
      # vim: f.merge(baseOptions, {
      #   lineNumbers: true,
      #   keyMap: 'vim',
      #   theme: 'solarized',
      #   showCursorWhenSelecting: true})
    }

    <Codemirror ref="editor"
      value={value}
      onChange={onChange}
      options={options.base}/>
