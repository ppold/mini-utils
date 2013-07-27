define ['./raf'], (raf) ->
	{Animation} = raf

	class ScrollArrows
		constructor: (@slider, @previous, @next) ->
			for element in [@previous, @next]
				for eventType in ['mouseover', 'mouseout', 'mousedown', 'mouseup']
					element.addEventListener(eventType, this)

		handleEvent: (event) ->
			target = event.currentTarget

			switch event.type
				when 'mouseover'
					@update_direction(target, 1)
					@animation = new Animation(@simulate_scroll)
					@animation.start()
				when 'mousedown'
					@update_direction(target, 2)
				when 'mouseup'
					@update_direction(target, 1)
				when 'mouseout'
					@animation.stop()

		update_direction: (target, multiplier) ->
			if target is @previous
				@direction = -multiplier
			else if target is @next
				@direction = +multiplier

		simulate_scroll: (delta) =>
			@slider.scrollLeft += delta*@direction*.48

	return { ScrollArrows }