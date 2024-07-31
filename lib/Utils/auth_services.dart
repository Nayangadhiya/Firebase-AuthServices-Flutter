import 'package:fire_services/Utils/preference_utils.dart';
import 'package:fire_services/Utils/utils.dart';
import 'package:fire_services/screens/home_screen.dart';
import 'package:fire_services/screens/login_screen.dart';
import 'package:fire_services/screens/otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta_login/insta_login.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthServices extends ChangeNotifier {
  bool isGoogleLoader = false;
  bool isAppleLoader = false;
  bool isInstagramLoader = false;
  bool isTwitterLoader = false;
  bool isFacebookLoader = false;

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void _setLoader({
    bool google = false,
    bool apple = false,
    bool instagram = false,
    bool twitter = false,
    bool facebook = false,
  }) {
    isGoogleLoader = google;
    isAppleLoader = apple;
    isInstagramLoader = instagram;
    isTwitterLoader = twitter;
    isFacebookLoader = facebook;
    notifyListeners();
  }

  // Sign Up With email and password

  Future<void> signUp(
      String? email, String? password, BuildContext context) async {
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid email and password.");
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Sign Up Error: $e");
      Fluttertoast.showToast(msg: e.message ?? "Sign Up failed.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // Login With email and password
  Future<void> loginUser(
      String? email, String? password, BuildContext context) async {
    if (email == null ||
        email.isEmpty ||
        password == null ||
        password.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid email and password.");
      return;
    }
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Login Error: $e");
      Fluttertoast.showToast(msg: e.message ?? "Login failed.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // Forgot Password
  Future<void> forgotPassword(String? email, BuildContext context) async {
    if (email == null || email.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid email.");
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Forgot Password Error: $e");
      Fluttertoast.showToast(msg: e.message ?? "Password reset failed.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // Phone Authentication
  Future<void> phonAuth(String? phone, BuildContext context) async {
    if (phone == null || phone.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter a valid phone number.");
      return;
    }
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phone,
        verificationCompleted: (PhoneAuthCredential credential) {
          // Auto-retrieval or instant verification
        },
        verificationFailed: (FirebaseException e) {
          debugPrint("Phone Auth Error: $e");
          Fluttertoast.showToast(msg: "Phone authentication failed.");
        },
        codeSent: (String verificationId, int? resendToken) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => OTPScreen(verifyOTP: verificationId),
            ),
            (route) => false,
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-retrieval timeout
        },
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("Phone Auth Error: $e");
      Fluttertoast.showToast(msg: e.message ?? "Phone authentication failed.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // OTP Verification
  Future<void> verifyOtp(String? verificationId,
      TextEditingController otpController, BuildContext context) async {
    if (verificationId == null || otpController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Invalid verification ID or OTP.");
      return;
    }
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      debugPrint("OTP Verification Error: $e");
      Fluttertoast.showToast(msg: e.message ?? "OTP verification failed.");
    } catch (e) {
      debugPrint("Unexpected Error: $e");
      Fluttertoast.showToast(msg: "An unexpected error occurred.");
    }
  }

  // Sign In with Google..............
  Future<dynamic> signInWithGoogle(BuildContext context) async {
    try {
      if (await Utils.checkInternet()) {
        _setLoader(google: true);
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleKey =
              await googleUser.authentication;
          if (googleKey.accessToken != null) {
            PreferenceUtils.setStringPref(
                key: 'GoogleToken', value: googleKey.accessToken.toString());
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
            Utils.toast(message: "Login Successfully With Google");
          } else {
            Utils.toast(
                message: "Failed to retrieve Google authentication token.");
          }
        } else {
          Utils.toast(
              message: "Google sign-in cancelled or encountered an error.");
        }
      } else {
        Utils.toast(message: "Please Check Internet");
      }
    } catch (error) {
      Utils.toast(message: "An error occurred: ${error.toString()}");
    } finally {
      _setLoader(google: false);
    }
  }

  // LogOut with Google
  Future<dynamic> signOutGoogle(BuildContext context) async {
    try {
      _setLoader(google: true);
      await _googleSignIn.signOut();
      PreferenceUtils.removePref(key: 'GoogleToken');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Utils.toast(message: "Logout Successfully");
    } catch (error) {
      debugPrint('Error signing out: $error');
      Utils.toast(message: "Error signing out: ${error.toString()}");
    } finally {
      _setLoader(google: false);
    }
  }

  // sign in with Apple.........

  Future<dynamic> signInWithApple(BuildContext context) async {
    try {
      if (await Utils.checkInternet()) {
        _setLoader(apple: true);
        final AuthorizationCredentialAppleID credential =
            await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

        if (credential.identityToken != null) {
          PreferenceUtils.setStringPref(
              key: 'AppleToken', value: credential.identityToken!);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
          Utils.toast(message: "Login Successfully With Apple");
        } else {
          Utils.toast(
              message: "Failed to retrieve Apple authentication token.");
        }
      } else {
        Utils.toast(message: "Please Check Internet");
      }
    } catch (error) {
      Utils.toast(message: "An error occurred: ${error.toString()}");
    } finally {
      _setLoader(apple: false);
    }
  }

  // Sign out with apple......

  Future<dynamic> signOutApple(BuildContext context) async {
    try {
      _setLoader(apple: true);
      PreferenceUtils.removePref(key: 'AppleToken');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Utils.toast(message: "Logout Successfully");
    } catch (error) {
      debugPrint('Error signing out: $error');
      Utils.toast(message: "Error signing out: ${error.toString()}");
    } finally {
      _setLoader(apple: false);
    }
  }

  // Sign In with Instagram
  Future<void> signInWithInstagram(BuildContext context) async {
    try {
      if (await Utils.checkInternet()) {
        _setLoader(instagram: true);
        final result = await InstaLogin().login();
        if (result.token != null) {
          PreferenceUtils.setStringPref(
              key: 'InstagramToken', value: result.token!);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
          Utils.toast(message: "Login Successfully With Instagram");
        } else {
          Utils.toast(message: "Failed to retrieve Instagram token.");
        }
      } else {
        Utils.toast(message: "Please Check Internet");
      }
    } catch (error) {
      Utils.toast(message: "An error occurred: ${error.toString()}");
    } finally {
      _setLoader(instagram: false);
    }
  }

// Sign Out with Instagram
  Future<void> signOutInstagram(BuildContext context) async {
    try {
      _setLoader(instagram: true);
      // await InstaLogin().logout;
      PreferenceUtils.removePref(key: 'InstagramToken');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Utils.toast(message: "Logout Successfully");
    } catch (error) {
      debugPrint('Error signing out: $error');
      Utils.toast(message: "Error signing out: ${error.toString()}");
    } finally {
      _setLoader(instagram: false);
    }
  }

// Sign In with Twitter
  Future<void> signInWithTwitter(BuildContext context) async {
    try {
      if (await Utils.checkInternet()) {
        _setLoader(twitter: true);
        final twitterLogin = TwitterLogin(
          apiKey: 'your_api_key',
          apiSecretKey: 'your_api_secret_key',
          redirectURI: 'your_redirect_uri',
        );
        final result = await twitterLogin.login();
        switch (result.status) {
          case TwitterLoginStatus.loggedIn:
            PreferenceUtils.setStringPref(
                key: 'TwitterToken', value: result.authToken!);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
            Utils.toast(message: "Login Successfully With Twitter");
            break;
          case TwitterLoginStatus.cancelledByUser:
            Utils.toast(message: "Twitter sign-in cancelled.");
            break;
          case TwitterLoginStatus.error:
            Utils.toast(
                message: "Twitter sign-in error: ${result.errorMessage}");
            break;
          case null:
        }
      } else {
        Utils.toast(message: "Please Check Internet");
      }
    } catch (error) {
      Utils.toast(message: "An error occurred: ${error.toString()}");
    } finally {
      _setLoader(twitter: false);
    }
  }

// Sign Out with Twitter
  Future<void> signOutTwitter(BuildContext context) async {
    try {
      _setLoader(twitter: true);
      // await TwitterLogin().logOut();
      PreferenceUtils.removePref(key: 'TwitterToken');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Utils.toast(message: "Logout Successfully");
    } catch (error) {
      debugPrint('Error signing out: $error');
      Utils.toast(message: "Error signing out: ${error.toString()}");
    } finally {
      _setLoader(twitter: false);
    }
  }

// Sign In with Facebook
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      if (await Utils.checkInternet()) {
        _setLoader(facebook: true);
        final result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          final AccessToken accessToken = result.accessToken!;
          PreferenceUtils.setStringPref(
              key: 'FacebookToken', value: accessToken.token);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false);
          Utils.toast(message: "Login Successfully With Facebook");
        } else {
          Utils.toast(message: "Facebook sign-in error: ${result.message}");
        }
      } else {
        Utils.toast(message: "Please Check Internet");
      }
    } catch (error) {
      Utils.toast(message: "An error occurred: ${error.toString()}");
    } finally {
      _setLoader(facebook: false);
    }
  }

// Sign Out with Facebook
  Future<void> signOutFacebook(BuildContext context) async {
    try {
      _setLoader(facebook: true);
      await FacebookAuth.instance.logOut();
      PreferenceUtils.removePref(key: 'FacebookToken');
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          ),
          (route) => false);
      Utils.toast(message: "Logout Successfully");
    } catch (error) {
      debugPrint('Error signing out: $error');
      Utils.toast(message: "Error signing out: ${error.toString()}");
    } finally {
      _setLoader(facebook: false);
    }
  }
}
