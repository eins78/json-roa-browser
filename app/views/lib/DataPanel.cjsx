React = require('react')
classList = require('classnames')
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

    itemClass = classList('list-group-item', {'item-closed': open})
    preClass = classList('source-code small', {'pre-scrollable': expanded})
    itemheadingClass = classList('list-group-item-heading',
      {'text-muted': !@hasContent()})

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


    <li id={id} className={itemClass}>
      <div className={itemheadingClass}>
        <span onClick={open && @onCloseClick || @onOpenClick}>{title}</span>
        <div className="btn-group btn-group-xs pull-right" role="group">
          {expandToggle}
          {openToggle}</div></div>

      {if open
        <div className='list-group-item-body'>
          {children if children?}
          <pre id={id} className={preClass}>{text}</pre>
          </div>}
    </li>
