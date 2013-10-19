if Meteor.isClient
  Template.hello.greeting = ->
    "Welcome to Spotify v. Rdio"

  Template.hello.events 
    "submit #user-form": (e,t) ->
      e.preventDefault()
      username = t.find('#username').value
      console.log "You clicked the button, stuff is coming: "
      Meteor.call('fetchTopSongs', username, (err, res) ->
        if err?
          console.log "Error: ", err
        else
          tracks = JSON.parse(res.content).toptracks.track

          currentTrack = tracks[0]
          console.log "Currently searching for song: ", currentTrack

          Meteor.call('fetchENSpotify', currentTrack, (err, res) ->
            if err?
              console.log "Error in EchoNote call to Spotify", err
            else
              console.log "Spotify Response: ", JSON.parse(res.content)
          )

          Meteor.call('fetchENRdio', currentTrack, (err, res) ->
            if err?
              console.log "Error in EchoNote call to Rdio", $error
            else
              console.log "Rdio Response: ", JSON.parse(res.content)
          )
      )

if Meteor.isServer
  Meteor.startup ->
    Meteor.methods(
      fetchTopSongs: (username) ->
        this.unblock
        return Meteor.http.get("http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&user=" + username + "&api_key=94abcc15277cc68dfb4ac51cdace78c6&format=json")

      fetchENSpotify: (song) ->
        this.unblock
        name = song.name
        artist = song.artist.name

        console.log "Search Spotify for: ", name + " by: " + artist

        return Meteor.http.get("http://developer.echonest.com/api/v4/song/search?api_key=2I7MIPH1TPNX3NTVN&format=json&results=100&artist=radiohead&title=005_Track%205&bucket=id:spotify-WW")

      fetchENRdio: (song) ->
        this.unblock
        return Meteor.http.get("http://developer.echonest.com/api/v4/song/search?api_key=2I7MIPH1TPNX3NTVN&format=json&results=100&artist=radiohead&title=005_Track%205&bucket=id:rdio-US")
    )

# code to run on server at startup
