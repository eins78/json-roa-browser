// Determine if user click was meant locally (no new tab etc)

// NOTE: lifted from `local-links`
// <https://github.com/lukekarrys/local-links/blob/master/local-links.js#L39>


module.exports = function isLocalClick(event) {
  if (isModifierKey(event)) {
    return true
  }
  if (isSecondaryButton(event)) {
    return true
  }
  return false
}

// helpers

function isModifierKey(event) {
  return !(event.altKey || event.ctrlKey || event.metaKey || event.shiftKey)
}

function isSecondaryButton(event) {
    return (typeof event === 'object') && ('button' in event) && event.button !== 0;
}
