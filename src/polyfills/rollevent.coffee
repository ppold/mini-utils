define ->
  clone_mouse_event = (oldEvent, newType) ->
    newEvent = document.createEvent('MouseEvents')
    newEvent.initMouseEvent(
      newType, oldEvent.bubbles, oldEvent.cancelable, window, oldEvent.detail,
      oldEvent.screenX, oldEvent.screenY, oldEvent.clientX, oldEvent.clientY,
      oldEvent.ctrlKey, oldEvent.altKey, oldEvent.shiftKey, oldEvent.metaKey,
      oldEvent.button, oldEvent.relatedTarget
    )
    return newEvent

  roll_events_handler =
    _elementIsHovered: no

    handleEvent: (event) ->
      switch event.type
        when 'mouseover'
          unless @_elementIsHovered
            @_elementIsHovered = yes
            {currentTarget} = event
            currentTarget.dispatchEvent(clone_mouse_event(event, 'rollover'))

        when 'mouseout'
          {currentTarget, relatedTarget} = event
          if @_elementIsHovered and not currentTarget.contains(relatedTarget)
            @_elementIsHovered = no
            currentTarget.dispatchEvent(clone_mouse_event(event, 'rollout'))

  emulate_roll_events = (target) ->
    target.addEventListener('mouseover', roll_events_handler)
    target.addEventListener('mouseout', roll_events_handler)

  return emulate_roll_events
