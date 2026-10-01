import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'media_file_adapter.dart' as adapter;

class Bai4 extends StatefulWidget {
  const Bai4({super.key});
  @override
  State<Bai4> createState() => _Bai4State();
}

class _Bai4State extends State<Bai4> {
  final ImagePicker _picker = ImagePicker();
  VideoPlayerController? _controller;
  bool _loading = false;

  Future<void> _pickVideo(ImageSource source) async {
    try {
      setState(() => _loading = true);
      final file = await _picker.pickVideo(source: source);
      if (file == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      await _controller?.dispose();
      final controller = kIsWeb
          ? VideoPlayerController.networkUrl(Uri.parse(file.path))
          : VideoPlayerController.file(
              await adapter.xFileToVideoSource(file),
            );
      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _controller = controller;
        _loading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      _message('Không thể mở video: $e');
    }
  }

  void _playPause() {
    final c = _controller;
    if (c == null || !c.value.isInitialized) return;
    setState(() => c.value.isPlaying ? c.pause() : c.play());
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Bài 4 - Video Recorder & Playback')),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Wrap(
            spacing: 10, runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickVideo(ImageSource.gallery),
                icon: const Icon(Icons.video_library),
                label: const Text('Chọn video'),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickVideo(ImageSource.camera),
                icon: const Icon(Icons.videocam),
                label: const Text('Quay video'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: _loading
                  ? const CircularProgressIndicator()
                  : _controller?.value.isInitialized == true
                      ? AspectRatio(
                          aspectRatio: _controller!.value.aspectRatio,
                          child: VideoPlayer(_controller!),
                        )
                      : const Text('Chưa có video'),
            ),
          ),
          if (_controller?.value.isInitialized == true)
            IconButton(
              iconSize: 54,
              onPressed: _playPause,
              icon: Icon(_controller!.value.isPlaying
                  ? Icons.pause_circle : Icons.play_circle),
            ),
        ],
      ),
    ),
  );
}
