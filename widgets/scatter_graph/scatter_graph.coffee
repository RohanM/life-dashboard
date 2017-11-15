class Dashing.ScatterGraph extends Dashing.Widget

  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    @graph = new Rickshaw.Graph(
      element: @node
      width: container.width()
      height: container.height()
      renderer: 'scatterplot'
      series: [
        {
        color: "#fff",
        data: [{x:0, y:0}, {x:1, y:1}, {x:2, y:2}]
        }
      ]
      padding: {top: 0.02, left: 0.02, right: 0.02, bottom: 0.02}
    )

    @graph.series[0].data = @get('points') if @get('points')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.points
      @graph.render()
