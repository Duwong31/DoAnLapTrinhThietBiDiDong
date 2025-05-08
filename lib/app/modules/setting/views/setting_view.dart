import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/setting_controller.dart';

class SettingView extends GetView<SettingController> {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'Setting',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildMenuItem(context, 'themes'.tr, const ThemesView()),
          _buildMenuItem(context, 'audio_quality'.tr, const AudioQualityView()),
          _buildMenuItem(context, 'video_quality'.tr, const VideoQualityView()),
          _buildMenuItem(context, 'apps_and_devices'.tr, const AppsDevicesView()),
          _buildMenuItem(context, 'languages'.tr, LanguageView()),
          _buildMenuItem(context, 'about'.tr, const AboutView()),
        ],
      ),
    );
  }
}

Widget _buildMenuItem(BuildContext context, String title, Widget destination) {
  return ListTile(
    title: Text(title),
    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    },
  );
}

// các class
class ThemesView extends StatelessWidget {
  const ThemesView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>(); // "Gọi lại" controller đã khởi tạo

    final isDarkMode = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'themes'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Obx(() {
          final isDarkMode = themeController.themeMode.value == ThemeMode.dark;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SwitchListTile(
                title: Text(isDarkMode ? 'switch_to_light_mode'.tr : 'switch_to_dark_mode'.tr),
                value: isDarkMode,
                onChanged: (value) {
                  themeController.toggleTheme();
                },
              ),
            ],
          );
        }),
      ),
    );
  }
}

class AudioQualityView extends StatelessWidget {
  const AudioQualityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'audio_quality'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),

      body: const Center(child: Text('Audio Quality settings here')),
    );
  }
}

class VideoQualityView extends StatelessWidget {
  const VideoQualityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'video_quality'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: const Center(child: Text('Video Quality settings here')),
    );
  }
}

class AppsDevicesView extends StatelessWidget {
  const AppsDevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'apps_and_devices'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),

      body: const Center(child: Text('Apps and Devices settings here')),
    );
  }
}

class LanguageView extends StatelessWidget {
  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'languages'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'select_language'.tr,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // English
            ListTile(
              title: Text('english'.tr),
              leading: Radio<Locale>(
                value: const Locale('en', 'US'),
                groupValue: controller.selectedLocale ,
                onChanged: (Locale? value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                  }
                },
              ),
            ),

            // Vietnamese
            ListTile(
              title: Text('vietnamese'.tr),
              leading: Radio<Locale>(
                value: const Locale('vi', 'VN'),
                groupValue: controller.selectedLocale,
                onChanged: (Locale? value) {
                  if (value != null) {
                    controller.changeLanguage(value);
                  }
                },
              ),
            ),
          ],
        )),
      ),
    );
  }
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.dashboard);
            }
          },
        ),
        title: Text(
          'about'.tr,
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: const Center(child: Text('About app information here')),
    );
  }
}
