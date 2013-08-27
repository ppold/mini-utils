define ->
  next_sibling_or_parent = (node) ->
    sibling = node.nextSibling
    if sibling
      node = sibling
    else
      node = node.parentNode

    return node

  whole_text_offset = (node) ->
    startOffset = 0

    previousSibling = node.previousSibling
    while previousSibling instanceof Text
      startOffset += previousSibling.length
      previousSibling = previousSibling.previousSibling

    return startOffset

  class Range
    @START: 1
    @END: 2

    @ACCEPT: 3
    @REJECT: 4
    @SKIP: 5

    @_range: null

    @clone_range: (range) ->
      return new Range(range._range.cloneRange())

    constructor: (primitive, splitAtOffsets = yes) ->
      if primitive
        primitive = primitive.cloneRange()
        if splitAtOffsets
          {startContainer, startOffset, endContainer, endOffset} = primitive

          if endOffset isnt 0
            if endContainer instanceof Text
              endContainer.splitText(endOffset)
              endOffset = endContainer.length

            to = endContainer

          if startOffset isnt 0
            if startContainer instanceof Text
              from = startContainer.splitText(startOffset)
              startOffset = 0

              if startContainer is to
                to = from
                endOffset = to.length
            else
              from = startContainer

          if from
            primitive.setStart(from, startOffset)

          if to
            primitive.setEnd(to, endOffset)

        @_range = primitive
      else
        @_range = document.createRange()

    select: (from, to) ->
      @start(from).end(to)
      return this

    start: (node) ->
      @_range.setStart(node, 0)
      return this

    end: (node) ->
      if node instanceof Text
        offset = node.length
      else if node.hasChildNodes()
        offset = node.childNodes.length

      @_range.setEnd(node, offset)
      return this

    start_after: (node) ->
      @_range.setStartAfter(node)
      return this

    start_before: (node) ->
      @_range.setStartBefore(node)
      return this

    end_after: (node) ->
      @_range.setEndAfter(node)
      return this

    end_before: (node) ->
      @_range.setEndBefore(node)
      return this

    select_node: (node) ->
      @_range.selectNode(node)
      return this

    select_node_contents: (node) ->
      @_range.selectNodeContents(node)
      return this

    collapse: (where) ->
      if where isnt @START and where isnt @END
        throw "parameter isn't the start or the end of the range."
      else
        @_range.collapse(where)

      return this

    clone: ->
      return @_range.cloneContents()

    delete: ->
      @_range.deleteContents()
      @dispose()
      return this

    extract: ->
      clonedRange = @_range.cloneRange()
      fragment = clonedRange.extractContents()
      clonedRange.detach()
      @start_after(@from())

      return fragment

    insert: (node) ->
      @_range.insertNode(node)
      return this

    dispose: ->
      @_range.detach()
      return this

    text: ->
      return @_range.toString()

    single_node: ->
      return @_range.startContainer is @_range.endContainer is
             @_range.commonAncestorContainer

    from: ->
      return @_range.startContainer

    to: ->
      return @_range.endContainer

    ascendant: ->
      return @_range.commonAncestorContainer

    collapsed: ->
      return @_range.collapsed

    walk: (filter = -> Range.ACCEPT) ->
      parents = []
      nextNode = @from()
      endpoint = @to()
      previousNode = null

      return ->
        currentNode = nextNode

        until response is Range.ACCEPT or nextNode is null
          node = nextNode

          if nextNode is endpoint or
             (response is Range.REJECT and nextNode instanceof HTMLElement and nextNode.contains(endpoint))
            nextNode = null
            break
          else if nextNode.hasChildNodes() and
              response isnt Range.REJECT and
              not nextNode.contains(previousNode)
            parents.push(nextNode)
            nextNode = nextNode.firstChild
          else
            nextNode = next_sibling_or_parent(nextNode)
            until parents.indexOf(nextNode) is -1
              nextNode = next_sibling_or_parent(nextNode)

          previousNode = node

          response = filter(nextNode)

        return currentNode

    normalize_ascendant: ->
      rangeContainsASingleNode = @single_node()
      unless rangeContainsASingleNode
        from = @from()
        to = @to()

        startOffset = whole_text_offset(from)
        endOffset = whole_text_offset(to) + to.length

      @ascendant().normalize()

      unless rangeContainsASingleNode
        from = @from()
        to = @to()

        startAndEndpointsAreTheSame = from is to

        if startAndEndpointsAreTheSame
          endOffset -= startOffset

        if from instanceof Text and startOffset > 0
          replacementNode = from.splitText(startOffset)
          @start(replacementNode)

          if startAndEndpointsAreTheSame
            to = replacementNode

        if to instanceof Text and endOffset > 0
          to.splitText(endOffset)
          @end(to)

    split_ascendant: (customAncestor) ->
      ancestor = customAncestor or @ascendant()
      parent = ancestor.parentNode

      start = @from()
      end = @to()

      firstChildIsOrigin = ancestor.firstChild is start
      lastChildIsEnd = ancestor.lastChild is end
      fragment = @extract()

      newStart = fragment.firstChild
      newEnd = fragment.lastChild

      if firstChildIsOrigin and lastChildIsEnd
        parent.replaceChild(fragment, ancestor)
      else unless firstChildIsOrigin or lastChildIsEnd
        el = document.createElement(ancestor.tagName)
        el.appendChild(
          new Range().start_after(end).end(ancestor.lastChild).extract()
        )
        parent.insertBefore(el, ancestor.nextSibling)

        parent.insertBefore(fragment, ancestor.nextSibling)
      else if firstChildIsOrigin
        parent.insertBefore(fragment, ancestor)
        if ancestor.textContent.match(/^\s*$/)
          parent.removeChild(ancestor)
      else if lastChildIsEnd
        parent.insertBefore(fragment, ancestor.nextSibling)

      return new Range().select(newStart, newEnd)

  return Range
