$( document ).ready ->
  set_progress_bar_time( 5000 )
  progress_bar_countdown()

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
  if data is 'white'
    window.location = '/'

@set_progress_bar_time = ( time ) ->
  $( '#progress_bar' ).attr( 'full_time', time )
  $( '#progress_bar' ).attr( 'time', time )

@progress_bar_countdown = () ->
  time = $('#progress_bar').attr( 'time' )
  full_time = $('#progress_bar').attr( 'full_time' )

  $('#progress_bar').attr( 'time', time - 200 )
  $('#progress_bar').attr( 'style', "width:#{ 100 * time / full_time }%;")

  if time > full_time / 3 and time < 2 * full_time / 3 and $('#progress_bar').hasClass( 'high' )
    $('#progress_bar').removeClass( 'high' )
    $('#progress_bar').addClass( 'med' )
  else if time < full_time / 3 and $('#progress_bar').hasClass( 'med' )
    $('#progress_bar').removeClass( 'med' )
    $('#progress_bar').addClass( 'low' )

  if time >= 1
    setTimeout( progress_bar_countdown, 200 )
