openMyCard = ->
  $(".out").addClass "openingTop"
  $(".in-top").addClass "openingBottom"
  setTimeout (->
    $(".out").css "z-index", "2"
    $(".in-top").css "z-index", "3"
  ), (750 / 2)
  setTimeout (->
    $(".out").removeClass("openingTop").addClass "topOpen"
    $(".in-top").removeClass("openingBottom").addClass "bottomOpen"
  ), 750