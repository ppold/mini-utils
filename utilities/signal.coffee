###
 * Short implementation of the signal pattern
###

define ->
  class Signal
    constructor: ->
      @slots = []

    ###
     * Adds the slot to the signal
     * @param  {Function} slot – The function to execute when dispatched
    ###
    add: (slot) ->
      @slots.push(slot)

    ###
     * Dispatches the signal to all the added slots
     * @param  {arguments} @values... List of arguments to send
    ###
    dispatch: (@values...) ->
      for slot in @slots
        slot(@values...)

  return Signal