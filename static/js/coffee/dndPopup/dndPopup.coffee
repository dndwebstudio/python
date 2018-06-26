$(document).ready ()->
  $('body').append '<div id="DND_POPUP"></div>'

$.fn.dndPopupInit = (href=false,data={},sendType="POST", callback=false)->
  if href == false
    console.log 'error init DND-popUp'
  else
    $ajaxGet = $.ajax {
      url: href
      data: data
      type: sendType
    }
    $ajaxGet.done (data)->
      if data
        popupStart data
        if callback
          callback()
      else
        console.log 'error get data DND-popUp'


$.fn.dndPopupInitByHTML = (htmlData)->
  popupStart(htmlData)

popupStart = (htmlData)->
  $main = $('body #DND_POPUP')
  $main.append '<div class="bbc_pa_block"><div class="bbc_pa_layout"></div><div class="bbc_pa_outContentBlock"><div class="bbc_pa_layout"></div><div class="bbc_pa_innerContentBlock child"><div class="bbc_pa_layout"></div><div class="bbc_pa_contentBlock child">'+htmlData+'<span class="bbc_pa_close">&#10006;</span></div><div class="helper"></div></div><div class="helper"></div></div></div>'

  $main.find('.bbc_pa_block').css {opacity:0}
  $main.find('.bbc_pa_block').animate {opacity:1},350

  $main.on 'click','.bbc_pa_close, .bbc_pa_layout',()->
    $main.find('.bbc_pa_block').animate {opacity:0},250,()->
      $main.html ''