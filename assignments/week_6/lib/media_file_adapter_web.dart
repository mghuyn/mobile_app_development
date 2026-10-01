import 'package:image_picker/image_picker.dart';

Future<String> xFileToVideoSource(XFile file) {
  return Future.value(file.path);
}
