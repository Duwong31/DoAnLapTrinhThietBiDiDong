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
        backgroundColor: AppTheme.appBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.toNamed(Routes.dashboard);
          },
        ),
        title: const Text(
          'Setting',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildMenuItem(context, 'Themes', const ThemesView()),
          _buildMenuItem(context, 'Audio Quality', const AudioQualityView()),
          _buildMenuItem(context, 'Video Quality', const VideoQualityView()),
          _buildMenuItem(context, 'Apps and Devices', const AppsDevicesView()),
          _buildMenuItem(context, 'Language', const LanguageView()),
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
        backgroundColor: AppTheme.appBar,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () {
            Get.toNamed(Routes.dashboard);
          },
        ),
        title: const Text(
          'Themes',
        ),
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
      appBar: AppBar(title: const Text('Audio Quality')),
      body: const Center(child: Text('Audio Quality settings here')),
    );
  }
}

class VideoQualityView extends StatelessWidget {
  const VideoQualityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Video Quality')),
      body: const Center(child: Text('Video Quality settings here')),
    );
  }
}

class AppsDevicesView extends StatelessWidget {
  const AppsDevicesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Apps and Devices')),
      body: const Center(child: Text('Apps and Devices settings here')),
    );
  }
}

class LanguageView extends StatelessWidget {
  const LanguageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Language')),
      body: const Center(child: Text('Language settings here')),
    );
  }
}

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: const Center(child: Text('About app information here')),
    );
  }
}
