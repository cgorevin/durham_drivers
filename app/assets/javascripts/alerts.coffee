closeAlert = ->
  $('[data-dismiss=alert]').click ->
    $(@).parent().remove()

$(window).on 'turbolinks:load', closeAlert
