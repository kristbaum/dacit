import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart' as ap;

class MicroPlayer extends StatefulWidget {
  /// Path from where to play recorded audio
  final ap.AudioSource source;

  /// Callback when audio file should be removed
  /// Setting this to null hides the delete button
  final VoidCallback onDelete;

  const MicroPlayer({
    required this.source,
    required this.onDelete,
  });

  @override
  MicroPlayerState createState() => MicroPlayerState();
}

class MicroPlayerState extends State<MicroPlayer> {
  static const double _controlSize = 56;
  static const double _deleteBtnSize = 24;

  final _microPlayer = ap.AudioPlayer();
  late StreamSubscription<ap.PlayerState> _playerStateChangedSubscription;
  late StreamSubscription<Duration?> _durationChangedSubscription;
  late StreamSubscription<Duration> _positionChangedSubscription;

  @override
  void initState() {
    _playerStateChangedSubscription =
        _microPlayer.playerStateStream.listen((state) async {
      if (state.processingState == ap.ProcessingState.completed) {
        await stop();
      }
      setState(() {});
    });
    _positionChangedSubscription =
        _microPlayer.positionStream.listen((position) => setState(() {}));
    _durationChangedSubscription =
        _microPlayer.durationStream.listen((duration) => setState(() {}));
    _init();

    super.initState();
  }

  Future<void> _init() async {
    await _microPlayer.setAsset('audio/words/thomas_b.wav');
  }

  @override
  void dispose() {
    _playerStateChangedSubscription.cancel();
    _positionChangedSubscription.cancel();
    _durationChangedSubscription.cancel();
    _microPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildControl(),
          ],
        );
      },
    );
  }

  Widget _buildControl() {
    Icon icon;
    Color color;

    if (_microPlayer.playerState.playing) {
      icon = Icon(Icons.pause, color: Colors.red, size: 30);
      color = Colors.red.withOpacity(0.1);
    } else {
      final theme = Theme.of(context);
      icon = Icon(Icons.play_arrow, color: theme.primaryColor, size: 30);
      color = theme.primaryColor.withOpacity(0.1);
    }

    return ClipOval(
      child: Material(
        color: color,
        child: InkWell(
          child:
              SizedBox(width: _controlSize, height: _controlSize, child: icon),
          onTap: () {
            if (_microPlayer.playerState.playing) {
              pause();
            } else {
              play();
            }
          },
        ),
      ),
    );
  }


  Future<void> play() {
    return _microPlayer.play();
  }

  Future<void> pause() {
    return _microPlayer.pause();
  }

  Future<void> stop() async {
    await _microPlayer.stop();
    return _microPlayer.seek(const Duration(milliseconds: 0));
  }
}
