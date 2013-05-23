$( document ).ready ->
  Pusher.log = ( ( message ) ->
    if window.console and window.console.log
      window.console.log( message )
  )

  pusher = new Pusher( '302fb53f53282bcb6c79' )
  channel = pusher.subscribe('private-simon')
  channel.bind('movement', ( ( data ) ->
    alert( data )
  ))
