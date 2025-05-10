import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../core/styles/style.dart';

class LottieSplashView extends StatefulWidget {
  final String animationPath;
  final Duration duration;
  final String nextRoute;
  final String? successText;

  const LottieSplashView({
    super.key,
    required this.animationPath,
    required this.duration,
    required this.nextRoute,
    this.successText = "Verification Successful!",
  });

  @override
  State<LottieSplashView> createState() => _LottieSplashViewState();
}

class _LottieSplashViewState extends State<LottieSplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.duration, () {
      Get.offNamed(widget.nextRoute); 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min, 
          crossAxisAlignment: CrossAxisAlignment.center, 
          children: [
            Lottie.asset(
              widget.animationPath, 
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            Dimes.height10,
            if (widget.successText != null && widget.successText!.isNotEmpty)
              Text(
                widget.successText!, 
                style: TextStyle(
                  fontSize: 18.0, 
                  fontWeight: FontWeight.w600, 
                  color: Colors.orange[800], 
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}
