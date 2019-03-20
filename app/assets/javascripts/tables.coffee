tableRowClick = ->
  $('[data-href]').click ->
    Turbolinks.visit $(@).attr 'data-href'

$(window).on 'turbolinks:load', tableRowClick
