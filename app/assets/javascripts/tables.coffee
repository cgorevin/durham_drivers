tableRowClick = ->
  $('[data-href]').click (e) ->
    href = $(@).data 'href'
    cmd = e.metaKey # for mac support
    ctrl = e.ctrlKey # for windows support

    if ctrl || cmd # if user is pressing the command or ctrl key
      open href # open in new tab
    else
      # Turbolinks.visit href # simulate regular click
      window.location = href

$(window).on 'turbolinks:load', tableRowClick
