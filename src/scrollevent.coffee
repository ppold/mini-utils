define ['./customevent'], ->

  class ScrollHandler
    isScrolling: no
    timeoutID: null

    constructor: (@target, @idleTime) ->
      @target.addEventListener('scroll', this)

    handleEvent: (event) ->
      if @isScrolling
        if @timeoutID?
          clearTimeout(@timeoutID)
      else
        @isScrolling = yes
        @target.dispatchEvent(new CustomEvent('scrollstart'))

      @timeoutID = setTimeout(@endScroll, @idleTime)

    endScroll: =>
      @isScrolling = no
      @timeoutID = null
      @target.dispatchEvent(new CustomEvent('scrollend'))

  ScrollEvent =
    register: (target, idleTime = 120) ->
      new ScrollHandler(target, idleTime)

  return { ScrollEvent }
