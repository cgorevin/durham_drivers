requestorNameToggle = ->
  $('.js-requestor-radio').change ->
    value = @.value
    field = $('.js-field')
    div = $('.js-div')

    if value == 'true'
      # show and enable name field
      div.css display: 'flex'
      field.removeAttr 'disabled'
    else
      # hide and disable name field
      div.hide()
      field.attr 'disabled', ''

contactMethodToggle = ->
  container = $('.js-requestor-container')
  emailOption = $('.js-email-option')
  phoneOption = $('.js-phone-option')
  emailRadio = emailOption.find('input')
  phoneRadio = phoneOption.find('input')
  emailField = $('input[type=email]')
  phoneField = $('input[type=tel]')

  $('.js-contact-radio').change ->
    container.show()
    value = @.value
    if value == 'email'
      emailOption.show()
      phoneOption.hide()
      phoneRadio.prop 'checked', false
      emailField.show().removeAttr 'disabled'
      phoneField.hide().attr 'disabled', ''
    else if value == 'phone'
      emailOption.hide()
      emailRadio.prop 'checked', false
      phoneOption.show()
      emailField.hide().attr 'disabled', ''
      phoneField.show().removeAttr 'disabled'

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

phoneNumberFormatter = ->
  $('.js-phone-format').on 'keyup', (e) ->
    return if e.keyCode == 8
    value = @.value
    number = value.replace /[^\d]/g, ''
    length = number.length

    formattedNumber = switch
      when 0 <= length <= 2
        number.replace /(\d+)/, '($1'
      when 3 <= length <= 5
        number.replace /(\d{3})(\d*)/, '($1) $2'
      when 6 <= length <= 10
        number.replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'
      else number.slice(0,10).replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'

    @.value = formattedNumber

$(window).on 'turbolinks:load', contactMethodToggle
$(window).on 'turbolinks:load', phoneNumberFormatter
$(window).on 'turbolinks:load', requestorNameToggle
$(window).on 'turbolinks:load', toggleAdviceMethod
