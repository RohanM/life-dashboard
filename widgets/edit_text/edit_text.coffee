class Dashing.EditText extends Dashing.Widget

  ready: ->
    # Pick whether to display text or editing interface first
    if @get('text')?
      $(@node).find(".text").show()
    else
      $(@node).find(".edit").show()

    # Wire up the things
    $(@node).find(".text").click =>
      $(@node).find(".text").hide()
      $(@node).find(".edit").show()

    $(@node).find(".edit button").click =>
      @save $(@node).find(".edit textarea").val()
      $(@node).find(".edit").hide()
      $(@node).find(".text").show()

  save: (text) ->
    data = JSON.stringify {event: 'edit-text', id: $(@node).data('id'), text: text}
    $.post('/events', data)

  onData: (data) ->
    @set('text', data.text)
