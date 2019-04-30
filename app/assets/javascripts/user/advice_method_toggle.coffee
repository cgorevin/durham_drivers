# jQuery version
adviceMethodToggle = ->
  emailArea = $('.email-area')
  addressArea = $('.address-area')
  $('.js-advice-radio').change ->
    value = @.value
    if value == 'email'
      # show and enable email field
      emailArea.show().find('input').removeAttr 'disabled'
      # hide and disable address fields
      addressArea.hide().find('input,select').attr 'disabled', ''
    else if value == 'postal'
      # show and enable address fields
      addressArea.show().find('input,select').removeAttr 'disabled'
      # hide and disable email fields
      emailArea.hide().find('input').attr 'disabled', ''

$(window).on 'turbolinks:load', adviceMethodToggle

# native version
# adviceMethodToggle = ->
#   hide = (elem) ->
#     elem.style.display = 'none'
#     elem.querySelectorAll('input,select').forEach (elem) ->
#       elem.disabled = 'disabled'
#
#   show = (elem) ->
#     elem.style.display = 'block'
#     elem.querySelectorAll('input,select').forEach (elem) ->
#       elem.removeAttribute 'disabled'
#
#   toggle = ->
#     value = @.value
#     if value == 'email'
#       # show and enable email field
#       show emailArea
#       # hide and disable address fields
#       hide addressArea
#     else if value == 'postal'
#       # show and enable address fields
#       show addressArea
#       # hide and disable email fields
#       hide emailArea
#
#   emailArea = document.querySelector '.email-area'
#   addressArea = document.querySelector '.address-area'
#
#   radios = document.querySelectorAll '.js-advice-radio'
#   radios.forEach (elem) ->
#     elem.onchange = toggle
#
# window.addEventListener 'turbolinks:load', adviceMethodToggle
