if Meteor.isClient
  Template.hello.greeting = ->
    "Welcome to Spotify v. Rdio"

  Template.rdio.rendered = ->
    rdio = d3.select('#rdio')

    # rdio.select('g#Layer_1').attr
    #     transform: "scale(0.5)"

    # rdio.select('g#Layer_3').attr
    #     transform: "scale(0.5)"

    # rdio.select('g#Layer_4').attr
    #     transform: "scale(0.5)"

    console.log rdio,'rdio'
    #.transform(scale(0.5))

  Template.spotify.rendered = ->
    spotify = d3.select('#spotify')
    console.log spotify, 'spotify'
    #.transform(scale(0.5))

    # spotify.select('g#Layer_1').attr
    #     transform: "scale(0.5)"

    # spotify.select('g#Layer_3').attr
    #     transform: "scale(0.5)"

    # spotify.select('g#Layer_4').attr
    #     transform: "scale(0.5)"

  Template.hello.events "click input": () ->
    Meteor.call('fetchTopSongs', "ramzalam", (err, res) ->
    	if err?
    		console.log "Error: ", err
    	else
    		console.log "Supposed to have some shit:"
    		console.log JSON.parse(res.content).toptracks.track
    )
    # template data, if any, is available in 'this'
    console.log "You pressed the button"  if typeof console isnt "undefined"

if Meteor.isServer
  Meteor.startup ->
    Meteor.methods(
      fetchTopSongs: (username) ->
        this.unblock
        return Meteor.http.get("http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=" + username + "&api_key=94abcc15277cc68dfb4ac51cdace78c6&format=json")
    )

# code to run on server at startup
