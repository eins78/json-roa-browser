import React from 'react'
import get from 'lodash/get'

import Codemirror from 'react-codemirror'
import 'codemirror/addon/edit/closebrackets'
import 'codemirror/mode/javascript/javascript'

class DataInput extends React.Component {
  constructor () {
    super()
    this.getValue = this.getValue.bind(this)
  }
  getValue () {
    const editor = get(this, 'refs.editor.getCodeMirror')
    return editor && editor().getValue()
  }
  render () {
    const {value, onChange, readOnly} = this.props

    const options = {
      viewportMargin: Infinity, // recommended because of our styling
      readOnly: readOnly,
      mode: 'application/json',
      lineNumbers: false,
      // fancy stuff:
      matchBrackets: true,
      explode: ['[]', '{}'].join(''),
      autoCloseBrackets: ['[]', '{}', "''", '""'].join('')
    }

    return (
      <Codemirror ref='editor'
        value={value}
        onChange={onChange}
        options={options}
      />)
  }
}

DataInput.propTypes = {
  value: React.PropTypes.string.isRequired,
  onChange: React.PropTypes.func.isRequired,
  readOnly: React.PropTypes.bool
}

export default DataInput
