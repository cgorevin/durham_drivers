# jQuery version
# lazyLoadImg = ->
#   $(window).scroll ->
#     top = $(@).scrollTop()
#     if top > 100
#       $('[data-src]').each ->
#         img = $(@)
#         src = img.data 'src'
#         fallback = img.data 'fallback'
#         img.prepend "<source srcset='#{src}' type='image/webp'><source srcset='#{fallback}' type='image/jpeg'>"
#       $(window).off 'scroll'
#
# $(window).on 'turbolinks:load', lazyLoadImg

# native version
lazyLoadImg = ->
  load = ->
    top = @.scrollY
    if top > 100
      document.querySelectorAll('[data-src]').forEach (picture) ->
        src = picture.dataset.src
        fallback = picture.dataset.fallback

        main = document.createElement 'source'
        main.srcset = src
        main.type = 'image/webp'

        backup = document.createElement 'source'
        backup.srcset = fallback
        backup.type = 'image/jpeg'

        img = picture.querySelector 'img'
        picture.insertBefore main, img
        picture.insertBefore backup, img
      window.removeEventListener 'scroll', load

  window.addEventListener 'scroll', load

window.addEventListener 'turbolinks:load', lazyLoadImg
