define ->
  expand = (uri, data) ->
    return uri.replace(/\{(\w+)\}/g, (match, g1) ->
      return escape(data[g1])
    )

  return { expand }