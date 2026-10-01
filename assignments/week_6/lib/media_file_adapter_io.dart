import 'dart:io';

import 'package:image_picker/image_picker.dart';

Future<File> xFileToVideoSource(XFile file) {
  return Future.value(File(file.path));
}
