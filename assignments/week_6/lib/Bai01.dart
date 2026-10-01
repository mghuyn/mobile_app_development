import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

import 'media_file_adapter.dart' as adapter;

class Bai1 extends StatefulWidget {
  const Bai1({super.key});

  @override
  State<Bai1> createState() => _Bai1State();
}

class _Bai1State extends State<Bai1> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  VideoPlayerController? _videoController;
  bool _loading = false;

  Future<void> _pickImage(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 90);
      if (file == null) return;
      await _videoController?.dispose();
      if (!mounted) return;
      setState(() {
        _image = file;
        _videoController = null;
      });
    } catch (e) {
      _message('Không thể lấy ảnh: $e');
    }
  }

  Future<void> _pickVideo(ImageSource source) async {
    try {
      setState(() => _loading = true);
      final file = await _picker.pickVideo(source: source);
      if (file == null) {
        if (mounted) setState(() => _loading = false);
        return;
      }
      await _loadVideo(file);
    } catch (e) {
      if (mounted) setState(() => _loading = false);
      _message('Không thể mở video: $e');
    }
  }

  Future<void> _loadVideo(XFile file) async {
    await _videoController?.dispose();
    final source = kIsWeb
        ? VideoPlayerController.networkUrl(Uri.parse(file.path))
        : VideoPlayerController.file(await adapter.xFileToVideoSource(file));
    await source.initialize();
    if (!mounted) {
      await source.dispose();
      return;
    }
    setState(() {
      _image = null;
      _videoController = source;
      _loading = false;
    });
    await source.play();
  }

  void _toggleVideo() {
    final c = _videoController;
    if (c == null || !c.value.isInitialized) return;
    setState(() {
      c.value.isPlaying ? c.pause() : c.play();
    });
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 1 - Multimedia')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_loading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(30),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_image != null)
            FutureBuilder<Uint8List>(
              future: _image!.readAsBytes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return const SizedBox(
                    height: 300,
                    child: Center(child: CircularProgressIndicator()),
                  );
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FullScreenImage(bytes: snapshot.data!),
                    ),
                  ),
                  child: Image.memory(
                    snapshot.data!,
                    height: 300,
                    fit: BoxFit.contain,
                  ),
                );
              },
            )
          else if (_videoController?.value.isInitialized == true)
            Column(
              children: [
                AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
                IconButton(
                  iconSize: 48,
                  onPressed: _toggleVideo,
                  icon: Icon(
                    _videoController!.value.isPlaying
                        ? Icons.pause_circle
                        : Icons.play_circle,
                  ),
                ),
              ],
            )
          else
            const SizedBox(
              height: 280,
              child: Center(child: Text('Chưa chọn ảnh hoặc video')),
            ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Chọn ảnh'),
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Chụp ảnh'),
              ),
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
          if (kIsWeb)
            const Padding(
              padding: EdgeInsets.only(top: 12),
              child: Text(
                'Web: chọn file hoạt động; camera/video phụ thuộc quyền và trình duyệt.',
              ),
            ),
        ],
      ),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final Uint8List bytes;
  const FullScreenImage({super.key, required this.bytes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xem ảnh')),
      body: Center(child: InteractiveViewer(child: Image.memory(bytes))),
    );
  }
}
