markAllAs = ->
  $('.js-mark-as').click ->
    value = @.text
    options = $ "option[value='#{value}']"
    options.prop 'selected', true

$(window).on 'turbolinks:load', markAllAs
