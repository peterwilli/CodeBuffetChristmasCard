startAnimation = ->
  $l1 = $ ".animation-1"
  $l1.removeClass("blur")
  $(".message-inner").animateCSS("bounceOutUp")

  $top = $ ".top"

  $play.animateCSS("hinge", ->
    $top.animateCSS("hinge")
  )

$play = $(".play")
$play.click(startAnimation)