class Dashing.EditText extends Dashing.Widget

  ready: ->
    # Display content first
    $(@node).find(".content").show()

    # Wire up the things
    $(@node).find(".content").click =>
      $(@node).find(".content").hide()
      $(@node).find(".edit").show()
      $(@node).find(".edit textarea").focus()

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
    converter.setFlavor('github')
    html      = converter.makeHtml(data.content)
    @set('markdown', data.content)
    @set('content', html)
