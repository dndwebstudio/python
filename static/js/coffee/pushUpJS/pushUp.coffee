#created by Bledigan mafacka
#2k16
$.fn.setPushUp = (head,mes,link_to,type="message",btns = {},timebomb = false, img_link)->
  if head
    $indexID = $('#event_push_up>.push_up_item').length
    $indexID++
    $itemID = "push_up_item_"+$indexID
    $('#event_push_up').append "<a class='push_up_item' id='"+$itemID+"'></a>"
    $mblock = $('#event_push_up>#'+$itemID)
    $mblock.css {opacity:0,top:'50px'}
    origin_head = head
    origin_mes = mes

    if head.length > 27
      head = head.substr 0, 24
      head += '...'

    if mes.length > 130
      mes = mes.substr 0, 126
      mes += '...'

    if type == "message"
      if !link_to
        $mblock.append '<p title="'+origin_head+'" class="pui_head">'+head+'</p>'
      else
        $mblock.append '<a title="'+origin_head+'" href="'+link_to+'" class="pui_head">'+head+'</a>'

      if !img_link
        if mes
          $mblock.append '<p class="pui_mess">'+mes+'</p>'
      else
        $mblock.append '<div class="pui_middle clear_fix"></div>'
        $mblock.find('.pui_middle').append '<div class="pui_img" style="background-image: url('+img_link+')" title="'+head+'"></div>'
        if mes
          $mblock.find('.pui_middle').append '<p class="pui_mess">'+mes+'</p>'


    else if type == "review_alert"
      if !link_to
        $mblock.append '<p title="'+origin_head+'" class="pui_head">'+head+'</p>'
      else
        $mblock.append '<a title="'+origin_head+'" href="'+link_to+'" class="pui_head">'+head+'</a>'

      if !img_link
        if mes
          $mblock.append '<p class="pui_mess">'+mes+'</p>'
      else
        $mblock.append '<div class="pui_middle clear_fix"></div>'
        $mblock.find('.pui_middle').append '<div class="pui_img" style="background-image: url('+img_link+')" title="'+head+'"></div>'
        if mes
          $mblock.find('.pui_middle').append '<p class="pui_mess">'+mes+'</p>'

      $mblock.append '<div class="pui_btns"></div>'
      $.each btns, (i,v)->
        $btnIndex = $mblock.find('.pui_btn').length
        $btnIndex++
        $btnID = 'pui_btn_'+$btnIndex+'_'+$indexID
        $mblock.find('.pui_btns').append '<a class="pui_btn" id="'+$btnID+'">'+v.name+'</a>'

        $.each v.attr, (ind,val)->
          $mblock.find('.pui_btns>#'+$btnID).attr ind, val

        if v.onClick
          $mblock.find('.pui_btns>#'+$btnID).on 'click',  v.onClick

    if type != "review_alert" && link_to
      $mblock.attr 'href', link_to


    $mblock.append '<span class="close_pushUp_alert" data-for="'+$itemID+'">&#10006;</span>'
    $mblock.on 'click', '.close_pushUp_alert', ->
      $('#'+$(@).attr('data-for')).animate {opacity:0,top:50},300,->
        $(@).remove()
    if timebomb && parseInt(timebomb)
      setTimeout ->
        $mblock.find('.close_pushUp_alert').trigger('click')
      , parseInt(timebomb)

    $mblock.animate {opacity:1,top:0},500