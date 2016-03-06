React = require('react')
f = require('active-lodash')
stringify = require('json-stringify-pretty-compact')
Btn = require('react-bootstrap/lib/Button')
Icon = require('./Icon')

WIDTH = 60 # default assumed content width in characters (em)

module.exports = React.createClass
  displayName: 'DataPanel'
  propTypes:
    title: React.PropTypes.node.isRequired
    text: React.PropTypes.string
    dataObj: React.PropTypes.object
    initialOpen: React.PropTypes.bool
    initialExpanded: React.PropTypes.bool

  getInitialState: ()-> {
    open: f.presence(@props.initialOpen) or false,
    expanded: f.presence(@props.initialExpanded) or false
  }
  hasContent: ()-> (@props.text? or @props.dataObj? or @props.children?)
  onOpenClick: ()-> @setState(open: true)
  onCloseClick: ()-> @setState(open: false)
  onExpandClick: ()-> @setState(expanded: true)
  onCollapseClick: ()-> @setState(expanded: false)

  render: ()->
    {id, title, text, dataObj, initialOpen, children} = @props
    {open, expanded} = @state

    # if no text given, stringify data
    text ||= if dataObj? then (try stringify(dataObj, maxLength: WIDTH))
    text ||= '[No Data]'

    exandable = (text.split('\n').length > 20)

    itemClass = if open then '' else ' item-closed'
    itemheadingClass = 'list-group-item-heading' + (
      if @hasContent() then '' else ' text-muted')
    preClass = if expanded then '' else 'pre-scrollable'

    openToggle = if open
      <Btn title='close' onClick={@onCloseClick}><Icon icon='chevron-up'/></Btn>
    else
      <Btn title='open' onClick={@onOpenClick}><Icon icon='chevron-down'/></Btn>

    expandToggle = if exandable
      if expanded
        <Btn title='collapse'onClick={@onCollapseClick} disabled={not open}>
          <Icon icon='compress'/></Btn>
      else
        <Btn title='expand'onClick={@onExpandClick} disabled={not open}>
          <Icon icon='expand'/></Btn>


    <li id={id} className={'list-group-item ' + itemClass}>
      <div className={itemheadingClass}>
        <span onClick={open && @onCloseClick || @onOpenClick}>{title}</span>
        <div className="btn-group btn-group-xs pull-right" role="group">
          {expandToggle}
          {openToggle}</div></div>

      {if open
        <div className='list-group-item-body'>
          {children if children?}
          <pre id={id} className={'source-code small ' + preClass}>{text}</pre>
          </div>}
    </li>
