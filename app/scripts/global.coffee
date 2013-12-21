window.jstr = JSON.stringify
window.debug = yes

window.log = (msg) ->
  arguments_ = ['L&R >>']
  for arg in arguments
    arguments_.push arg

  console.log.apply console, arguments_ if debug