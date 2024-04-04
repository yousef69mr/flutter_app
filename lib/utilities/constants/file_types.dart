import 'package:path/path.dart';

List<String> imageExtensions = [
  '.png',
  '.jpg',
  '.gif',
  '.webp',
  '.svg',
  '.jpeg'
];

List<String> videoExtensions = [
  '.mp4',
];

Map<String, String> fileDetector(String filename) {
  String type;
  String fileExtension = extension(filename);
  if (imageExtensions.contains(fileExtension)) {
    type = 'image';
  } else if (imageExtensions.contains(fileExtension)) {
    type = 'video';
  } else {
    type = 'application';
  }

  return {"type": type, "extension": fileExtension.substring(1)};
}
