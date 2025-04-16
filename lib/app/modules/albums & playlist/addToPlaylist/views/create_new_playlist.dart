import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/styles/style.dart';

class CreateNewPlaylist extends StatefulWidget {
  const CreateNewPlaylist({Key? key}) : super(key: key);

  @override
  State<CreateNewPlaylist> createState() => _CreateNewPlaylistState();
}

class _CreateNewPlaylistState extends State<CreateNewPlaylist> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createPlaylist() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar("Oops", "Playlist name can't be empty.",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    // TODO: Gửi name lên controller hoặc xử lý lưu playlist
    Get.back();
    Get.snackbar("Success", "Playlist \"$name\" created!",
        backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Playlist"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: isDark ? Colors.white : Colors.black,
      ),
      backgroundColor: isDark ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            const Text(
              "Create your playlist's name",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            /// Field input kiểu underline
              Row(
                children: [
                const SizedBox(width: 12), // Tương ứng Dimes.width12
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      isDense: true,
                    ),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            /// Row gồm 2 nút
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createPlaylist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Create",
                        style: TextStyle(
                            color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 16), // Khoảng cách giữa 2 nút
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(
                          color: isDark ? Colors.white24 : Colors.black26),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(
                            color: Colors.black, fontSize: 16, fontWeight: FontWeight.normal)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
