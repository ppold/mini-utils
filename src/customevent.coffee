define ->
	CustomEvent = (type, params) ->
		params = params or { bubbles: false, cancelable: false, detail: undefined }
		event = document.createEvent('CustomEvent')
		event.initCustomEvent(type, params.bubbles, params.cancelable, params.detail)
		return event

	CustomEvent.prototype = window.CustomEvent.prototype

	window.CustomEvent = CustomEvent

	return CustomEvent
