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
    ).then((st) =>
      console.log st
    ))

