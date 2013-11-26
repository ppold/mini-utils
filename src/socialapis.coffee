define ->
  add_script = (id, url) ->
    root = document
    firstScript = root.getElementsByTagName('script')[0]
    return if root.getElementById(id)
    sdkScript = root.createElement('script')
    sdkScript.id = id
    sdkScript.src = url
    sdkScript.async = yes
    firstScript.parentNode.insertBefore(sdkScript, firstScript)

  configure = (fbAppId) ->
    add_script('facebook-jssdk', '//connect.facebook.net/es_LA/all.js#xfbml=1&appId='+fbAppId)
    add_script('twitter-wjs', '//platform.twitter.com/widgets.js')

  return { configure }
