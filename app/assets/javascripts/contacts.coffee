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


$(window).on 'turbolinks:load', requestorNameToggle
$(window).on 'turbolinks:load', toggleAdviceMethod
