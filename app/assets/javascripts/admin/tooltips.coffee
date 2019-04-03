initializeTooltips = ->
  $('[data-toggle="tooltip"]').tooltip()

$(window).on 'turbolinks:load', initializeTooltips
