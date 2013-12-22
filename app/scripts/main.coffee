startAnimation = ->
  $l1 = $ ".animation-1"
  $l1.removeClass("blur")
  $(".message-inner").animateCSS("bounceOutUp")

  $top = $ ".buffet-top"

  $play.animateCSS("hinge", ->
    $top.transit(
      rotate: "-45deg"
      x: "-30%"
      y: "-90%"
      duration: 5000
    , ->

      treeObjects[0].$img.animateCSS("unfold")
      setTimeout(->
        for i in [0..treeObjects.length-1]
          to = treeObjects[i]
          $img = to.$img
          $wrap = to.$wrap

          $wrap.transit(
            y: to.proposedWrapY
            duration: 5000
          )
      , 2000)

    )
  )

$play = null
pf = null
treeObjects = null

$ ->

  vecLen = 2
  start = "images/tree-parts"
  $treeParts = $("<div />").addClass("tree-parts")
  $treePartsContainer = $ ".tree-parts-container"
  treeObjects = []

  class TreePart

    totalHeight = i = 0

    constructor: (attrs) ->

      treeObjects.push @

      defaultAttrs =
        topPercent: null
        horizontalMarginPercent: 0

      attrs = $.extend(defaultAttrs, attrs)

      @topPercent = attrs.topPercent

      $wrap = $("<div />").addClass("tree-wrap")
      $img = $("<img />").addClass("tree-image")

      $img.css(
        left: "#{attrs.horizontalMarginPercent/2}%"
        width: "#{100 - attrs.horizontalMarginPercent}%"
        bottom: 0
      )
      $img.transit(
        duration: 0
      )
      $img.attr("src", "#{start}/vec#{i+1}.svg")
      $wrap.transit(
        y: -totalHeight
        duration: 0
      )

      @proposedWrapY = -totalHeight

      $img.addClass "vec#{i+1}"

      $wrap.append($img)
      $treeParts.append($wrap)

      $img.on("load", =>
        @height = $img.height()

        @$img = $img
        @$wrap = $wrap

        i++
        totalHeight += @height - Math.floor((@topPercent / 100) * @height)
        treeCBs[i]() if treeCBs.length > i
      )


  treeCBs = [
    -> new TreePart(
      topPercent: 40
    )
    -> new TreePart(
      topPercent: 35
    )
    -> new TreePart(
      topPercent: 35
      horizontalMarginPercent: 2
    )
    -> new TreePart(
      topPercent: 35
      horizontalMarginPercent: 5
    )
    -> new TreePart(
      topPercent: 35
      horizontalMarginPercent: 20
    )
    -> new TreePart(
      topPercent: 35
      horizontalMarginPercent: 40
    )
    -> new TreePart(
      topPercent: 35
      horizontalMarginPercent: 60
    )
  ]
  treeCBs[0]()

  $treePartsContainer.append $treeParts


  $play = $(".play")
  $play.click(startAnimation)