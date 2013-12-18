define(['./promise'], (Promise) ->
  ###
   * XmlHTTPRequest abstraction that uses the promise pattern
   * @param  {String}     url     URL to request.
   * @param  {Object}     data    Data to send.
   * @param  {Dictionary} headers Headers to send.
   * @return {Promise}            A promise.
  ###
  xhr = (url, data, headers, method) ->
    handler = (event) ->
      if request.readyState is 4
        request.removeEventListener(event.type, handler)
        promise.resolve(request.status, request.response)

    promise = new Promise()

    request = new XMLHttpRequest()
    request.open(method, url)

    for header, value of headers
      request.setRequestHeader(header, value)

    request.addEventListener('readystatechange', handler)
    request.send(data)

    return promise

  get = (url, data, headers) ->
    xhr(url, data, headers, 'GET')

  options = (url, data, headers) ->
    xhr(url, data, headers, 'OPTIONS')

  post = (url, data, headers) ->
    xhr(url, data, headers, 'POST')

  put = (url, data, headers) ->
    xhr(url, data, headers, 'PUT')

  calls = 0
  jsonp = (url) ->
    promise = new Promise()

    callbackID = 'jsonp_callback'+(++calls)
    url += '&callback=' + callbackID
    script = add_script_tag(url)
    window[callbackID] = generate_closure(callbackID, script, promise)

    return promise

  add_script_tag = (url) ->
    head = document.getElementsByTagName('head')[0]
    script = document.createElement('script')
    script.async = yes
    script.type = 'application/javascript'
    script.src = url
    head.appendChild(script)

    return script

  generate_closure = (callbackID, script, promise) ->
    return (data) ->
      script.parentNode.removeChild(script)
      promise.resolve(data)
      delete window[callbackID]

  return {
    get, options, post, put, jsonp
  }
)
