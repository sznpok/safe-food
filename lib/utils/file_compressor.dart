import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

Future<Uint8List?> compressFile(XFile file) async {
  var result = await FlutterImageCompress.compressWithFile(
    file.path,
    quality: 50,
  );
  print(await file.length());
  return result;
}
