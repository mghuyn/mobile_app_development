import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Bai2 extends StatefulWidget {
  const Bai2({super.key});
  @override
  State<Bai2> createState() => _Bai2State();
}

class _Bai2State extends State<Bai2> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _pick(ImageSource source) async {
    try {
      final file = await _picker.pickImage(source: source, imageQuality: 90);
      if (file != null && mounted) setState(() => _image = file);
    } catch (e) {
      _message('Không thể lấy ảnh: $e');
    }
  }

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bài 2 - Photo Capture & Preview')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: _image == null
                    ? const Text('Chưa có ảnh')
                    : FutureBuilder<Uint8List>(
                        future: _image!.readAsBytes(),
                        builder: (_, snapshot) => snapshot.hasData
                            ? GestureDetector(
                                onTap: () => Navigator.push(context,
                                  MaterialPageRoute(builder: (_) =>
                                    FullScreenImage2(bytes: snapshot.data!))),
                                child: Image.memory(snapshot.data!,
                                  fit: BoxFit.contain),
                              )
                            : const CircularProgressIndicator(),
                      ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pick(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Chọn ảnh từ thư viện'),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _pick(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Chụp ảnh bằng camera'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImage2 extends StatelessWidget {
  final Uint8List bytes;
  const FullScreenImage2({super.key, required this.bytes});
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Xem trước')),
    body: Center(child: InteractiveViewer(child: Image.memory(bytes))),
  );
}
