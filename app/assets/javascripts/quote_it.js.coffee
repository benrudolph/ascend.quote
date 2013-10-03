$(document).ready () =>

  $('#spreadsheet').bind('change', (e) ->
    formData = new FormData($('#new_sheet')[0])

    $.ajax(
      url: '/validate',
      type: 'POST',
      data: formData,
      processData: false,
      cache: false,
      contentType: false,
    ).fail((xhr, st, err) =>
      console.log err
    ).then((data) =>

      data.forEach (d) =>
        $rule = $('.' + d.rule)
        $rule.removeClass('success fail warning')
        $rule.addClass(d.status)


    ))

