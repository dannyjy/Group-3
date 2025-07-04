import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to upload an image to Firebase Storage
  Future<String> uploadImageToStorage(
    String childName,
    Uint8List file,
  ) async {
    // Create a reference to the file to be uploaded.
    // A unique ID is generated for each image to prevent overwrites.
    String id = const Uuid().v1();
    Reference ref =
        _storage.ref().child(childName).child(_auth.currentUser!.uid).child(id);

    // Upload the file
    UploadTask uploadTask = ref.putData(file);

    // Get the download URL
    TaskSnapshot snap = await uploadTask;
    String downloadUrl = await snap.ref.getDownloadURL();
    return downloadUrl;
  }
}
