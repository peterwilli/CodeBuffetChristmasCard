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
$ ->

  $play = $(".play")
  $play.click(startAnimation)