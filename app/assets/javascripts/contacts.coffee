requestorNameToggle = ->
  $('.js-requestor-radio').change ->
    value = @.value
    field = $('.js-field')
    div = $('.js-div')

    if value == 'true'
      # show and enable name field
      div.show()
      field.removeAttr 'disabled'
    else
      # hide and disable name field
      div.hide()
      field.attr 'disabled', ''

contactMethodToggle = ->
  emailOption = $('.js-email-option')
  phoneOption = $('.js-phone-option')
  emailRadio = emailOption.find('input')
  phoneRadio = phoneOption.find('input')
  emailField = $('input[type=email]')
  phoneField = $('input[type=tel]')

  $('.js-contact-radio').change ->
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

# function phoneFormatter() {
#   $('.phone').on('input', function() {
#     var number = $(this).val().replace(/[^\d]/g, '');
#     if (number.length == 7) {
#       number = number.replace(/(\d{3})(\d{4})/, "$1-$2");
#     } else if (number.length == 10) {
#       number = number.replace(/(\d{3})(\d{3})(\d{4})/, "($1) $2-$3");
#     };
#     $(this).val(number);
#   });
# };

amountFormatter = ->
  # used to detect on keyup but was causing bug with /settings.coffee amount reader, it would be delayed
  # you would type 1 and get 0.01 and the amount from the ajax request would not change
  # you would type 2 again and get 0.11 and the amount from the ajax request would be 0.01, always a step behind
  # listening to input event fixes it
  $('.js-amount').on 'input', (e) ->
    # this amount formatter is not the one that does the api request
    console.log 'amountFormatter running'

    # don't do anything if the key was up or down arrow keys
    return if e.keyCode == 38 || e.keyCode == 40
    number = $(@).val()
      # remove all non-digit characters (a-z, symbols, periods), replaces number_field behavior
      .replace(/[^\d]/g,'')
      # remove all leading zeros
      .replace(/^0+/,'')

    # format the number based on length
    number = switch number.length
      when 0 then '0.00'
      when 1 then number.replace /(\d+)/, '0.0$1'
      when 2 then number.replace /(\d{2})/, '0.$1'
      else number.replace /(\d+)(\d{2})/, '$1.$2'

    console.log "amountFormatter number: #{number}"
    $(@).val number

$(window).on 'turbolinks:load', amountFormatter

phoneNumberFormatter = ->
  prevLength = 0
  $('.js-phone-format').on 'input', ->
    value = @.value
    currentLength = value.length
    shorterThanBefore = currentLength < prevLength
    prevLength = currentLength
    return if shorterThanBefore
    number = @.value.replace /[^\d]/g, ''
    length = number.length

    formattedNumber = switch
      when length == 0
        ''
      when 1 <= length <= 2
        number.replace /(\d+)/, '($1'
      when 3 <= length <= 5
        number.replace /(\d{3})(\d*)/, '($1) $2'
      when 6 <= length <= 10
        number.replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'
      else number.slice(0,10).replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'

    @.value = formattedNumber
    console.log number
    console.log formattedNumber

$(window).on 'turbolinks:load', contactMethodToggle
$(window).on 'turbolinks:load', phoneNumberFormatter
$(window).on 'turbolinks:load', requestorNameToggle
