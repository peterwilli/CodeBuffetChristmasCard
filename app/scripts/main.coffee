openMyCard = ->
  $(".tile.in-top").css(
    display: "inline-block"
  )
  $(".out").addClass "openingTop"
  $(".in-top").addClass "openingBottom"
  setTimeout (->
    $(".out").css "z-index", "2"
    $(".in-top").css "z-index", "3"
  ), (5000 / 2)
  setTimeout (->
    $(".out").removeClass("openingTop").addClass "topOpen"
    $(".in-top").removeClass("openingBottom").addClass "bottomOpen"
    $(".card-wrapper").transit(
      y: "+=768"
      duration: 5000
    )
  ), 5000