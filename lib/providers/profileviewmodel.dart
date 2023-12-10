import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/profile.dart';
import '../models/user.dart';
import '../repositories/user_repository.dart';

class ProfileViewModel with ChangeNotifier {
  int status = 0; //
  int modified = 0;
  int updateavartar = 0;
  void updatescreen() {
    notifyListeners();
  }
  void setupdatedavartar(){
    updateavartar=1;
    notifyListeners();
  }
  Future<void> uploadAvatar(XFile image) async {
    status = 1;
    notifyListeners();
    await UserRepository().uploadAvatar(image);
    var user = await UserRepository().getUserInfo();
    Profile().user = User.fromUser(user);
    updateavartar = 0;
    status = 0;
    notifyListeners();
  }

  void displaySpinner() {
    status = 1;
    notifyListeners();
  }

  void setModified() {
    if (modified == 0) {
      modified = 1;
      notifyListeners();
    }
  }

  void hideSpinner() {
    status = 0;
    notifyListeners();
  }
  Future<void> updateProfile() async {
    status=1;
    notifyListeners();
    await UserRepository().updateProfile();
    status=0;
    modified=0;
    notifyListeners();
  }
  
}
