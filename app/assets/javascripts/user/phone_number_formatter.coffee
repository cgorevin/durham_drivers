# jQuery version
# phoneNumberFormatter = ->
#   $('.js-phone-format').on 'keyup', (e) ->
#     return if e.keyCode == 8
#     value = @.value
#     number = value.replace /[^\d]/g, ''
#     length = number.length
#
#     formattedNumber = switch
#       when 0 <= length <= 2
#         number.replace /(\d+)/, '($1'
#       when 3 <= length <= 5
#         number.replace /(\d{3})(\d*)/, '($1) $2'
#       when 6 <= length <= 10
#         number.replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'
#       else number.slice(0,10).replace /(\d{3})(\d{3})(\d*)/, '($1) $2-$3'
#
#     @.value = formattedNumber
#
# $(window).on 'turbolinks:load', phoneNumberFormatter

# native version
phoneNumberFormatter = ->
  phoneField = document.querySelector '.js-phone-format'

  if phoneField
    phoneField.addEventListener 'keyup', (e) ->
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

window.addEventListener 'turbolinks:load', phoneNumberFormatter
