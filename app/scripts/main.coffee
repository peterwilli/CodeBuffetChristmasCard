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


    )
  )

$play = null
pf = null

$ ->

  vecLen = 2
  start = "images/tree-parts"
  $treeParts = $ ".tree-parts"
  currentBottom = 0
  for i in [0..vecLen-1]
    $img = $("<img />")
    $img.attr("src", "#{start}/vec#{i+1}.svg")
    $img.css(
      left: 0
      right: 0
      bottom: currentBottom
      height: 100
    )
    $img.transit(
      rotateX: "-80deg"
    )
    $treeParts.append($img)


  $play = $(".play")
  $play.click(startAnimation)