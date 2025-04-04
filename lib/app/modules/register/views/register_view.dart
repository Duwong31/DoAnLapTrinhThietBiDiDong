import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../core/utilities/screen.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/app_button.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RegisterView'),
        centerTitle: true,
      ),
      body: SizedBox(
        width: Screen.width(context),
        height: Screen.height(context),
        child: Center(
          child: Column(
            children: [
              'RegisterView'.text.makeCentered(),
              AppButton(
                'Home',
                onPressed: () {
                  Get.offAllNamed(Routes.dashboard);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
