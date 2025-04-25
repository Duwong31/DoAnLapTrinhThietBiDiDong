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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.grey[100],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.toNamed(Routes.dashboard);
          },
        ),
        title: const Text(
          'Settings',
          style: TextStyle(color: Color(0XFF000000), fontSize: 20, fontFamily: 'Noto Sans'),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildMenuItem(context, 'Themes', const ThemesView()),
          _buildMenuItem(context, 'Audio Quality', const AudioQualityView()),
          _buildMenuItem(context, 'Video Quality', const VideoQualityView()),
          _buildMenuItem(context, 'Apps and Devices', const AppsDevicesView()),
          _buildMenuItem(context, 'Languages', LanguageView()),
          _buildMenuItem(context, 'About', const AboutView()),
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
    final themeController = Get.find<ThemeController>(); // 💡 "Gọi lại" controller đã khởi tạo

    final isDarkMode = themeController.themeMode.value == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Themes', style: TextStyle(color: Colors.black, fontSize: 20),),
      ),
      body: Center(
        child: Obx(() {
          final isDarkMode = themeController.themeMode.value == ThemeMode.dark;
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Current Theme: ${isDarkMode ? 'Dark' : 'Light'}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text(isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode'),
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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Audio Quality', style: TextStyle(color: Colors.black, fontSize: 20),),
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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Video Quality', style: TextStyle(color: Colors.black, fontSize: 20),),
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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Apps and Devices', style: TextStyle(color: Colors.black, fontSize: 20),),
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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Languages', style: TextStyle(color: Colors.black, fontSize: 20),),
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
              title: const Text('English'),
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
              title: const Text('Tiếng Việt'),
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
        elevation: .1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black,),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('About', style: TextStyle(color: Colors.black, fontSize: 20),),
      ),
      body: const Center(child: Text('About app information here')),
    );
  }
}
