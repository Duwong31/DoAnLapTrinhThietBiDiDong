import 'package:get/get.dart';

import '../core/styles/style.dart';
import '../core/utilities/image.dart';
import '../routes/app_pages.dart';

class SongOptionsSheet extends StatelessWidget {
  const SongOptionsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ListTile(
          leading: const Icon(Icons.playlist_add, color: Colors.black),
          title: const Text('Add to playlist'),
          onTap: () {
            Get.toNamed(Routes.addToPlaylist);
          },
        ),
        ListTile(
          leading: Image.asset(
            AppImage.logo1,
            width: 20,
            color: AppTheme.primary,
          ),
          title: const Text('Try Premium'),
          onTap: () {
            // Handle logic
            Get.toNamed(Routes.premium);
          },
        ),
        ListTile(
          leading: const Icon(Icons.person, color: Colors.black),
          title: const Text('View artists'),
          onTap: () {
            // Handle logic
            Get.back();
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
