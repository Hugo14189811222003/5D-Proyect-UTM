import "dart:io";
import "package:firebase_storage/firebase_storage.dart";

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String?> uploadImage( File image ) async {
  print(image.path);
  final String nameFile = image.path.split("/").last;
  final Reference ref = storage.ref().child("imgPets").child(nameFile);
  final UploadTask uploadTask = ref.putFile(image);
  print(uploadTask);
  final TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => true);
  print(taskSnapshot);
  final String url = await taskSnapshot.ref.getDownloadURL();
  print(url);

  if(taskSnapshot.state == TaskState.success){
    return url;
  } else {
    return null;
  }
}