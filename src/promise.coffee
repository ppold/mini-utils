define ->
  ###
   * Short implementation of the promise pattern
  ###
  DEFERRED = 0
  REJECTED = 1
  RESOLVED = 2

  class Promise
    constructor: ->
      @status = DEFERRED
      @response = null
      @resolvedCallbacks = []
      @rejectedCallbacks = []

    ###*
     * Subscribes the callback to the promise's execution
     * @param  {Function} callback The function to execute when resolved
    ###
    then: (callback) ->
      if @status is RESOLVED
        callback(@values...)
      else if @status is DEFERRED
        @resolvedCallbacks.push(callback)

      return this

    fail: (callback) ->
      if @status is REJECTED
        callback(@values...)
      else if @status is DEFERRED
        @rejectedCallbacks.push(callback)

      return this

    ###*
     * Executes all the subscribed callbacks with the returned values
     * @param  {arguments} @values... List of arguments to send
    ###
    resolve: (@values...) ->
      if @status is RESOLVED
        throw 'Promise already resolved!'
      else if @status is REJECTED
        throw 'Can\'t resolve a promise that has been rejected!'

      for callback in @resolvedCallbacks
        callback(@values...)

      @resolvedCallbacks.length = 0
      @resolvedCallbacks = null

      @status = RESOLVED

    reject: (@values...) ->
      if @status is REJECTED
        throw 'Promise already rejected!'
      else if @status is RESOLVED
        throw 'Can\'t reject a promise that has been resolved!'

      for callback in @rejectedCallbacks
        callback(@values...)

      @rejectedCallbacks.length = 0
      @rejectedCallbacks = null

      @status = REJECTED

    @all: (promises) ->
      data = []
      handler = (rest...) ->
        data.push(rest)
        completed++
        if completed is length
          promise.resolve(data)

      length = promises.length
      completed = 0
      for promise in promises
        promise.then(handler)

      promise = new Promise()
      return promise

  return Promise