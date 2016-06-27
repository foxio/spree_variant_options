$ ->
  images = $('#images')

  submitForm = (form, e) ->
    option_types = $('.option-type-field', form.parent())
    option_type_count = option_types.size()
    master_option = $('#master_option', form.parent())

    option_types_with_selected = 0
    option_types.each ->
      if $(this).find('input.option-value:checked').size() > 0
        option_types_with_selected += 1
        return true

    if option_type_count != option_types_with_selected && !master_option.is(':checked')
      e.preventDefault()
      error_div = $('#error-message', form.parent())
      error_div.text(error_div.data('one-option-error'))

  images.on 'change', '#master_option', ->
    $('.option-value, .option-type', images).prop 'disabled', (i, val) -> !val
    $('#master_option', images).prop('disabled', false)

  images.on 'submit', 'form', (e) ->
    submitForm($(this), e);

  $('form.edit_image').submit((e)->
    submitForm($(this), e)
  );
