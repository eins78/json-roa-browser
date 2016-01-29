React = require('react')
stringify = require('json-stringify-pretty-compact')
Btn = require('react-bootstrap/lib/Button')
Icon = require('./icon')

WIDTH = 60

module.exports = React.createClass
  displayName: 'DataPanel'

  getInitialState: ()-> { open: null, expanded: false }
  onOpenClick: ()-> @setState(open: true)
  onCloseClick: ()-> @setState(open: false)
  onExpandClick: ()-> @setState(expanded: true)
  onCollapseClick: ()-> @setState(expanded: false)

  render: ()->
    {id, title, level, text, dataObj, defaultOpen, children} = @props
    {open, expanded} = @state
    defaultOpen ||= true

    # panel is open according to state, or,
    # if not set, then if data is present and props defaultOpen is not false
    open = if open?
      open # state
    else
      defaultOpen and (text? or dataObj? or children?)

    # if no text given, stringify data
    text ||= if dataObj? then (try stringify(dataObj, maxLength: WIDTH))
    text ||= '[No Data]'

    exandable = (text.split('\n').length > 20)

    itemClass = if open then '' else ' item-closed'
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
      <div className='list-group-item-heading'>
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
