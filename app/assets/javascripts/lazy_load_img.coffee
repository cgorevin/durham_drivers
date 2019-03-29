lazyLoadImg = ->
  $('[data-src]').each ->
    img = $(@)
    img.prop src: img.data 'src'

$(window).on 'turbolinks:load', lazyLoadImg
