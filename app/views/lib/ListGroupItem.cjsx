React = require('react')

module.exports = ListGroupItem = ({header, children} = @props)->
  <div className='list-group-item'>
    <h4 className='list-group-item-heading'>{header}</h4>
    {children}
  </div>
