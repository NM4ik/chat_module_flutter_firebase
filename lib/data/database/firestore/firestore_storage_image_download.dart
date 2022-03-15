import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorageDownloadImage {
  Future<void> uploadFileToFireStorage(String destination, File file) async {
    try {
      await FirebaseStorage.instance.ref(destination).putFile(file);
    } on FirebaseException catch (_) {
      return;
    }
  }

  Future<File> selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    String path = 'https://www.beddingwarehouse.com.au/wp-content/uploads/2016/01/placeholder-featured-image.png';

    if (result != null) {
      path = result.files.single.path!;
    }

    final file = File(path);

    return file;
  }

  Future<String> uploadFile(File file) async {
    // final file = await selectFile();
    final destination = '$file';
    uploadFileToFireStorage(destination, file);

    return await FirebaseStorage.instance.ref(destination).getDownloadURL();
  }
}
