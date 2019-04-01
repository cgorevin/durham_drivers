# jQuery version
markAllAs = ->
  $('.js-mark-as').click ->
    value = $(@).text()
    options = $ "option[value='#{value}']"
    options.prop 'selected', true

$(window).on 'turbolinks:load', markAllAs

# native version
# markAllAs = ->
#   document.querySelectorAll('.js-mark-as').forEach (elem) ->
#     elem.addEventListener 'click', ->
#       value = @.textContent
#       options = document.querySelectorAll "option[value='#{value}']"
#       options.forEach (elem) -> elem.selected = true
#
# window.addEventListener 'turbolinks:load', markAllAs
