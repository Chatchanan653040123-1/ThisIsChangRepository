//To change these value type flutter run then press shift+r
//TO Disable function switch type of boolean from true to false
class Config {
  static bool isResetPassword = true; //forgot password function
  static bool isSignup = true; //Sign up function

  //Check strength password function
  static bool isPasswordStength = false;
  static bool hasUppercase = true;
  static bool hasLowercase = true;
  static bool hasNumber = true;
  static bool hasSpecialCharacter = true;

  static bool isLogin = true; //Login function
  static bool isLoginWithGoogle = true; //Login with google function
  static int lengthOfPassword = 8; // Length of password
  static List<String> domainKey = ['com', 'th', 'net']; //keyword check
}