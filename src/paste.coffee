define(['./promise', './dommy', './raf'], (Promise, dommy) ->
  {remove_itself, remove_new_lines} = dommy

  ###
   * Retrieves the clipboard data from 3 different sources
   * @param  {Event} event An event reference where the clipboard might reside.
  ###
  clipboard_data = (event) ->
    promise = new Promise()

    if event.clipboardData
      ###
       * Webkit
      ###
      event.preventDefault()

      # for the future: text/html
      data = event.clipboardData.getData('text/plain')
      promise.resolve(data)
    else if window.clipboardData
      ###
       * Trident
      ###
      event.preventDefault()
      data = window.clipboardData.getData('Text')
      promise.resolve(data)
    else
      ###
       * Gecko
      ###
      pasteTarget = document.createElement('div')
      pasteTarget.style.opacity = '0'
      pasteTarget.style.position = 'fixed'
      pasteTarget.setAttribute('contenteditable', 'true')
      document.body.appendChild(pasteTarget)
      pasteTarget.focus()

      originalTarget = event.currentTarget
      requestAnimationFrame(->
        data = ''
        for child in pasteTarget.children
          data += child.textContent.replace(/\n/g, '') + '\n'
        remove_itself(pasteTarget)

        originalTarget.focus()
        promise.resolve(data)
      )

    return promise

  return {clipboard_data}
)
