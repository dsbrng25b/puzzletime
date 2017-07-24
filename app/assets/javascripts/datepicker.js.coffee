app = window.App ||= {}

# Initializes date pickers on inputs with class .date,
# works as week picker if data-format="week"
app.datepicker = new class
  i18n = ->
    $.datepicker.regional[$('html').attr('lang')]

  formatWeek = (date) ->
    $.datepicker.formatDate('yy', date) + ' ' + $.datepicker.iso8601Week(date)

  onSelect = (dateString, instance) =>
    if instance.input.data('format') == 'week'
      date = $.datepicker.parseDate(i18n().dateFormat, dateString)
      instance.input
        .val(formatWeek(date))
        .trigger('change')

  options = $.extend({ onSelect, showWeek: true }, i18n())

  init: ->
    $('input.date').each((_i, elem) ->
      $(elem).datepicker($.extend({}, options, {
        changeYear: $(elem).data('changeyear')
      })))
    @bindListeners()

  formatWeek: formatWeek

  destroy: ->
    $('input.date').datepicker('destroy')
    @bindListeners(true)

  bindListeners: (unbind) ->
    func = if unbind then 'off' else 'on'

    $(document)[func]('click', 'input.date + .input-group-addon', @show)

  show: (event) ->
    field = $(event.target)
    if !field.is('input.date')
      field = field.closest('.input-group').find('.date')
    field.datepicker('show')

$(document).on('turbolinks:load', ->
  app.datepicker.destroy()
  app.datepicker.init()
)
