import React from 'react'
import Icon from '../lib/Icon'

class RunningPanel extends React.Component {
  constructor (props) {
    super(props)
    this.state = { runningTime: 0 }
  }
  updateClock () {
    this.setState({ runningTime: ((new Date()) - this.props.request.started) })
  }
  componentDidMount () {
    this.clockInterval = setInterval(this.updateClock.bind(this), 50) // TODO: requestAnimationFrame
  }
  componentWillUnmount () {
    clearInterval(this.clockInterval)
  }

  render ({runningTime} = this.state) {
    return (
      <div className='panel panel-warning'>
        <div className='panel-heading'>
          <h3>
            <Icon icon='circle-o-notch fa-spin' />
            {' Running… '}
            <samp className='label label-warning'>
              {runningTime + ' ms'}
            </samp>
          </h3>
        </div>
      </div>
    )
  }
}

export default RunningPanel
