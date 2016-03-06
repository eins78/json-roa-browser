React = require('react')
classList = require('classnames')

module.exports = React.createClass
  displayName: 'ErrorPanel'
  propTypes:
    title: React.PropTypes.string.isRequired
    message: React.PropTypes.string.isRequired
    level: React.PropTypes.oneOf(['error', 'warn'])

  render: ({title, message, level} = @props)->
    level = level || 'error'
    baseClass = classList('panel', {
      'panel-danger': level is 'error'
      'panel-warning': level is 'warn'})

    <div className={baseClass}>
      <div className='panel-heading'>
        <h3>{title}</h3>
      </div>
      <div className='panel-body'>
        {message}
      </div>
    </div>
