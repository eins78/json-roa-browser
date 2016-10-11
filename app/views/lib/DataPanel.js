import React from 'react'
import classList from 'classnames'
import f from 'active-lodash'
import prettyStringify from 'json-stringify-pretty-compact'
import Btn from 'react-bootstrap/lib/Button'
import Icon from './Icon'

const WIDTH = 60 // default assumed content width in characters (em)

function stringify (obj, opts) {
  try { return prettyStringify(obj, opts) } catch (e) { }
}

class DataPanel extends React.Component {
  constructor (props) {
    super(props)
    this.state = {
      open: f.presence(props.initialOpen) || false,
      expanded: f.presence(props.initialExpanded) || false
    }
    this.onOpenClick = () => this.setState({open: true})
    this.onCloseClick = () => this.setState({open: false})
    this.onExpandClick = () => this.setState({expanded: true})
    this.onCollapseClick = () => this.setState({expanded: false})
  }
  hasContent () {
    f.present(this.props.text || this.props.dataObj || this.props.children)
  }

  render () {
    const {id, title, text, dataObj, children} = this.props
    const {open, expanded} = this.state

    // if no text given, stringify data
    const content = text ||
      (f.present(dataObj) && stringify(dataObj, {maxLength: WIDTH})) ||
      '[No Data]'

    const exandable = (content.split('\n').length > 20)

    const itemClass = classList('list-group-item', {'item-closed': open})
    const preClass = classList('source-code small', {'pre-scrollable': expanded})
    const itemheadingClass = classList(
      'list-group-item-heading',
      {'text-muted': !this.hasContent()})

    const openToggle = open
      ? <Btn title='close' onClick={this.onCloseClick}><Icon icon='chevron-up' /></Btn>
      : <Btn title='open' onClick={this.onOpenClick}><Icon icon='chevron-down' /></Btn>

    const expandToggle = exandable &&
      expanded
        ? (<Btn title='collapse'onClick={this.onCollapseClick} disabled={!!open}>
          <Icon icon='compress' /></Btn>)
        : (<Btn title='expand'onClick={this.onExpandClick} disabled={!!open}>
          <Icon icon='expand' /></Btn>)

    return (
      <li id={id} className={itemClass}>
        <div className={itemheadingClass}>
          <span onClick={open && this.onCloseClick || this.onOpenClick}>{title}</span>
          <div className='btn-group btn-group-xs pull-right' role='group'>
            {expandToggle}
            {openToggle}</div></div>

        {open &&
          <div className='list-group-item-body'>
            {!!children && children}
            <pre id={id} className={preClass}>{content}</pre>
          </div>
        }
      </li>
    )
  }
}

DataPanel.propTypes = {
  title: React.PropTypes.node.isRequired,
  text: React.PropTypes.string,
  dataObj: React.PropTypes.object,
  initialOpen: React.PropTypes.bool,
  initialExpanded: React.PropTypes.bool
}

export default DataPanel
