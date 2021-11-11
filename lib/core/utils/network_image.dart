import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

Future<String?> urlToFile(String imageUrl) async {
  Dio dio = Dio();
// generate random number.
  var rng = DateTime.now().microsecondsSinceEpoch;
// get temporary directory of device.
  Directory tempDir = await getTemporaryDirectory();
// get temporary path from temporary directory.
  String tempPath = tempDir.path;
// create a new file in temporary path with random file name.
  File file = File(tempPath+ (rng.toString() +'.png'));
// call http.get method and pass imageUrl into it to get response.
  try {
    await dio.download(
        imageUrl, file.path);
  } on DioError catch (e) {
    print("error "+e.message);
    return null;
  }
  return file.path;
}