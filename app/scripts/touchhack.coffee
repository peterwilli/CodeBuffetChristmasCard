(->

  # This code is only for iOS
  withinDistance = (x1, y1, x2, y2, distance) ->
    Math.abs(x1 - x2) < distance and Math.abs(y1 - y2) < distance
  return  unless window.navigator.userAgent.match(/(iPhone|iPad|iPod)/)
  CONFIG =
    TOUCH_MOVE_THRESHHOLD: 10
    PRESSED_CLASS: "pressed"
    GHOST_CLICK_TIMEOUT: 500
    GHOST_CLICK_THRESHOLD: 10

  clicks = []

  # Use a native event listener so we can set useCapture
  document.addEventListener "click", ((e) ->
    i = 0

    while i < clicks.length

      # For some reason, the ghost click events don't always appear where the touchend event was
      if withinDistance(clicks[i][0], clicks[i][1], e.clientX, e.clientY, CONFIG.GHOST_CLICK_THRESHOLD)
        e.preventDefault()
        e.stopPropagation()
        return
      i++
  ), true
  $(document).on "touchstart", ".button", (e) ->
    elem = $(this)

    # Disable the webkit tap highlight, since it is no longer accurate
    elem.css "webkitTapHighlightColor", "rgba(0,0,0,0)"
    elem.addClass CONFIG.PRESSED_CLASS
    touch = e.originalEvent.touches[0]
    location = [touch.clientX, touch.clientY]
    @__eventLocation = location
    @__onTouchMove = (e) ->
      touch = e.originalEvent.touches[0]
      if withinDistance(touch.clientX, touch.clientY, location[0], location[1], CONFIG.TOUCH_MOVE_THRESHHOLD)
        elem.addClass CONFIG.PRESSED_CLASS
      else
        elem.removeClass CONFIG.PRESSED_CLASS

    $(document.body).on "touchmove", @__onTouchMove

  $(document).on "touchcancel", ".button", (e) ->
    elem = $(this)
    elem.removeClass CONFIG.PRESSED_CLASS
    $(document.body).off "touchmove", @__onTouchMove

  $(document).on "touchend", ".button", (e) ->
    elem = $(this)
    if elem.hasClass(CONFIG.PRESSED_CLASS)
      elem.removeClass CONFIG.PRESSED_CLASS
      location = @__eventLocation
      if location
        touch = e.originalEvent.changedTouches[0]
        return  unless withinDistance(touch.clientX, touch.clientY, location[0], location[1], CONFIG.TOUCH_MOVE_THRESHHOLD)

        # Dispatch a fake click event within a setTimeout. If we don't do this, there's a strange bug where
        # the next view can't correctly bring the keyboard up
        setTimeout (->
          evt = document.createEvent("MouseEvents")
          evt.initMouseEvent "click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null
          elem.get(0).dispatchEvent evt
        ), 1

        # Don't process the default action for this event to avoid WebKit stealing focus from a
        # view we might be loading, and from dispatching a click event
        e.preventDefault()

        # Eat further "ghost" click events at this location that appear if the user holds the link down
        # longer than the double-tap cancel threshold (these are not cancelled when preventing default)
        clickLocation = [touch.clientX, touch.clientY]
        clicks.push clickLocation
        window.setTimeout (->
          i = clicks.indexOf(clickLocation)
          clicks.splice i, 1  if i >= 0
        ), CONFIG.GHOST_CLICK_TIMEOUT
    $(document.body).off "touchmove", @__onTouchMove

)()