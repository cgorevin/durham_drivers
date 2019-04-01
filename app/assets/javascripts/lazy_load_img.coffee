lazyLoadImg = ->
  $(window).scroll ->
    top = $(@).scrollTop()
    if top > 180
      $('[data-src]').each ->
        img = $(@)
        src = img.data 'src'
        fallback = img.data 'fallback'
        img.prepend("<source srcset='#{src}' type='image/webp'><source srcset='#{fallback}' type='image/jpeg'>")
      $(window).off 'scroll'

$(window).on 'turbolinks:load', lazyLoadImg
