import 'package:get/get.dart';
import '../../../data/models/playlist.dart';
import '../../../data/repositories/repositories.dart';
import '../../../core/styles/style.dart';

class PlaylistEditView extends StatefulWidget {
  final Playlist playlist;
  
  const PlaylistEditView({super.key, required this.playlist});

  @override
  State<PlaylistEditView> createState() => _PlaylistEditViewState();
}

class _PlaylistEditViewState extends State<PlaylistEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  final _userRepository = Get.find<UserRepository>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.playlist.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _updatePlaylist() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await _userRepository.updatePlaylist(
        widget.playlist.id,
        _nameController.text.trim(),
      );

      if (response['status'] == 1) {
        // Tạo playlist mới với tên đã cập nhật
        final updatedPlaylist = Playlist(
          id: widget.playlist.id,
          name: _nameController.text.trim(),
          trackIds: widget.playlist.trackIds,
        );
        
        Get.back(result: updatedPlaylist); // Trả về playlist đã cập nhật
        Get.snackbar(
          'Success',
          'Playlist updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Playlist'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          onPressed: () => Get.back(),
        ),
        actions: [
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _updatePlaylist,
              child: const Text(
                'Save',
                style: TextStyle(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Playlist Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter playlist name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
