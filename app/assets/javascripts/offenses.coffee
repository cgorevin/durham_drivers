markAllAs = ->
  $('.js-mark-as').click ->
    value = @.text
    options = $ "option[value='#{value}']"
    options.prop 'selected', true

validateCheckbox = ->
  $('.js-checkbox').click ->
    boxes = $ '.js-checkbox'
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
      else
        boxes.last().prop 'checked', false

$(window).on 'turbolinks:load', markAllAs
$(window).on 'turbolinks:load', validateCheckbox
