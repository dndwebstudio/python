$.fn.jewDream = ()->
  $active_now = false
  if !$('body>div').is('#jewDreamGalleryArea')
    $('body').append('<div id="jewDreamGalleryArea"></div>')
    $active_now = true

  $(@).on 'click', ()->
    console.log '1'
    $bxItemID = $(@).attr 'data-id'
    $startedPicture = $(@).attr 'data-photo'
    csrf = $(@).attr 'data-csrf'
    $isUser = false
    $userID = false
    if $(@).attr('data-type') == "user"
      $isUser = true
      $userID = $(@).attr('data-uid')

    $.ajax {
      url: "/ajax/jew_dream_get_gallery/"
      type: "POSt"
      data: {itemID: $bxItemID, user: $isUser, userID:$userID, csrfmiddlewaretoken: csrf}
      beforeSend: ()->
        initGalery()
      success: (data)->
        $area = $(document).find 'div#jewDreamGalleryArea'
        if data
          data = JSON.parse(htmlSpecialChar_decode(data))
          $navLine = 0;
          data.forEach (el, i)->
            $area.find('.jdga_gs_mian_slider').append '<img data-ind="'+(i+1)+'" src="'+el['full']+'" data-id="'+el['id']+'"/>'
            $area.find('.jdga_gs_mirror_slider_inner').append '<li data-ind="'+(i+1)+'" data-id="'+el['id']+'"><img src="'+el['resize']+'"/></li>'
#            $navLine += parseInt($area.find('.jdga_gs_mirror_slider_inner>li').eq(-1).innerWidth());
#            console.log $navLine

          if $startedPicture
            $area.find('.jdga_gs_mian_slider>img').each ()->
              if $(@).attr('data-id') == $startedPicture
                $(@).addClass('activeJD')
                $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$(@).attr('data-id')+'"]').addClass('activeJD')

          else
            $area.find('.jdga_gs_mian_slider>img').eq(0).addClass('activeJD')
            $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$area.find('.jdga_gs_mian_slider>img').eq(0).attr('data-id')+'"]').addClass('activeJD')

          $area.find('.jdga_gallery_preloader').animate {opacity:0},250,()->
            $(document).find('.jdga_gallery').removeClass('jdga_gallery_onLoad')
            $(@).css {display:'none'}
            $area.find('.jdga_gallery_sliders').css {display:'block',opacity:0}
#            $lastWidth = 0
            $area.find('.jdga_gs_mirror_slider_inner>li').each ()->
              $(@).attr 'data-prevWidth', $navLine
              $navLine += parseInt($(@).innerWidth())+16
              $lastWidth = parseInt($(@).innerWidth())+16
              $(@).attr 'data-postWidth', $navLine
#            $navLine = $navLine+$lastWidth
            if $navLine > $area.find('.jdga_gs_mirror_slider_out').innerWidth()
              $area.find('.jdga_gs_mirror_slider_inner').css {width: $navLine+"px"}
            $area.find('.jdga_gs_mirror_slider_inner').attr {"data-width":$navLine}
            $area.find('.jdga_gallery_sliders').animate {opacity:1},250

        else
          $area.html ""
    }

    return false
  if $active_now
    $(document). on 'click', '.jdga_gs_close', ()->
      $area = $(document).find 'div#jewDreamGalleryArea'
      $area.find('.jdga_gallery').animate {opacity: 0}, 250, ()->
        $area.html ''

    $('body').keydown (eventObject)->
      if $('.jdga_gs_close').is('div')
        if eventObject.which == 27
          $(document).find('.jdga_gs_close').trigger 'click'
    $(document).on 'click', '.jdga_gallery_onLoad', ()->
      $(document).find('.jdga_gs_close').trigger 'click'

    $(document).on 'click', '.jdga_gs_mian_prev, .jdga_gs_mian_next', ()->
      $area = $(document).find 'div#jewDreamGalleryArea'
      $actSlide = $area.find('.jdga_gs_mian_slider>img.activeJD')
      $ind = $actSlide.attr 'data-ind'
      if $(@).hasClass('jdga_gs_mian_prev')
        $ind = parseInt($ind)-1
        if $ind < 1
          $ind = $area.find('.jdga_gs_mian_slider>img').eq(-1).attr 'data-ind'
      else
        $ind = parseInt($ind)+1
        console.log $ind

      if !$area.find('.jdga_gs_mian_slider>img[data-ind="'+$ind+'"]').is('img')
        $nextSlide = $area.find('.jdga_gs_mian_slider>img[data-ind="1"]')
      else
        $nextSlide = $area.find('.jdga_gs_mian_slider>img[data-ind="'+$ind+'"]')

      $actSlide.animate {opacity:0},150,()->
        $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$actSlide.attr('data-id')+'"]').removeClass('activeJD')
        $actSlide.removeClass 'activeJD'
        $nextSlide.css {opacity:0}
        $nextSlide.addClass 'activeJD'
        $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$nextSlide.attr('data-id')+'"]').addClass('activeJD')
        $nextSlide.animate {opacity: 1}, 150

        $thisLeft = parseInt($area.find('.jdga_gs_mirror_slider_inner').css('left').replace("px","").replace("-",""))
        $outWidth = parseInt($area.find('.jdga_gs_mirror_slider_out').innerWidth())
        $miniElemPrev = $area.find('.jdga_gs_mirror_slider_inner').find('li.activeJD').attr 'data-prevWidth'
        $miniElemPost = $area.find('.jdga_gs_mirror_slider_inner').find('li.activeJD').attr 'data-postWidth'
        $scrollLeft = false

        if $miniElemPrev < $thisLeft
          $scrollLeft = parseInt($miniElemPrev)
        else if $miniElemPost > ($outWidth+$thisLeft)
          $scrollLeft = parseInt($miniElemPost)-$outWidth

        if $scrollLeft >= 0
          $area.find('.jdga_gs_mirror_slider_inner').animate {left:"-"+$scrollLeft+"px"},200

    $(document).on 'click', '.jdga_gs_mirror_slider_inner>li', ()->
      $area = $(document).find 'div#jewDreamGalleryArea'
      $actSlide = $area.find('.jdga_gs_mian_slider>img.activeJD')
      $nextSlide = $area.find('.jdga_gs_mian_slider>img[data-id="'+$(@).attr('data-id')+'"]')
      $actSlide.animate {opacity:0},150,()->
        $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$actSlide.attr('data-id')+'"]').removeClass('activeJD')
        $actSlide.removeClass 'activeJD'
        $nextSlide.css {opacity:0}
        $nextSlide.addClass 'activeJD'
        $area.find('.jdga_gs_mirror_slider_inner').find('li[data-id="'+$nextSlide.attr('data-id')+'"]').addClass('activeJD')
        $nextSlide.animate {opacity: 1}, 150

    $(document).on 'click', '.jdga_gs_mirror_prev, .jdga_gs_mirror_next', ()->
      $area = $(document).find 'div#jewDreamGalleryArea'
      if parseInt($area.find('.jdga_gs_mirror_slider_inner').innerWidth()) > parseInt($area.find('.jdga_gs_mirror_slider_out').innerWidth())
        $scrollLeft = 0
        $thisWidth = parseInt($area.find('.jdga_gs_mirror_slider_inner').innerWidth())
        $thisLeft = parseInt($area.find('.jdga_gs_mirror_slider_inner').css('left').replace("px","").replace("-",""))
        $outWidth = parseInt($area.find('.jdga_gs_mirror_slider_out').innerWidth())
        if $(@).hasClass('jdga_gs_mirror_prev')
          $ind = false
          $area.find('.jdga_gs_mirror_slider_inner>li').each ()->
            if $(@).attr('data-prevWidth') < $thisLeft
              $ind = $(@).attr 'data-ind'
          if $ind
            if $ind > 1
              $ind = parseInt($ind)-1
            $scrollLeft = $area.find('.jdga_gs_mirror_slider_inner>li[data-ind="'+$ind+'"]').attr 'data-prevWidth'
          else
            $scrollLeft = false
        else
          $ind = false
          $area.find('.jdga_gs_mirror_slider_inner>li').each ()->
            if $(@).attr('data-postWidth') > ($thisLeft+$outWidth) and !$ind
              $ind = $(@).attr 'data-ind'
          if $ind
            if $area.find('.jdga_gs_mirror_slider_inner>li[data-ind="'+(parseInt($ind)+1)+'"]').is('li')
              $ind = parseInt($ind)+1
            $scrollLeft = parseInt($area.find('.jdga_gs_mirror_slider_inner>li[data-ind="'+$ind+'"]').attr 'data-postWidth')-$outWidth
          else
            $scrollLeft = false

        console.log $scrollLeft
        if $scrollLeft >= 0
          $area.find('.jdga_gs_mirror_slider_inner').animate {left:"-"+$scrollLeft+"px"},200

    $(window).resize ()->
      $area = $(document).find 'div#jewDreamGalleryArea'
      winHeight = window.innerHeight
      sliderHeight = winHeight-140
      $area.find('.jdga_gs_mian').css {height:sliderHeight+"px"}

      $navLine = parseInt($area.find('.jdga_gs_mirror_slider_inner').attr 'data-width')
      if $navLine > $area.find('.jdga_gs_mirror_slider_out').innerWidth()
        $area.find('.jdga_gs_mirror_slider_inner').css {width: $navLine+"px"}
      else
        $area.find('.jdga_gs_mirror_slider_inner').css {width: '100%', left: 0}





  initGalery = ()->
    $area = $(document).find 'div#jewDreamGalleryArea'
    $area.append '<div class="jdga_gallery jdga_gallery_onLoad">
<div class="jdga_gallery_backLayout"></div>
<div class="jdga_gallery_preloader">
  <div class="jdga_gallery_preloader_item child"></div>
  <div class="helper"></div>
</div>
<div class="jdga_gallery_sliders">
  <div class="jdga_gs_mian">
    <div class="jdga_gs_close">&#10006;</div>
    <div class="jdga_gs_mian_slider">
    </div>
    <div class="jdga_gs_mian_prev">
      <div class="child"></div>
      <div class="helper"></div>
    </div>
    <div class="jdga_gs_mian_next">
      <div class="child"></div>
      <div class="helper"></div>
    </div>
  </div>
  <div class="jdga_gs_mirror">
    <div class="jdga_gs_mirror_slider">
      <div class="jdga_gs_mirror_slider_out">
        <ul style="left: 0px;" class="jdga_gs_mirror_slider_inner"></ul>
      </div>
    </div>
    <div class="jdga_gs_mirror_prev">
      <div class="child"></div>
      <div class="helper"></div>
    </div>
    <div class="jdga_gs_mirror_next">
      <div class="child"></div>
      <div class="helper"></div>
    </div>
  </div>
</div>
</div>'
    winHeight = window.innerHeight
    sliderHeight = winHeight-140
    $area.find('.jdga_gs_mian').css {height:sliderHeight+"px"}

htmlSpecialChar_decode = (value)->
  return value
      .replace(/&amp;/g, "&")
      .replace(/&lt;/g, "<")
      .replace(/&gt;/g, ">")
      .replace(/&quot;/g, "\"")
      .replace(/&#039;/g, "'");