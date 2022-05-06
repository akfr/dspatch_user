import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

Future<String> pickAndGetImageUrl(String bucket) async {
  final ImagePicker _picker = ImagePicker();
  final pickedFile = await _picker.getImage(source: ImageSource.gallery);
  var uuid = Uuid().v1();
  var imageFile = File(pickedFile.path);
  final Reference reference = FirebaseStorage.instance
      .ref()
      .child('$bucket')
      .child(uuid + imageFile.uri.pathSegments.last);
  final UploadTask uploadTask = reference.putFile(imageFile);
  String url;
  await uploadTask.whenComplete(() async {
    url = await uploadTask.snapshot.ref.getDownloadURL();
  });
  return url;
}
