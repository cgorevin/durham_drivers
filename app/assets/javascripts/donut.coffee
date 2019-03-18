@donutChart = (stringData) ->
  root = JSON.parse stringData

  ID = '#donut'
  width = $(ID).width()
  margin = top: width/2, right: width/2, bottom: width/2, left: width/2
  radius = Math.min(margin.top, margin.right, margin.bottom, margin.left) - 10
  hue = d3.scale.category10()

  luminance = d3.scale.sqrt()
    .domain [0, 1e6]
    .clamp true
    .range [90, 20]

  # This clears the chart, useful when window resizes.
  $(ID).html '<svg></svg>'

  svg = d3.select "#{ID} svg"
    .attr width: margin.left + margin.right, height: margin.top + margin.bottom
  .append 'g'
    .attr transform: "translate(#{margin.left},#{margin.top})"

  partition = d3.layout.partition()
    .sort( (a, b) -> d3.ascending a.name, b.name )
    .size [2 * Math.PI, radius]

  arc = d3.svg.arc()
    .startAngle( (d) -> d.x )
    .endAngle( (d) -> d.x + d.dx )
    .padAngle 0.01
    .padRadius radius / 3
    .innerRadius( (d) -> radius / 3 * d.depth )
    .outerRadius( (d) -> radius / 3 * (d.depth + 1) - 1 )

  updateArc = (d) -> depth: d.depth, x: d.x, dx: d.dx

  fill = (d) ->
    p = d
    p = p.parent while p.depth > 1
    c = d3.lab hue p.name
    c.l = luminance d.sum
    c

  key = (d) ->
    k = []
    p = d
    while p.depth
      k.push p.name
      p = p.parent
    k.reverse().join '.'

  # Compute the initial layout on the entire tree to sum sizes.
  # Also compute the full name and fill color for each node,
  # and stash the children so they can be restored as we descend.
  partition
    .value( (d) -> d.size )
    .nodes root
    .forEach( (d) ->
      d._children = d.children
      d.sum = d.value
      d.key = key d
      d.fill = fill d
    )

  # Now redefine the value function to use the previously-computed sum.
  partition
    .children( (d, depth) -> if depth < 2 then d._children else null )
    .value( (d) -> d.sum )

  zoomOut = (p) ->
    return unless p && p.parent
    zoom p.parent, p

  center = svg.append 'circle'
    .attr r: radius / 3
    .on click: zoomOut

  center.append 'title'
    .text 'zoom out'

  zoomIn = (p) ->
    p = p.parent if p.depth > 1
    return if !p.children
    zoom p, p

  # Hover effect stuff
  tooltip = d3.select ID
    .append 'div'
    .attr class: 'pie-info'

  tooltip.append('div').attr class: 'label'

  tooltip.append('div').attr class: 'total'

  tooltip.append('div').attr class: 'percent'

  addCommas = (x) -> x.toString().replace /\B(?=(\d{3})+(?!\d))/g, ','

  updateToolTip = (d) ->
    p = d
    p = p.parent while p.depth > 0
    total = p.sum
    percent = Math.round(1000 * d.sum / total) / 10
    tooltip.select('.label').html d.date || d.name
    tooltip.select('.total').html addCommas d.sum
    tooltip.select('.percent').html "#{percent}%"
    tooltip.style display: 'block'

  hideToolTip = ->
    tooltip.style 'display', 'none'

  path = svg.selectAll 'path'
      .data partition.nodes(root).slice 1
    .enter().append 'path'
      .attr d: arc
      .style 'fill', (d) -> d.fill
      .each( (d) -> @._current = updateArc d )
      .on click: zoomIn, mouseover: ( (d) -> updateToolTip(d) ), mouseout: hideToolTip

  # Zoom to the specified new root.
  zoom = (root, p) ->
    return if document.documentElement.__transition__

    # Rescale outside angles to match the new layout.
    enterArc = exitArc = outsideAngle = d3.scale.linear().domain [0, 2 * Math.PI]

    insideArc = (d) ->
      if p.key > d.key
        depth: d.depth - 1, x: 0, dx: 0
      else if p.key < d.key
        depth: d.depth - 1, x: 2 * Math.PI, dx: 0
      else
        depth: 0, x: 0, dx: 2 * Math.PI

    outsideArc = (d) ->
      depth: d.depth + 1
      x: outsideAngle d.x
      dx: outsideAngle(d.x + d.dx) - outsideAngle d.x

    center.datum root

    # When zooming in, arcs enter from the outside and exit to the inside.
    # Entering outside arcs start from the old layout.
    if root == p
      enterArc = outsideArc
      exitArc = insideArc
      outsideAngle.range [p.x, p.x + p.dx]

    path = path.data partition.nodes(root).slice(1), (d) -> d.key

    # When zooming out, arcs enter from the inside and exit to the outside.
    # Exiting outside arcs transition to the new layout.
    if root != p
      enterArc = insideArc
      exitArc = outsideArc
      outsideAngle.range [p.x, p.x + p.dx]

    d3.transition().duration(if d3.event.altKey then 7500 else 750).each( ->
      path.exit().transition()
        .style 'fill-opacity', (d) -> if d.depth == 1 + (root == p) then 1 else 0
        .attrTween 'd', (d) -> arcTween.call( @, exitArc d )
        .remove()

      path.enter().append 'path'
        .style 'fill-opacity', (d) -> if d.depth == 2 - (root == p) then 1 else 0
        .style 'fill', (d) -> d.fill
        .on 'click', zoomIn
        .on mouseover: updateToolTip, mouseout: hideToolTip
        .each( (d) -> @._current = enterArc(d) )

      path.transition()
        .style 'fill-opacity', 1
        .attrTween 'd', (d) -> arcTween.call( @, updateArc d )
    )

  arcTween = (b) ->
    i = d3.interpolate(@._current, b)
    @._current = i 0
    (t) ->
      arc i t

  d3.select(self.frameElement).style height: "#{margin.top + margin.bottom}px"
