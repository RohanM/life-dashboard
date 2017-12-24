class Dashing.EditMeter extends Dashing.Widget

  constructor: ->
    super
    @prefix = @get('prefix') || ''
    @suffix = @get('suffix') || ''
    @observe 'value', (value) ->
      $(@node).find(".edit-meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".edit-meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob
      format: (value) =>
        "#{@prefix}#{value}#{@suffix}"
      parse: (value) =>
        value = value.replace('$', '') if typeof value is 'string'
        parseFloat(value)

      release: $.throttle 1000, (value) =>
        @save(value)

  save: (value) ->
    data = JSON.stringify {event: 'edit-meter', id: $(@node).data('id'), value: value}
    $.post('/events', data)
