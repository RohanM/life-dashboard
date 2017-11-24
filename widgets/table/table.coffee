class Dashing.Table extends Dashing.Widget
  onData: (data) ->
    $(@node).find("table").remove()

    tableDOM = $("<table></table>")
    for row in data.table
      rowDOM = $("<tr></tr>")
      for col in row
        colDOM = $("<td>#{col}</td>")
        rowDOM.append colDOM
      tableDOM.append(rowDOM)

    $(@node).append(tableDOM)