define ['./signal'], (Signal) ->
  signals = []

  class VisibilitySignal extends Signal
    constructor: (@view) ->
      super

    dispatch_if_visible: ->
      if @is_view_visible()
        @dispatch()

    is_view_visible: ->
      # checks if a view is visible in the viewport

      bounds = @view.getBoundingClientRect()
      if bounds.top < window.innerHeight and bounds.bottom > 0
        return yes

      return false

    add: (slot) ->
      super slot
      @dispatch_if_visible()

    addOnce: (slot) ->
      super slot
      @dispatch_if_visible()

  send_visibility_signals = (event) ->
    # dispatches the signals whose views are visible in the viewport
    signals.forEach (signal) -> signal.dispatch_if_visible()

  track_view = (view) ->
    # adds a view with its corresponding signal to a list for inspection
    # when the document scrolls.
    signal = new VisibilitySignal(view)
    signals.push(signal)
    return signal

  untrack_view = (viewToBeUntracked) ->
    for signal, i in signals
      if signal.view is viewToBeUntracked
        signals.splice(i, 1)
        break

  window.addEventListener("scroll", send_visibility_signals)

  return {track_view, untrack_view}
