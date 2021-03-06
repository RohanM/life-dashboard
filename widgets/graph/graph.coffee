class Dashing.Graph extends Dashing.Widget

  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y

  ready: ->
    container = $(@node).parent()
    @graph = new Rickshaw.Graph(
      element: @node
      width: container.width()
      height: container.height()
      min: @get("y_min")
      gapSize: 0.25
      renderer: @get("graphtype")
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}]
        }
      ]
      padding: {top: 0.02, left: 0.02, right: 0.02, bottom: 0.02}
    )

    @graph.series[0].data = @get('points') if @get('points')

    if @get('x_labels')
      x_axis = new Rickshaw.Graph.Axis.X
        graph: @graph
        tickFormat: (x) => @get('x_labels')[x]
    else
      x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)

    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.points
      @graph.render()
