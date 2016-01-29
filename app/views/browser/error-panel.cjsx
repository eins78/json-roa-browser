React = require('react')

module.exports = React.createClass
  displayName: 'ErrorPanel'
  render: ()->
    <div className='panel panel-danger'>
      <div className='panel-heading'>
        <h3>{@props.title}</h3>
      </div>
      <div className='panel-body'>
        {@props.errorText}
      </div>
    </div>
