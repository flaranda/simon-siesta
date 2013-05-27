$( document ).ready ->
  console.log( window.location.pathname )

  pusher = new Pusher( '302fb53f53282bcb6c79' )
  channel = pusher.subscribe('private-simon')
  channel.bind('client-movement', ( ( data ) ->
    if window.location.pathname is '/'
      begin_game_window( data )
    else if window.location.pathname is '/play'
      game_window( data )
  ))

@begin_game_window = ( data ) ->
  if data is 'black'
    window.location = '/play'

@game_window = ( data ) ->
