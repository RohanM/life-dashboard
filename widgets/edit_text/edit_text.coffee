class Dashing.EditText extends Dashing.Widget

  ready: ->
    # Pick whether to display text or editing interface first
    if @get('content')?
      $(@node).find(".content").show()
    else
      $(@node).find(".edit").show()

    # Wire up the things
    $(@node).find(".content").click =>
      $(@node).find(".content").hide()
      $(@node).find(".edit").show()

    $(@node).find(".edit button").click => @updateContent()
    $(@node).find(".edit textarea").keydown (e) =>
      if e.ctrlKey && e.keyCode == 13
        @updateContent()

  updateContent: ->
      @save $(@node).find(".edit textarea").val()
      $(@node).find(".edit").hide()
      $(@node).find(".content").show()

  save: (content) ->
    data = JSON.stringify {event: 'edit-text', id: $(@node).data('id'), content: content}
    $.post('/events', data)

  onData: (data) ->
    converter = new showdown.Converter()
    html      = converter.makeHtml(data.content)
    @set('markdown', data.content)
    @set('content', html)
