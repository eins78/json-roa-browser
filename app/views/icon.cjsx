React = require('react')

module.exports = React.createClass
  displayName: 'Icon'
  render: ()->
    throw new Error('No `icon` given!') unless @props.icon?
    <i className="fa fa-fw fa-#{@props.icon}"/>
