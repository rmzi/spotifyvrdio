root = exports ? this

# root.RDIOS = new Meteor.Collection('rdios')
# root.SPOTIFYS = new Meteor.Collection('spotifys')

if Meteor.isClient
  Session.set 'intro', true

  Template.hello.greeting = ->
    "Welcome to Spotify v. Rdio"

  Template.hello.intro = ->
    Session.get 'intro'

  Template.hello.events 
    "click #submit": (e,t) ->
      e.preventDefault()

      Session.set 'intro', false

      ringBell = new buzz.sound "/sounds/bell.mp3"
      ringBell.play()

      username = t.find('#username').value
      console.log "You clicked the button, stuff is coming: "
      
      spotify = 0
      rdio = 0
      RDIOS = []
      SPOTIFYS = []

      Meteor.call('fetchTopSongs', username, (err, res) ->
        if err?
          console.log "Error: ", err
        else
          tracks = JSON.parse(res.content).toptracks.track

          for track in tracks          
            console.log "Searching for track: ", track.name

            #track = tracks[2]
            console.log "Currently searching for song: ", track

            Meteor.call('fetchENSpotify', track, (err, res) ->
              if err?
                console.log "Error in EchoNote call to Spotify", err
              else
                songs = JSON.parse(res.content).response.songs
                if songs.length > 0
                  console.log songs[0], 'SPOTIFY'
                  SPOTIFYS.push songs[0]
                  spotify++
                  console.log "Spotify: ", spotify
                  Session.set 'spotify', spotify
                  Session.set 'spotifys', SPOTIFYS

                #console.log "Spotify Response: ", JSON.parse(res.content)
            )

            Meteor.call('fetchENRdio', track, (err, res) ->
              if err?
                console.log "Error in EchoNote call to Rdio", err
              else
                songs = JSON.parse(res.content).response.songs
                if songs.length > 0
                  console.log songs, "RDIO"
                  
                  for song in songs
                    RDIOS.push song
                  
                  rdio += songs.length
                  console.log "Rdio: ", rdio
                  Session.set 'rdio', rdio
                  Session.set 'rdios', RDIOS

                #console.log "Rdio Response: ", JSON.parse(res.content)
            )
      )

  Template.score.rdio = ->
    Session.get 'rdio'

  Template.score.rdio_songs = ->
    Session.get 'rdios'

  Template.score.spotify = ->
    Session.get 'spotify'

  Template.score.spotify_songs = ->
    Session.get 'spotifys'

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
