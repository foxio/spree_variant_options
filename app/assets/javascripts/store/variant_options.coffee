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
      id = ids[0]
      $('#variant_id').val(variants[id].id)
      if $(@).find("option:selected").hasClass("in-stock")
        $('#cart-form button[type=submit]').attr('disabled', false)
      else
        $('#cart-form button[type=submit]').attr('disabled', true)
      $("#cart-form s.original").html variants[id].old_price
      $("#cart-form p.current").html variants[id].price
      return


    # ...else we need to do some processing
    otherOptionId = $("[data-index=" + (optionIndex + 1) % 2 + "]").attr("id").split("_")[2]
    otherOptionSelector = $("#option_type_" + otherOptionId)

    # disable the add to cart button – we'll reenable it later
    $('#cart-form button[type=submit]').attr('disabled', true)

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
    variant_id
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
              $('#cart-form button[type=submit]').attr('disabled', false)
              parent.addClass('active')
            else
              $('#cart-form button[type=submit]').attr('disabled', true)
              parent.removeClass('active')
            $("#cart-form s.original").html variant[id].old_price
            $("#cart-form p.current").html variant[id].price

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

