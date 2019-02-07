requestorNameToggle = ->
  $('.js-radio').change ->
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

$(window).on 'turbolinks:load', requestorNameToggle
