# jQuery version
sendEmails = ->
  $('.js-send-emails').change ->
    initial = $(@).find('option[selected="selected"]').text()
    current = @.value
    btn = $('.btn-success')
    if initial != 'approved' && current == 'approved'
      btn.prop('value', 'Save and send emails')
    else
      btn.prop('value', 'Save')

$(window).on 'turbolinks:load', sendEmails

# native version
# sendEmails = ->
#   document.querySelectorAll('.js-send-emails').forEach (elem) ->
#     elem.addEventListener 'change', ->
#       initial = @.querySelector('option[selected]').textContent
#       current = @.value
#       btn = document.querySelector '.btn-success'
#       if initial != 'approved' && current == 'approved'
#         btn.value = 'Save and send emails'
#       else
#         btn.value = 'Save'
#
# window.addEventListener 'turbolinks:load', sendEmails
