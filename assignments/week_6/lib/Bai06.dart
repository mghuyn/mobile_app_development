import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Bai06 extends StatefulWidget {
  const Bai06({super.key});

  @override
  State<Bai06> createState() => _Bai06State();
}

class _Bai06State extends State<Bai06> {
  final AudioPlayer player = AudioPlayer();

  final List<Map<String, String>> songs = [
    {'title': 'Xương Rồng', 'file': 'audios/xuongrong.mp3'},
    {'title': 'Cho Anh Về', 'file': 'audios/choanhve.mp3'},
    {'title': 'Touch', 'file': 'audios/touch.mp3'},
  ];

  int currentIndex = 0;

  Duration position = Duration.zero;
  Duration duration = Duration.zero;

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    player.onPositionChanged.listen((newPosition) {
      if (!mounted) return;

      setState(() {
        position = newPosition;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      if (!mounted) return;

      setState(() {
        duration = newDuration;
      });
    });

    player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });

    player.onPlayerComplete.listen((_) {
      _nextSong();
    });
  }

  Future<void> _playSong() async {
    await player.play(AssetSource(songs[currentIndex]['file']!));
  }

  Future<void> _pauseSong() async {
    await player.pause();
  }

  Future<void> _stopSong() async {
    await player.stop();

    if (!mounted) return;

    setState(() {
      position = Duration.zero;
    });
  }

  Future<void> _nextSong() async {
    setState(() {
      currentIndex = (currentIndex + 1) % songs.length;
      position = Duration.zero;
      duration = Duration.zero;
    });

    await _playSong();
  }

  Future<void> _previousSong() async {
    setState(() {
      currentIndex = (currentIndex - 1 + songs.length) % songs.length;
      position = Duration.zero;
      duration = Duration.zero;
    });

    await _playSong();
  }

  Future<void> _selectSong(int index) async {
    setState(() {
      currentIndex = index;
      position = Duration.zero;
      duration = Duration.zero;
    });

    await _playSong();
  }

  String _formatDuration(Duration value) {
    final minutes = value.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds = value.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxValue = duration.inMilliseconds.toDouble();

    final double currentValue = position.inMilliseconds
        .toDouble()
        .clamp(0.0, maxValue)
        .toDouble();

    return Scaffold(
      appBar: AppBar(title: const Text('BTVN 6 - Music Player')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 20),

            const Icon(Icons.music_note, size: 100),

            const SizedBox(height: 20),

            Text(
              songs[currentIndex]['title']!,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            Slider(
              value: currentValue,
              max: maxValue > 0.0 ? maxValue : 1.0,
              onChanged: duration.inMilliseconds == 0
                  ? null
                  : (newValue) {
                      player.seek(Duration(milliseconds: newValue.toInt()));
                    },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(position)),
                Text(_formatDuration(duration)),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 40,
                  onPressed: _previousSong,
                  icon: const Icon(Icons.skip_previous),
                ),

                IconButton(
                  iconSize: 50,
                  onPressed: isPlaying ? _pauseSong : _playSong,
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                ),

                IconButton(
                  iconSize: 40,
                  onPressed: _stopSong,
                  icon: const Icon(Icons.stop),
                ),

                IconButton(
                  iconSize: 40,
                  onPressed: _nextSong,
                  icon: const Icon(Icons.skip_next),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Playlist',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final bool selected = index == currentIndex;

                  return Card(
                    child: ListTile(
                      leading: Icon(
                        selected ? Icons.music_note : Icons.music_note_outlined,
                      ),
                      title: Text(songs[index]['title']!),
                      selected: selected,
                      onTap: () => _selectSong(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
