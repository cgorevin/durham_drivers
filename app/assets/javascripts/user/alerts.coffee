# jQuery version
closeAlert = ->
  $('[data-dismiss=alert]').click ->
    $(@).parent().remove()

$(window).on 'turbolinks:load', closeAlert

# native version
# closeAlert = ->
#   alert = document.querySelector('[data-dismiss=alert]')
#   if alert
#     alert.addEventListener 'click', ->
#       @.parentElement.remove()
#
# window.addEventListener 'turbolinks:load', closeAlert
