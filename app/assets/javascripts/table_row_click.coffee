# jQuery version
tableRowClick = ->
  $('[data-href]').click (e) ->
    href = $(@).data 'href'
    cmd = e.metaKey # for mac support
    ctrl = e.ctrlKey # for windows support

    if ctrl || cmd # if user is pressing the command or ctrl key
      open href # open in new tab
    else
      # use full reload instead of turbolinks visit so that tooltip scripts load successfully on offenses#show page
      Turbolinks.visit href # simulate regular click

$(window).on 'turbolinks:load', tableRowClick

# native version
# tableRowClick = ->
#   document.querySelectorAll('[data-href]').forEach (e) -> e.addEventListener 'click', ->
#     href = @.dataset.href
#     cmd = e.metaKey # for mac support
#     ctrl = e.ctrlKey # for windows support
#
#     if ctrl || cmd # if user is pressing the command or ctrl key
#       open href # open in new tab
#     else
#       # use full reload instead of turbolinks visit so that tooltip scripts load successfully on offenses#show page
#       Turbolinks.visit href # simulate regular click
#
# window.addEventListener 'turbolinks:load', tableRowClick
