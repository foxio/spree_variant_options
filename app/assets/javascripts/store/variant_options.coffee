window.variantOptions = (params) ->
  options = params['options']
  outOfStockStr = "[품절]"

  $ ->
    $(".variant-option-values").change()

  # When the user selects a variant option...
  $(document).on "change", ".variant-option-values", ->
    parent = $(@).parents('.variant-options')
    optionId = parent.attr("id").split("_")[2]
    optionIndex = parent.data("index")
    elemId = $(@).find("option:selected").attr("id")
    elemId = if elemId then elemId.split("-")[1] else null

    # if there's only one variant option, not much to do...
    if $(".variant-options").length == 1
      if $(@)[0].selectedIndex == 0
        $('#cart-form button[type=submit]').attr('disabled', true)
        parent.removeClass('active')
        return
      $('#cart-form button[type=submit]').attr('disabled', false)
      parent.addClass('active')
      variants = options[optionId][elemId]
      ids = for key of variants
        key
      id = ids.pop()
      $('#variant_id').val(variants[id].id)
      if $(@).find("option:selected").hasClass("in-stock")
        $('#cart-form button[type=submit]').attr('disabled', false).html('<i class="icon-checkout-cart"></i>카트에 담기')
      else
        $('#cart-form button[type=submit]').attr('disabled', true).html('<i class="icon-checkout-cart"></i>사이즈를 골라주세요.')
      $("#cart-form s.original.krw").html variants[id].old_price
      $("#cart-form p.current.krw").html variants[id].price
      $("#cart-form p.lshipping.krw").html variants[id].local_shipping_price
      $("#cart-form p.tshipping.krw").html variants[id].total_shipping_price
      $("#cart-form s.original.usd").html variants[id].old_price_usd
      $("#cart-form p.current.usd").html variants[id].price_usd
      $("#cart-form p.lshipping.usd").html variants[id].local_shipping_price_usd
      $("#cart-form p.tshipping.usd").html variants[id].total_shipping_price_usd
      return


    # ...else we need to do some processing
    otherOptionId = $("[data-index=" + (optionIndex + 1) % 2 + "]").attr("id").split("_")[2]
    otherOptionSelector = $("#option_type_" + otherOptionId)

    # disable the add to cart button – we'll reenable it later
    $('#cart-form button[type=submit]').attr('disabled', true).html('<i class="icon-checkout-cart"></i>사이즈를 골라주세요.')

    # if this is the "select an option" option, reset availability on the other option and return
    if $(@)[0].selectedIndex == 0
      parent.removeClass('active')
      otherOptionSelector.find(".option-value").each ->
        $(@).text($(@).text().replace("#{outOfStockStr} ", ""))
          .addClass("in-stock")
      return

    # get list of variants that match this option value
    variants = options[optionId][elemId]
    ids = for key of variants
      key

    # update in-stock status of the other option, and find the variant_id if both options have been selected
    otherOptionSelector.find(".option-value").removeClass("in-stock")
    variants = options[otherOptionId]
    for key,variant of variants
      for id in ids
        if typeof variant[id] == "object"
          if variant[id].in_stock
            $("#option-#{key}").addClass("in-stock")
          # if this option is selected, we have a variant
          if $("#option-#{key}").val() == $("#option-#{key}").parent().val()
            $('#variant_id').val(variant[id].id)
            if $(@).find("option:selected").hasClass("in-stock")
              $('#cart-form button[type=submit]').attr('disabled', false).html('<i class="icon-checkout-cart"></i>카트에 담기')
              parent.addClass('active')
            else
              $('#cart-form button[type=submit]').attr('disabled', true).html('<i class="icon-checkout-cart"></i>사이즈를 골라주세요.')
              parent.removeClass('active')
            $("#cart-form s.original.krw").html variant[id].old_price
            $("#cart-form p.current.krw").html variant[id].price
            $("#cart-form p.lshipping.krw").html variant[id].local_shipping_price
            $("#cart-form p.tshipping.krw").html variant[id].total_shipping_price
            $("#cart-form s.original.usd").html variant[id].old_price_usd
            $("#cart-form p.current.usd").html variant[id].price_usd
            $("#cart-form p.lshipping.usd").html variant[id].local_shipping_price_usd
            $("#cart-form p.tshipping.usd").html variant[id].total_shipping_price_usd

    # reset "out of stock" display and update it
    if $(@).find("option:selected").hasClass("in-stock")
      parent.addClass('active')
      otherOptionSelector.find(".option-value").each ->
        text = $(@).text().replace("#{outOfStockStr} ", "")
        $(@).text("#{text}")
    else
      parent.removeClass('active')
      $(".option-value").each ->
        $(@).text($(@).text().replace("#{outOfStockStr} ", ""))

    otherOptionSelector.find(".option-value").not(".in-stock").each ->
      text = $(@).text().replace("#{outOfStockStr} ", "")
      $(@).text("#{outOfStockStr} #{text}")

    # if the user selects an option that is out-of-stock in this combination, reset the other option
    selected = otherOptionSelector.find("option:selected")
    unless selected.hasClass("in-stock")
      selected.parent()[0].selectedIndex = 0

    return

