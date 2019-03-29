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


# function lazy_load(){
#   $('.lazy').each(function(img){
#     var scrollTop = window.pageYOffset;
#     var this_offset=$(this).offset().top + $(this).outerHeight();
#     var window_offset=$(window).scrollTop()+ $(window).height();
#     if($(this).offset().top + $(this).outerHeight() <= ($(window).scrollTop()+ $(window).height())){
#       var path_src=$(this).attr('data-name');
#       var split_data=path_src.split('|');
#       var img_html='<picture>'+
#         '<source srcset="'+split_data[0]+'.webp" type="image/webp">'+
#         '<source srcset="'+split_data[0]+split_data[1]+'" type="image/'+split_data[1].replace('.','')+'">'+
#         '<img src="'+split_data[0]+split_data[1]+'" alt="'+split_data[2]+'" class="'+split_data[3]+'">'+
#         '</picture>';
#       $(this).html(img_html);
#       $(this).show(1000);
#       $(this).removeClass('lazy');
#     }
#   });
# }
