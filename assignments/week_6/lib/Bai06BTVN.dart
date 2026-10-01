import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class BTVN06 extends StatefulWidget {
  const BTVN06({super.key});

  @override
  State<BTVN06> createState() => _BTVN06State();
}

class _BTVN06State extends State<BTVN06> {
  final AudioPlayer _player = AudioPlayer();

  final List<Map<String, String>> _songs = [
    {
      'title': 'Xương Rồng',
      'artist': 'Audio 01',
      'file': 'audios/xuongrong.mp4',
    },
    {
      'title': 'Chờ Anh Về',
      'artist': 'Audio 02',
      'file': 'audios/choanhve.mp4',
    },
    {'title': 'Touch', 'artist': 'Audio 03', 'file': 'audios/touch.mp4'},
  ];

  int _currentIndex = 0;

  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _player.onPositionChanged.listen((position) {
      if (!mounted) return;

      setState(() {
        _position = position;
      });
    });

    _player.onDurationChanged.listen((duration) {
      if (!mounted) return;

      setState(() {
        _duration = duration;
      });
    });

    _player.onPlayerStateChanged.listen((state) {
      if (!mounted) return;

      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _player.onPlayerComplete.listen((_) {
      _nextSong();
    });
  }

  Future<void> _playSong() async {
    await _player.play(AssetSource(_songs[_currentIndex]['file']!));
  }

  Future<void> _pauseSong() async {
    await _player.pause();
  }

  Future<void> _stopSong() async {
    await _player.stop();

    if (!mounted) return;

    setState(() {
      _position = Duration.zero;
      _isPlaying = false;
    });
  }

  Future<void> _nextSong() async {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _songs.length;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _playSong();
  }

  Future<void> _previousSong() async {
    setState(() {
      _currentIndex = (_currentIndex - 1 + _songs.length) % _songs.length;

      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _playSong();
  }

  Future<void> _selectSong(int index) async {
    setState(() {
      _currentIndex = index;
      _position = Duration.zero;
      _duration = Duration.zero;
    });

    await _playSong();
  }

  String _formatTime(Duration time) {
    final minutes = time.inMinutes.remainder(60).toString().padLeft(2, '0');

    final seconds = time.inSeconds.remainder(60).toString().padLeft(2, '0');

    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double maxValue = _duration.inMilliseconds.toDouble();

    final double currentValue = _position.inMilliseconds
        .toDouble()
        .clamp(0.0, maxValue > 0.0 ? maxValue : 1.0)
        .toDouble();

    final song = _songs[_currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text(
          'Music Player',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 10),

                    // Album cover
                    Container(
                      width: 260,
                      height: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                            color: Colors.black.withOpacity(0.18),
                          ),
                        ],
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF673AB7), Color(0xFF9C27B0)],
                        ),
                      ),
                      child: const Icon(
                        Icons.music_note,
                        size: 120,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 28),

                    Text(
                      song['title']!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      song['artist']!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Progress
                    Slider(
                      value: currentValue,
                      max: maxValue > 0.0 ? maxValue : 1.0,
                      onChanged: _duration.inMilliseconds == 0
                          ? null
                          : (value) {
                              _player.seek(
                                Duration(milliseconds: value.toInt()),
                              );
                            },
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTime(_position),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          Text(
                            _formatTime(_duration),
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 34,
                          onPressed: _previousSong,
                          icon: const Icon(Icons.skip_previous),
                        ),

                        const SizedBox(width: 12),

                        Container(
                          width: 65,
                          height: 65,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFF673AB7),
                          ),
                          child: IconButton(
                            iconSize: 38,
                            color: Colors.white,
                            onPressed: _isPlaying ? _pauseSong : _playSong,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        IconButton(
                          iconSize: 34,
                          onPressed: _stopSong,
                          icon: const Icon(Icons.stop),
                        ),

                        const SizedBox(width: 12),

                        IconButton(
                          iconSize: 34,
                          onPressed: _nextSong,
                          icon: const Icon(Icons.skip_next),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Playlist title
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Danh sách phát',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Playlist
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _songs.length,
                      itemBuilder: (context, index) {
                        final item = _songs[index];
                        final bool selected = index == _currentIndex;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFEDE7F6)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF673AB7)
                                  : Colors.transparent,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: selected
                                  ? const Color(0xFF673AB7)
                                  : Colors.grey.shade200,
                              child: Icon(
                                selected && _isPlaying
                                    ? Icons.equalizer
                                    : Icons.music_note,
                                color: selected
                                    ? Colors.white
                                    : Colors.grey.shade700,
                              ),
                            ),
                            title: Text(
                              item['title']!,
                              style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            subtitle: Text(item['artist']!),
                            trailing: selected
                                ? const Icon(Icons.volume_up)
                                : null,
                            onTap: () => _selectSong(index),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
