import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;

class ImagesProvider extends ChangeNotifier {
  List<XFile?> _allSelectedImages = [];
  bool _isChecked = false;
  final _image = ImagePicker();

  chooseGallery(User user) async {
    try {
      Future.delayed(Duration.zero);
      //XFile?  galleryImage= await _image.pickImage(source: ImageSource.gallery);
      List<XFile?>? gallery = await _image.pickMultiImage(imageQuality: 80);
      //debugPrint("${(File(gallery!.path).lengthSync())}");
      // debugPrint(
      //  " size: ${DateUtility.getFileSizeString(bytes: gallery!.first!.path.length)}");
      for (var i in gallery!) {
        int single = File(i!.path).lengthSync();
        debugPrint("$single b");
        debugPrint("${single / (1024 * 1024)} mb");
      }

      _allSelectedImages.addAll(gallery);

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'x-access-token': user.token ?? ''
      };
      var request = http.MultipartRequest("POST",
          Uri.parse("${ApiConstants.domain}${ApiConstants.uploadTokenImage}"));
      request.headers.addAll(headers);
      request.fields["user"] = json.encode(user);
      if (gallery.first != null) {
        request.files.add(
            await http.MultipartFile.fromPath('file', gallery.first!.path));
      }

      // request.files.add(pic);
      var response = await request.send();
      //debugPrint(" imageSend response $response");

      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      // print('uploadFeedback $responseString');
      //print('response: $responseString');
      var parsedJson = json.decode(responseString);

      debugPrint('response parsed: $parsedJson');

      notifyListeners();
    } catch (e, st) {
      debugPrint("chooseGallery  error $e $st");
    } finally {
      notifyListeners();
    }
  }

  removePhoto(position) {
    try {
      _allSelectedImages.removeAt(position);
    } catch (e, st) {
      debugPrint("remove error $e $st");
    } finally {
      notifyListeners();
    }
  }

  chooseCamera() async {
    try {
      XFile? cameraImage = await _image.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      debugPrint("${(File(cameraImage!.path).lengthSync())}");
      if (cameraImage == null) {
      } else {
        _allSelectedImages.add(cameraImage);
      }
    } catch (e, st) {
      debugPrint("chooseCamera $e $st");
    } finally {
      _allSelectedImages.clear();
      notifyListeners();
    }
  }

  hasPhoto(bool value) {
    try {
      _isChecked = value;
    } catch (e, st) {
      debugPrint(" hasPhoto:$e$st");
    } finally {
      _isChecked = false;
      // notifyListeners();
    }
  }

  imageClear() async {
    _allSelectedImages = [];
    notifyListeners();
  }

  bool get isChecked => _isChecked;

  List<XFile?> get images => _allSelectedImages;
}
