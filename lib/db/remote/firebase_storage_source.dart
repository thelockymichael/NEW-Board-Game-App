import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_demo_01/db/remote/response.dart';

class FirebaseStorageSource {
  FirebaseStorage instance = FirebaseStorage.instance;

  Future<Response<String>> uploadUserProfilePhoto(
      String filePath, String userId, int imageNumber) async {
    // TODO 1 to 6 images
    String userPhotoPath =
        "user_photos/$userId/profile_photo_${imageNumber.toString()}";

    try {
      await instance.ref(userPhotoPath).putFile(File(filePath));
      String downloadUrl = await instance.ref(userPhotoPath).getDownloadURL();
      return Response.success(downloadUrl);
    } catch (e) {
      return Response.error(((e as FirebaseException).message ?? e.toString()));
    }
  }
}
