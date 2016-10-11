import React from 'react'

const ListGroupItem = ({header, children}) =>
  <div className='list-group-item'>
    <h4 className='list-group-item-heading'>{header}</h4>
    {children}
  </div>

export default ListGroupItem
