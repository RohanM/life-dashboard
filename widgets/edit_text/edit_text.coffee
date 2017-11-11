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
      @set('text', $(@node).find(".edit textarea").val())
      $(@node).find(".edit").hide()
      $(@node).find(".text").show()


  onData: (data) ->
    # Handle incoming data
    # You can access the html node of this widget with `@node`
    # Example: $(@node).fadeOut().fadeIn() will make the node flash each time data comes in.