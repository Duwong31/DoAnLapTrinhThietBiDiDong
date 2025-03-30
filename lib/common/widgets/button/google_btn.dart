import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soundflow/common/widgets/tabbar/tabbar.dart';
import 'package:soundflow/core/configs/assets/app_vectors.dart';
import 'package:soundflow/data/sources/auth/auth_firebase_service.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback onPressed;
  final AuthFirebaseServiceImpl _auth = AuthFirebaseServiceImpl();
  GoogleButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async{
        final userCredential = await _auth.loginWithGoogle();
        if (userCredential != null && userCredential.user != null) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Tabbar()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Google Sign-in failed. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.grey[200], // màu nền xám nhạt
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Google
            SvgPicture.asset(
              AppVectors.google,
              width: 24,
            ),
            const SizedBox(width: 8),
            // Text
            const Text(
              "Continue with Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
