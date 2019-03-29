lazyLoadImg = ->
  $(window).scroll ->
    top = $(@).scrollTop()
    if top > 180
      $('[data-src]').each ->
        img = $(@)
        img.prop src: img.data 'src'
      $(window).off 'scroll'

$(window).on 'turbolinks:load', lazyLoadImg
