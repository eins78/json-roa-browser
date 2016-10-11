import React from 'react'

const Icon = (props) => {
  if (!props.icon) throw new TypeError('No `icon` given!')
  return <i className={`fa fa-fw fa-${props.icon}`} />
}

export default Icon
