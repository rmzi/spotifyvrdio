if Meteor.isClient
  Template.hello.greeting = ->
    "Welcome to Spotify v. Rdio"

  Template.hello.events 
    "submit #user-form": (e,t) ->
      e.preventDefault()

      ringBell = new buzz.sound "/sounds/bell.mp3"
      ringBell.play()

      username = t.find('#username').value
      console.log "You clicked the button, stuff is coming: "
      
      spotify = 0
      rdio = 0

      # Meteor.call('fetchTopSongs', username, (err, res) ->
      #   if err?
      #     console.log "Error: ", err
      #   else
      #     tracks = JSON.parse(res.content).toptracks.track

      #     for track in tracks          
      #       console.log "Searching for track: ", track.name

      #       #track = tracks[2]
      #       console.log "Currently searching for song: ", track

      #       Meteor.call('fetchENSpotify', track, (err, res) ->
      #         if err?
      #           console.log "Error in EchoNote call to Spotify", err
      #         else
      #           songs = JSON.parse(res.content).response.songs
                
      #           if songs.length > 0
      #             spotify++
      #             console.log "Spotify: ", spotify

      #           #console.log "Spotify Response: ", JSON.parse(res.content)
      #       )

      #       Meteor.call('fetchENRdio', track, (err, res) ->
      #         if err?
      #           console.log "Error in EchoNote call to Rdio", err
      #         else
      #           songs = JSON.parse(res.content).response.songs

      #           if songs.length > 0
      #             rdio++
      #             console.log "Rdio: ", rdio

      #           #console.log "Rdio Response: ", JSON.parse(res.content)
      #       )
      # )


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

if Meteor.isServer
  Meteor.startup ->
    Meteor.methods(
      fetchTopSongs: (username) ->
        this.unblock
        return Meteor.http.get("http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=" + username + "&api_key=94abcc15277cc68dfb4ac51cdace78c6&limit=10&format=json")

      fetchENSpotify: (song) ->
        this.unblock

        title = song.name
        artist = song.artist.name

        console.log "Search Spotify for: ", title + " by: " + artist

        return Meteor.http.get("http://developer.echonest.com/api/v4/song/search?api_key=2I7MIPH1TPNX3NTVN&format=json&results=100&artist=" + artist + "&title=" + title + "&bucket=id:spotify-WW")
        #return Meteor.http.get("http://developer.echonest.com/api/v4/song/search?api_key=2I7MIPH1TPNX3NTVN&format=json&results=100&artist=radiohead&title=005_Track%205&bucket=id:spotify-WW")
      fetchENRdio: (song) ->
        this.unblock

        title = song.name
        artist = song.artist.name

        console.log "Search Rdio for: ", title + " by: " + artist

        return Meteor.http.get("http://developer.echonest.com/api/v4/song/search?api_key=2I7MIPH1TPNX3NTVN&format=json&results=100&artist=" + artist + "&title=" + title + "&bucket=id:rdio-US")
    )

# code to run on server at startup
