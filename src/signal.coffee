###
 * Short implementation of the signal pattern
###

define ->
	class Signal
		constructor: ->
			@slots = []
			@slotsOnce = []

		###
		 * Adds the slot to the signal
		 * @param  {Function} slot – The function to execute when dispatched
		###
		add: (slot) ->
			idx = @slotsOnce.indexOf(slot)
			if idx > -1
				@slotsOnce.splice(idx, 1)

			@slots.push(slot)

		addOnce: (slot) ->
			idx = @slots.indexOf(slot)
			if idx > -1
				@slots.splice(idx, 1)

			@slotsOnce.push(slot)

		remove: (slot) ->
			index = @slots.indexOf(slot)
			if index isnt -1
				@slots.splice(index, 1)

		###
		 * Dispatches the signal to all the added slots
		 * @param  {arguments} @values... List of arguments to send
		###
		dispatch: (@values...) ->
			for slot in @slots.concat(@slotsOnce)
				slot(@values...)

			@slotsOnce.length = 0

	return Signal
