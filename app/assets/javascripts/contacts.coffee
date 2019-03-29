contactMethodToggle = ->
  container = $('.js-requestor-container')
  emailLabel = $('.js-email-label')
  phoneLabel = $('.js-phone-label')
  emailRadio = emailLabel.find('input')
  phoneRadio = phoneLabel.find('input')
  emailField = $('input[type=email]')
  phoneField = $('input[type=tel]')
  emailGroup = $('.js-email-group')
  phoneGroup = $('.js-phone-group')

  $('.js-contact-radio').change ->
    container.show()
    value = @.value
    if value == 'email'
      emailLabel.show()
      phoneLabel.hide()
      phoneRadio.prop 'checked', false
      emailGroup.show()
      emailField.removeAttr 'disabled'
      phoneGroup.hide()
      phoneField.attr 'disabled', ''
    else if value == 'phone'
      emailLabel.hide()
      phoneLabel.show()
      emailRadio.prop 'checked', false
      emailGroup.hide()
      emailField.attr 'disabled', ''
      phoneGroup.show()
      phoneField.removeAttr 'disabled'

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

toggleAdviceMethod = ->
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


$(window).on 'turbolinks:load', contactMethodToggle
$(window).on 'turbolinks:load', requestorNameToggle
$(window).on 'turbolinks:load', toggleAdviceMethod
