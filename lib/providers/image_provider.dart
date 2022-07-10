import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:monopoly/api/api_constants.dart';
import 'package:monopoly/config/values.dart';
import 'package:monopoly/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:monopoly/providers/user_provider.dart';
import 'package:monopoly/widgets/helping_dialog.dart';
import 'package:provider/provider.dart';

class ImagesProvider extends ChangeNotifier {
  List<XFile?> _allSelectedImages = [];

  bool _isChecked = false;

  final _image = ImagePicker();

  bool _imageUploading = false;

  chooseGallery(User user) async {
    try {
      await Future.delayed(Duration.zero);
      _imageUploading = true;
      notifyListeners();
      final storage = FirebaseStorage.instance;

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
      if (gallery.isNotEmpty) {
        var tokenRef = storage.ref().child('token/${user.serverId}/tokenUrl');
        await tokenRef.putFile(File(gallery.first!.path));
        String link = await tokenRef.getDownloadURL();

        _allSelectedImages.addAll(gallery);

        // Map<String, String> headers = {
        //   'Content-Type': 'application/json',
        //   'x-access-token': user.token ?? ''
        // };
        // var request = http.MultipartRequest("POST",
        //     Uri.parse(
        //         "${ApiConstants.domain}${ApiConstants.uploadTokenImage}"));
        // request.headers.addAll(headers);
        // request.fields["user"] = json.encode(user);
        // if (gallery.first != null) {
        //   request.files.add(
        //       await http.MultipartFile.fromPath('file', image.path));
        // }j
        //
        // // request.files.add(pic);
        // var response = await request.send();
        // //debugPrint(" imageSend response $response");
        //
        // var responseData = await response.stream.toBytes();
        // var responseString = String.fromCharCodes(responseData);
        // // print('uploadFeedback $responseString');
        // //print('response: $responseString');
        // var parsedJson = json.decode(responseString);

        Uri url =
            Uri.parse('${ApiConstants.domain}${ApiConstants.uploadTokenImage}');
        var body = {
          'tokenImageUrl': link,
          'serverId': user.serverId,
        };
        debugPrint('$url');
        var response = await http.post(
          url,
          body: json.encode(body),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': user.token ?? ''
          },
        );
        debugPrint('upload image response ${response.body}');
        if (response.statusCode == 200) {
          var userRes = json.decode(response.body);
          var user = User.fromJson(userRes);
          Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                  listen: false)
              .updateUser(user);
          Navigator.pop(Values.navigatorKey.currentContext!);
        } else if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 402 ||
            response.statusCode == 403 ||
            response.statusCode == 405) {
          HelpingDialog.showServerResponseDialog(response.body);
        } else {
          HelpingDialog.showServerResponseDialog('Unknown Server Error');
        }
      }

      notifyListeners();
    } on FirebaseException catch (e, st) {
      HelpingDialog.showServerResponseDialog('Error 111');
    } catch (e, st) {
      debugPrint("chooseGallery  error $e $st");
      HelpingDialog.showServerResponseDialog('Unknown error 112');
    } finally {
      _imageUploading = false;
      notifyListeners();
    }
  }

  chooseGalleryProfile(User user) async {
    try {
      await Future.delayed(Duration.zero);
      _imageUploading = true;
      notifyListeners();
      final storage = FirebaseStorage.instance;

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
      if (gallery.isNotEmpty) {
        var tokenRef =
            storage.ref().child('profile/${user.serverId}/profile_image_url');
        await tokenRef.putFile(File(gallery.first!.path));
        String link = await tokenRef.getDownloadURL();

        _allSelectedImages.addAll(gallery);

        Uri url = Uri.parse(
            '${ApiConstants.domain}${ApiConstants.uploadProfileImage}');
        var body = {
          'profileImageUrl': link,
          'serverId': user.serverId,
        };
        debugPrint('$url');
        var response = await http.post(
          url,
          body: json.encode(body),
          headers: {
            'Content-Type': 'application/json',
            'x-access-token': user.token ?? ''
          },
        );
        debugPrint('upload image response ${response.body}');
        if (response.statusCode == 200) {
          var userRes = json.decode(response.body);
          var user = User.fromJson(userRes);
          Provider.of<UserProvider>(Values.navigatorKey.currentContext!,
                  listen: false)
              .updateUser(user);
          Navigator.pop(Values.navigatorKey.currentContext!);
        } else if (response.statusCode == 400 ||
            response.statusCode == 401 ||
            response.statusCode == 402 ||
            response.statusCode == 403 ||
            response.statusCode == 405) {
          HelpingDialog.showServerResponseDialog(response.body);
        } else {
          HelpingDialog.showServerResponseDialog('Unknown Server Error');
        }
      }

      notifyListeners();
    } on FirebaseException catch (e, st) {
      HelpingDialog.showServerResponseDialog('Error 111');
    } catch (e, st) {
      debugPrint("chooseGallery  error $e $st");
      HelpingDialog.showServerResponseDialog('Unknown error 112');
    } finally {
      _imageUploading = false;
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

  bool get imageUploading => _imageUploading;

  List<XFile?> get images => _allSelectedImages;
}
