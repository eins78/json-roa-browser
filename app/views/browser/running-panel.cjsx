React = require('react')
Icon = require('../icon')

module.exports = React.createClass
  displayName: 'RunningPanel'
  getInitialState: ()-> {runningTime: 0}
  componentDidMount: ()->
    @clock = setInterval(@updateClock, 50);
  updateClock: ()->
    @setState(runningTime: ((new Date().getTime()) - @props.request.started))
  componentWillUnmount: ()->
    clearInterval(@clock);
  render: ()->
    <div className='panel panel-warning'>
      <div className='panel-heading'>
        <h3>
          <Icon icon='circle-o-notch fa-spin'/> Running… <samp
            className='label label-warning'>
              {@state.runningTime + ' ms'}
            </samp>
        </h3>
      </div>
    </div>
