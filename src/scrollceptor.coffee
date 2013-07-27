define ['./signal'], (Signal) ->
	interceptors = []

	update = (interceptor) ->
		{target, options, status} = interceptor
		bounds = target.getBoundingClientRect()

		if options.axis is 'x'
			{scrollLeft, scrollWidth, offsetWidth} = target
			position = scrollLeft/(scrollWidth - offsetWidth)
		else if options.axis is 'y'
			position = -bounds.top/(bounds.height - window.innerHeight)

		positionInRange = options.from < position < options.to

		if positionInRange isnt status
			interceptor.status = positionInRange

			if positionInRange
				interceptor.viewportInsideRange.dispatch()
			else
				interceptor.viewportOutsideRange.dispatch()

	window.addEventListener('scroll', -> interceptors.forEach(update))

	class Scrollceptor
		constructor: (@target, @options) ->
			@viewportInsideRange = new Signal()
			@viewportOutsideRange = new Signal()

			@status = null

			@options.axis or= 'y'

			if @options.axis is 'y'
				interceptors.push(this)
			else
				@target.addEventListener('scroll', => update(this))

	return {Scrollceptor}