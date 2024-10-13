import 'package:get/get.dart';
import 'package:microlearning/user_repository.dart';
import 'package:microlearning/authentication_repository.dart'; 
import 'profile_page.dart';
class ProfileController extends GetxController {
  static ProfileController get instance => Get.find();

  final _authRepo = Get.put(AuthenticationRepository());
  final _userRepo = Get.put(UserRepository());

  var userDetails = Rx<UserModel?>(null);

  Future<void> getUserData() async {
    final email = _authRepo.firebaseUser.value?.email; 
    if (email != null) {
      final fetchedUserDetails = await _userRepo.getUserDetails(email);
      if (fetchedUserDetails != null) {
        userDetails.value = fetchedUserDetails; // Mengupdate userDetails
        update(); // Memperbarui state di UI
      }
    } else {
      // Tampilkan SnackBar jika email null
      Get.snackbar("Error", "Login to continue", snackPosition: SnackPosition.BOTTOM); // Menggunakan Get.snackbar
    }
  }
}
