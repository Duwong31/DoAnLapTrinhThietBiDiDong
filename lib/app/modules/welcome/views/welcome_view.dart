import 'package:get/get.dart' hide ContextExtensionss;

import '../../../core/styles/style.dart';
import '../../../core/utilities/image.dart';
import '../../../widgets/app_button.dart';
import '../../../widgets/page_indicators.dart';
import '../controllers/welcome_controller.dart';

class WelcomeView extends GetView<WelcomeController> {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(         
            children: [
              const SizedBox(height: 300),
              Image.asset(
                AppImage.logo,
                width: 80,
                color: AppTheme.primary, 
              ),

              const SizedBox(height: 20),

              const Text(
                "Sound your life.",
                style: TextStyle(
                  fontSize: 30,
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(),

              //SIGN UP BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: (){
                    controller.changePage();
                  }, 
                  child: const Text(
                    'Sign up free',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              //LOG IN BUTTON
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Colors.deepOrange, 
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    controller.changePage();
                  },
                  child: const Text(
                    "Log in",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary,
                    ),
                  ),
                ),
              ),
              ),
              
            ],
          ),          
        ),
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  const ItemPage({
    super.key,
    required this.slider,
  });
  final SlideModel slider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Image.asset(slider.image),
        ),
        Dimes.height40,
        slider.title.text
            .size(20)
            .color(const Color(0xff00AB97))
            .medium
            .center
            .make(),
        Dimes.height10,
        slider.subtitle.text.center.make().pSymmetric(h: context.height * .02),
      ],
    );
  }
}
