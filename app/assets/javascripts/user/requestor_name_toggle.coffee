# jQuery version
requestorNameToggle = ->
  $('.js-requestor-radio').change ->
    value = @.value
    field = $('.js-field')
    div = $('.js-div')

    if value == 'other'
      # show and enable name field
      div.show()
      field.removeAttr 'disabled'
    else
      # hide and disable name field
      div.hide()
      field.attr 'disabled', ''

$(window).on 'turbolinks:load', requestorNameToggle

# native version
# requestorNameToggle = ->
#   toggle = ->
#     value = @.value
#     field = document.querySelector '.js-field'
#     div = document.querySelector '.js-div'
#
#     if value == 'other'
#       # show and enable name field
#       div.style.display = 'block'
#       field.removeAttribute 'disabled'
#     else
#       # hide and disable name field
#       div.style.display = 'none'
#       field.disabled = 'disabled'
#
#   radios = document.querySelectorAll '.js-requestor-radio'
#   radios.forEach (elem) ->
#     elem.onchange = toggle
#
# window.addEventListener 'turbolinks:load', requestorNameToggle
