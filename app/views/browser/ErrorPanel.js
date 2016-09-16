import { Component, PropTypes } from 'react'
import classList from 'classnames'

class ErrorPanel extends Component {
  render ({title, message, level = 'error'} = this.props) {
    const baseClass = classList('panel', {
      'panel-danger': level === 'error',
      'panel-warning': level === 'warn'})

    return (<div className={baseClass}>
      <div className='panel-heading'>
        <h3>{title}</h3>
      </div>
      <div className='panel-body'>
        {message}
      </div>
    </div>)
  }
}

ErrorPanel.propTypes = {
  title: PropTypes.string.isRequired,
  message: PropTypes.string.isRequired,
  level: PropTypes.oneOf(['error', 'warn'])
}

export default ErrorPanel
