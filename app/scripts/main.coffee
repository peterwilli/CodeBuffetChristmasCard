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
      pf.toggle()
    )
  )

$play = null
pf = null

$ ->

  $tree = $ ".tree"
  $treeImg = $(".tree img")

  $treeImg.one("load", ->
    height = $tree.height()

    $treeImg.height(height)

    pf = Object.create(paperfold)
    pf.init $tree.get(0), (height / 4)

    # Undo the hiding because the folder has been initialized
    $tree.css("display", "inline-block")

    $play = $(".play")
    $play.click(startAnimation)
  ).each(->
    $treeImg.load() if @complete
  )