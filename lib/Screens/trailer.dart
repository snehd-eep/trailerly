import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trailerly/MovieData.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '';





class TrailerVideo extends StatefulWidget {

  final vt ;
  TrailerVideo(@required this.vt);

  @override
  _TrailerVideoState createState() => _TrailerVideoState(vt);

}

class _TrailerVideoState extends State<TrailerVideo> {
  final movieh;
  String videotag;


  YoutubePlayerController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();


  _TrailerVideoState(@required this.movieh);

  PlayerState _playerState;
  YoutubeMetaData _videoMetaData;
  double _volume = 100;
  bool _muted = false;
  bool _isPlayerReady = false;


  @override
  void initState() {
    super.initState();


        _controller = YoutubePlayerController(
          initialVideoId: movieh,
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )
          ..addListener(listener);
        // _idController = TextEditingController();
        //_seekToController = TextEditingController();
        _videoMetaData = const YoutubeMetaData();
        _playerState = PlayerState.unknown;

  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        _playerState = _controller.value.playerState;
        _videoMetaData = _controller.metadata;
      });
    }
  }





  @override
  void dispose() {
    _controller.dispose();
    //_idController.dispose();
    //_seekToController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations(DeviceOrientation.values);
      },
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        topActions: <Widget>[
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              _controller.metadata.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18.0,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: Colors.white,
              size: 25.0,
            ),
            onPressed: () {
              print('Settings Tapped!');
            },
          ),
        ],
        onReady: () {
          _isPlayerReady = true;
        },
      ),
      builder: (context, player) =>
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.black,
            body: ListView(
              children: [
                player,
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _space,
                      _text('Title', _videoMetaData.title),
                      _space,
                      _text('Channel', _videoMetaData.author),
                      _space,
                      _text('Video Id', _videoMetaData.videoId),
                      _space,
                      Row(
                        children: [
                          _text(
                            'Playback Quality',
                            _controller.value.playbackQuality,
                          ),
                          const Spacer(),
                          _text(
                            'Playback Rate',
                            '${_controller.value.playbackRate}x  ',
                          ),
                        ],
                      ),
                      _space,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          IconButton(
                            icon: Icon(
                              _controller.value.isPlaying
                                  ? Icons.pause
                                  : Icons.play_arrow,
                            ),
                            onPressed: _isPlayerReady
                                ? () {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                              setState(() {});
                            }
                                : null,
                          ),
                          IconButton(
                            icon: Icon(
                                _muted ? Icons.volume_off : Icons.volume_up),
                            onPressed: _isPlayerReady
                                ? () {
                              _muted
                                  ? _controller.unMute()
                                  : _controller.mute();
                              setState(() {
                                _muted = !_muted;
                              });
                            }
                                : null,
                          ),
                          FullScreenButton(
                            controller: _controller,
                            color: Colors.blueAccent,
                          ),

                        ],
                      ),
                      _space,
                      Row(
                        children: <Widget>[
                          const Text(
                            "Volume",
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          Expanded(
                            child: Slider(
                              inactiveColor: Colors.transparent,
                              value: _volume,
                              min: 0.0,
                              max: 100.0,
                              divisions: 10,
                              label: '${(_volume).round()}',
                              onChanged: _isPlayerReady
                                  ? (value) {
                                setState(() {
                                  _volume = value;
                                });
                                _controller.setVolume(_volume.round());
                              }
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      _space,

                    ],
                  ),
                ),
              ],
            ),
          ),
    );
  }

  Widget _text(String title, String value) {
    return RichText(
      text: TextSpan(
        text: '$title : ',
        style: const TextStyle(
          color: Colors.blueAccent,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: value ?? '',
            style: const TextStyle(
              color: Colors.blueAccent,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }


  Widget get _space => const SizedBox(height: 10);


}







