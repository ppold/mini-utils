define (require) ->
  interceptors = []

  update = (interceptor) ->
    {target, range, callback} = interceptor
    bounds = target.getBoundingClientRect()
    position = -bounds.top/(bounds.height - root.innerHeight)

    if range.from < position < range.to
      callback.dispatch()

  window.addEventListener('scroll', -> stuff.forEach(update))

  return (target, range, callback) ->
    interceptors.push({ target, range, callback })
    return callback
