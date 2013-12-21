paperfolds = []
hiddenElements = $(".hidden")
transEndEventNames =
  WebkitTransition: "webkitTransitionEnd"
  MozTransition: "transitionend"
  OTransition: "oTransitionEnd"
  msTransition: "MSTransitionEnd"
  transition: "transitionend"

transformString = Modernizr.prefixed('transform')
transEndEventName = transEndEventNames[Modernizr.prefixed("transition")]
paperfold =
  percentage: 0
  timeVirgin: true
  init: (element, maxHeight, toggleCallback) ->
    @element = $(element)
    @maxHeight = maxHeight
    @toggleCallback = toggleCallback

    # get real element height
    @height = @element.height()
    log "@height: #{@height}"
    @element.css "height", ""

    # calculate amount and height of the folds
    @foldCount = Math.ceil(@height / @maxHeight)
    @foldHeight = Math.floor(@height / @foldCount)

    # detach the elements children from the dom and cache them
    @content = @element.children().detach()

    # add folds containing the previously cached children elements
    # to the element
    i = 0
    j = 0

    while i < @foldCount
      topHeight = bottomHeight = Math.floor(@foldHeight / 2)
      bottomHeight = @height - (j + 1) * topHeight  if (i + 1) is @foldCount and @foldHeight / 2 % 2
      @element.append @createFold(j, topHeight, bottomHeight)
      i++
      j += 2

    # cache the folds -> can i do this while creating them?
    # i mean i can of course cache them but then the dom connection is not there
    # i'd love to get a hint: @mrflix or mrflix@gmail.com
    @folds = @element.find("> .fold")
    @bottoms = @folds.find("> .bottom")
    @tops = @folds.find("> .top")

    # bind buttons
    @element.next(".seeMore").click $.proxy(this, "toggle")
    $("#go").click $.proxy(this, "toggle")
    @element.addClass "ready"

  update: (maxHeight) ->
    @element.children().detach()
    @element.html @content
    @init @element, maxHeight
    @open @percentage  if @percentage isnt 0

  createFold: (j, topHeight, bottomHeight) ->
    offsetTop = -j * topHeight
    offsetBottom = -@height + j * topHeight + @foldHeight
    $("<div>").addClass("fold").append $("<div>").addClass("top").css("height", topHeight).append($("<div>").addClass("inner").css("top", offsetTop).append(@content.clone())).add($("<div>").addClass("bottom").css("height", bottomHeight).append($("<div>").addClass("inner").css("bottom", offsetBottom).append(@content.clone())))

  toggle: ->
    @element.toggleClass "visible"
    if @element.hasClass("visible")

      # open
      # animate folds height (css transition)
      @folds.height @foldHeight

      # if the time slider was already used, reset the folds
      @open 1  unless @timeVirigin

    else

      # close
      # animate folds height (css transition)
      @folds.height 0

      # if the time slider was already used, reset the folds
      @open 0  unless @timeVirigin

      # change button text
      $("#go").text "Open"

    @tops.add(@bottoms).css("background-color", "").css transformString, ""

  open: (percentage) ->

    # cache percentage
    @percentage = percentage

    #clock.time = percentage * 100;
    timeVirigin = false

    # change angle of tops and bottoms
    c = @foldHeight * percentage
    a = b = @foldHeight / 2
    part = 2 * b * c
    bottomAngle = (if part <= 0 then 90 else Math.acos((b * b + c * c - a * a) / part) * 180 / Math.PI)
    topAngle = 360 - bottomAngle
    @tops.css transformString, "rotateX(" + topAngle + "deg)"
    @bottoms.css transformString, "rotateX(" + bottomAngle + "deg)"

    # change folds height
    foldHeight = @height / @foldCount * percentage
    @folds.height foldHeight

    # change the background color
    # from dark hsl(192,6,33) at 0
    # to light hsl(192,0,100) at 100
    saturation = Math.round(6 - 6 * percentage)
    lightness = 33 + Math.round(67 * percentage)
    backgroundColor = "hsl(192," + saturation + "%," + lightness + "%)"
    @tops.add(@bottoms).css "background-color", backgroundColor