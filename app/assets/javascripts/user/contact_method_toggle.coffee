# jQuery version
# contactMethodToggle = ->
#   hide = (container, field, label) ->
#     container.hide()
#     field.attr 'disabled', ''
#     label.hide()
#
#   show = (container, field, label) ->
#     container.show()
#     field.removeAttr 'disabled'
#     label.show()
#
#   toggle = ->
#     container.show()
#     value = @.value
#     if value == 'email'
#       show emailGroup, emailField, emailLabel
#       hide phoneGroup, phoneField, phoneLabel
#     else if value == 'phone'
#       show phoneGroup, phoneField, phoneLabel
#       hide emailGroup, emailField, emailLabel
#
#   container = $ '.js-requestor-container'
#   emailLabel = $ '.js-email-label'
#   phoneLabel = $ '.js-phone-label'
#   emailField = $ 'input[type=email]'
#   phoneField = $ 'input[type=tel]'
#   emailGroup = $ '.js-email-group'
#   phoneGroup = $ '.js-phone-group'
#
#   $('.js-contact-radio').change toggle
# $(window).on 'turbolinks:load', contactMethodToggle

# native version
# https://github.com/jackocnr/intl-tel-input/wiki/Converting-jQuery-to-JavaScript
contactMethodToggle = ->
  hide = (container, field, label) ->
    # hide container, disable field, hide label
    container.style.display = 'none'
    field.disabled = 'disabled'
    label.style.display = 'none'

  show = (container, field, label) ->
    # show container, enable field, show label
    container.style.display = 'flex'
    field.removeAttribute 'disabled'
    label.style.display = 'inline-block'

  toggle = ->
    # show container
    container.style.display = 'block'
    #  get value of radio button
    value = @.value
    if value == 'email'
      show emailGroup, emailField, emailLabel
      hide phoneGroup, phoneField, phoneLabel
    else if value == 'phone'
      show phoneGroup, phoneField, phoneLabel
      hide emailGroup, emailField, emailLabel

  radios = document.querySelectorAll '.js-contact-radio'
  if radios.length
    container = document.querySelector '.js-requestor-container'
    emailLabel = document.querySelector '.js-email-label'
    phoneLabel = document.querySelector '.js-phone-label'
    emailField = document.querySelector 'input[type=email]'
    phoneField = document.querySelector 'input[type=tel]'
    emailGroup = document.querySelector '.js-email-group'
    phoneGroup = document.querySelector '.js-phone-group'

    radios.forEach (elem) ->
      elem.onchange = toggle
window.addEventListener 'turbolinks:load', contactMethodToggle
