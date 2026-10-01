import 'package:flutter/material.dart';

import 'Bai01.dart';
import 'Bai02.dart';
import 'Bai03.dart';
import 'Bai04.dart';
import 'Bai05.dart';
import 'Bai06.dart';
import 'Bai07.dart';
import 'Bai06BTVN.dart';

void main() => runApp(const Week6App());

class Week6App extends StatelessWidget {
  const Week6App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bài 06 - Multimedia',
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    ),
    home: const HomePage(),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Bài 1', 'Media Picker & Viewer', Icons.perm_media, Bai1()),
      ('Bài 2', 'Photo Capture & Preview', Icons.photo_camera, Bai2()),
      ('Bài 3', 'Danh bạ & SMS', Icons.contacts, Bai3()),
      ('Bài 4', 'Video Recorder & Playback', Icons.video_library, Bai4()),
      ('Bài 5', 'Quản lý danh bạ', Icons.contact_page, Bai5()),
      ('Bài 6', 'Audio Player', Icons.music_note, Bai06()),
      ('BTVN 6', 'Ứng dụng nghe nhạc', Icons.library_music, BTVN06()),
      ('BTVN 7', 'SMS Analyzer', Icons.analytics, Bai7()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Bài 06 - Multimedia')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          final item = items[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Icon(item.$3)),
              title: Text(
                item.$1,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(item.$2),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => item.$4),
              ),
            ),
          );
        },
      ),
    );
  }
}
