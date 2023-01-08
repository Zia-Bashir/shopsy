import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/Material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shopsy/src/firebase/firebase_references.dart';
import 'package:shopsy/src/utils/app_colors.dart';

class ImagePickerController extends GetxController {
  ImagePicker picker = ImagePicker();
  FirebaseStorage storage = FirebaseStorage.instance;
  File? image;

  pickerBottomSheet(context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    pickCameraImage();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                    child: const Icon(Icons.camera),
                  ),
                ),
                InkWell(
                  onTap: () {
                    pickGalleryImage();
                    Navigator.of(context).pop();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.mainColor,
                    ),
                    child: const Icon(Icons.image),
                  ),
                ),
              ],
            ),
          );
        });
  }

  pickCameraImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);
      File? imagePath = File(pickedFile!.path);
      image = imagePath;
      uploadIamgeIntoCollection(image!);
      update();
    } else {
      Fluttertoast.showToast(msg: "Camera Permission is required");
    }
  }

  pickGalleryImage() async {
    final status = await Permission.camera.request();
    if (status.isGranted) {
      XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      File? imagePath = File(pickedFile!.path);
      image = imagePath;
      //uploadIamgeIntoCollection(image!);
      update();
    } else {
      Fluttertoast.showToast(msg: "Storage Permission is required");
    }
  }

  uploadIamgeIntoCollection(File image) async {
    print("uploading....");
    try {
      Reference reference = storage.ref().child('abc').child("/image");

      UploadTask uploadTask = reference.putFile(image);
      await Future.value(uploadTask).onError((error, stackTrace) {
        return uploadTask;
      });
      print("upload Done");
      var url = await reference.getDownloadURL();
      print("url :  $url");
      //* -- add Picture into UserData Collection
      userRF.doc(authCurrentUser).update({
        'profileImg': url,
      });
    } catch (e) {
      print("catch e: $e");
    }
  }
}
