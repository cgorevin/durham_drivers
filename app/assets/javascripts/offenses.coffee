markAllAs = ->
  $('.js-mark-as').click ->
    value = $(@).text()
    options = $ "option[value='#{value}']"
    options.prop 'selected', true

sendEmails = ->
  $('.js-send-emails').change ->
    initial = $(@).find('option[selected="selected"]').text()
    current = @.value
    btn = $('.btn-success')
    if initial != 'approved' && current == 'approved'
      btn.prop('value', 'Save and send emails')
    else
      btn.prop('value', 'Save')


validateCheckbox = ->
  $('.js-checkbox').change ->
    boxes = $ '.js-checkbox'
    buttons = $ '.btn-outline-info'
    submit = $ 'input[type="submit"]'
    submit.attr 'disabled', !boxes.is ':checked'
    # if 'name not present' checked, uncheck all others
    # if 'name not present' unchecked, don't do anything
    # if name checked, uncheck 'name not present'
    # if name unchecked, don't do anything
    blank = @.value == ''
    checked = $(@).is ':checked'
    if checked
      if blank
        boxes[0..-2].prop 'checked', false
        buttons[0..-2].removeClass('active')
      else
        boxes.last().prop 'checked', false
        buttons.last().removeClass('active')

$(window).on 'turbolinks:load', markAllAs
$(window).on 'turbolinks:load', sendEmails
$(window).on 'turbolinks:load', validateCheckbox
