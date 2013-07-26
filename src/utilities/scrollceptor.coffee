define (require) ->
  interceptors = []

  update = (interceptor) ->
    {target, range, callback, status} = interceptor
    bounds = target.getBoundingClientRect()
    position = -bounds.top/(bounds.height - window.innerHeight)

    positionInRange = range.from < position < range.to

    if positionInRange isnt status
      interceptor.status = positionInRange
      callback(positionInRange)

  window.addEventListener('scroll', -> interceptors.forEach(update))

  return (target, range, callback) ->
    interceptors.push({ target, range, callback, status: null })
    return callback
