# jQuery version
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

$(window).on 'turbolinks:load', validateCheckbox

# native version
# validateCheckbox = ->
#   boxes = Array.from document.querySelectorAll('.js-checkbox')
#   boxes.forEach (elem) ->
#     elem.addEventListener 'change', ->
#       buttons = Array.from document.querySelectorAll('.btn-outline-info')
#       submit = document.querySelector 'input[type="submit"]'
#       checked_count = 0
#       boxes.forEach (e) -> if e.checked then checked_count += 1
#       # disable submit button if any are checked
#       submit.disabled = !checked_count
#       # if 'name not present' checked, uncheck all others
#       # if 'name not present' unchecked, don't do anything
#       # if name checked, uncheck 'name not present'
#       # if name unchecked, don't do anything
#       blank = @.value == ''
#       checked = @.checked
#       if checked
#         if blank
#           boxes[0..-2].forEach (e) -> e.checked = false
#           buttons[0..-2].forEach (e) -> e.classList.remove 'active'
#         else
#           boxes[boxes.length - 1].checked = false
#           buttons[buttons.length - 1].classList.remove 'active'
#
# window.addEventListener 'turbolinks:load', validateCheckbox
