###
 * File Picker – picks a file, as simple as that
 * @param  {Object} options – An object that contains the following parameters:
 *                            {Boolean} multiple
 *                            {String}  mimetypes
 *                            {Number}  maxsize
 * @return {Promise} A nice promise
###

define(['./promise', './alchemy'], (Promise, alchemy) ->
  window.URL or= window.webkitURL

  {zip} = alchemy

  MAX_SIZE = 1024 * 1024 * 1 # in bytes
  FILE_TOO_BIG = 'File exceeds maximum size'

  read_file = (file) ->
    return [file, window.URL.createObjectURL(file)]

  verify_file = (file, options) ->
    if file.size > (options?.maxsize or MAX_SIZE)
      throw FILE_TOO_BIG

  prompt_file_picker = (options) ->
    handler = (event) ->
      promise.resolve(input.files)

    input = document.createElement('input')
    input.setAttribute('type', 'file')
    input.setAttribute('accept', options?.mimetypes)
    if options?.multiple
      input.setAttribute('multiple', 'true')
    input.style.display = 'none'
    input.addEventListener('change', handler)

    document.body.appendChild(input)
    input.click()
    input.parentNode.removeChild(input)

    promise = new Promise()
    return promise

  pick_file = (options) ->
    prompt_file_picker(options).then (files) ->
      try
        for file in files
          verify_file(file, options)
      catch e
        promise.reject(e)
        return

      objectURLs = Array::map.call(files, read_file)
      promise.resolve objectURLs

    promise = new Promise()
    return promise

  return {FILE_TOO_BIG, open:pick_file}
)