class Dashing.EditMeter extends Dashing.Widget

  @accessor 'value', Dashing.AnimatedValue

  constructor: ->
    super
    @observe 'value', (value) ->
      $(@node).find(".edit-meter").val(value).trigger('change')

  ready: ->
    meter = $(@node).find(".edit-meter")
    meter.attr("data-bgcolor", meter.css("background-color"))
    meter.attr("data-fgcolor", meter.css("color"))
    meter.knob
      release: $.throttle 1000, (value) =>
        @save(value)

  save: (value) ->
    data = JSON.stringify {event: 'edit-meter', id: $(@node).data('id'), value: value}
    $.post('/events', data)
