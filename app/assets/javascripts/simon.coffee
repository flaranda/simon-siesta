window.level = 2
window.sequence = []
window.playable_sequence = undefined
window.playing_sequence = false
window.playing_game = false
window.player_sequence = []

$( document ).ready ->
  pusher = new Pusher( '302fb53f53282bcb6c79' )
  channel = pusher.subscribe( 'private-simon' )
  channel.bind( 'client-movement', ( data ) ->
    if window.location.pathname is '/'
      new_game_button_pushed( data )
    else if window.location.pathname is '/play'
      play_game_button_pushed( data )
  )

  if window.location.pathname is '/play'
    begin_game()
    
########################################## New game window movements

@new_game_button_pushed = ( data ) ->
  if data is 'black'
    window.location = '/play'

########################################## Playing game window movements

@play_game_button_pushed = ( data ) ->
  if data is 'white'
    window.location = '/'
  else if data is 'black'
    window.playing_game = not window.playing_game
  else if window.playing_game is true
    highlight_simon( data, true )
    check_player_sequence( data )

########################################## Game logic

@begin_game = () ->
  reset_score()
  next_level()

@next_level = () ->
  $.ajax(
    beforeSend: ( xhr ) ->
      xhr.setRequestHeader( 'X-CSRF-Token', $( 'meta[name="csrf-token"]' ).attr( 'content' ) )
    url: "/levels/#{ window.level }",
    type: "GET",
    dataType: "json",
    success: ( data ) ->
      set_progress_bar_time( data["time"] )
      window.sequence = data["sequence"].reverse()
      console.log window.sequence
      window.playable_sequence = JSON.parse( JSON.stringify( window.sequence ) )
      window.player_sequence = JSON.parse( JSON.stringify( window.sequence ) )
      window.playing_sequence = true
      window.playing_game = false
      play_sequence_and_begin_level()
      console.log( "Presta atencion..." )
  )

@check_player_sequence = ( key ) ->
  seq_key = window.player_sequence.pop()

  console.log seq_key + " " + key

  if seq_key == key
    if window.player_sequence.length == 0
      console.log "lol"
  else
    console.log window.sequence
    window.player_sequence = JSON.parse( JSON.stringify( window.sequence ) )
    console.log "Reiniciado: " + window.player_sequence

@play_sequence_and_begin_level = () ->
  key = window.playable_sequence.pop()

  if key
    highlight_simon( key )
    setTimeout( play_sequence_and_begin_level, 500 * 1.5 )
  else
    window.playing_sequence = false
    window.sequence.reverse()
    begin_level()

@begin_level = () ->
  console.log( "Repite la secuencia" )
  window.playing_game = true
  progress_bar_countdown()

@highlight_simon = ( selected ) ->
  $( ".key.#{ selected }" ).addClass( 'selected' )
  setTimeout( unhighlight_all, 500 )

@unhighlight_all = () ->
  $( ".key" ).removeClass( 'selected' )

@reset_score = () ->
  $( '#score' ).empty()
  $( '#score' ).append( formatted_score( 0 ) )

@add_score = ( score ) ->
  old_score = parseInt( $( '#score' ).html() )
  $( '#score' ).empty().append( formatted_score( old_score + score ) )

@formatted_score = ( score ) ->
  formatted = "" + score
  while formatted.length < 6
    formatted = "0" + formatted
  formatted

@xtreme_mode = ( activated ) ->
  if activated
    $( '#simon' ).addClass( 'x-treme' )
  else
    $( '#simon' ).removeClass( 'x-treme' )

@set_progress_bar_time = ( time ) ->
  $( '#progress_bar' ).attr( 'full_time', time )
  $( '#progress_bar' ).attr( 'time', time )

@progress_bar_countdown = () ->
  time = $( '#progress_bar' ).attr( 'time' )
  full_time = $( '#progress_bar' ).attr( 'full_time' )

  if window.playing_game is true
    $( '#progress_bar' ).attr( 'time', time - 10 )
    $( '#progress_bar' ).attr( 'style', "width:#{ 100 * time / full_time }%;")

    if time > full_time / 3 and time < 2 * full_time / 3 and $( '#progress_bar' ).hasClass( 'high' )
      $( '#progress_bar' ).removeClass( 'high' )
      $( '#progress_bar' ).addClass( 'med' )
    else if time < full_time / 3 and $( '#progress_bar' ).hasClass( 'med' )
      $( '#progress_bar' ).removeClass( 'med' )
      $( '#progress_bar' ).addClass( 'low' )

  if time >= 1
    setTimeout( progress_bar_countdown, 10 )
  else
    # game over
