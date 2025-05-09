part of 'repositories.dart';
enum AddTrackResult {
  success,
  failure,
  alreadyExists, 
}

abstract class UserBase {
  Future<bool> toggleNotify(bool val);
  Future<UserModel> getDetail();
  Future<UserModel> uploadAvatar(Uint8List bytes);
  Future<UserModel?> updateUser(Map<String, dynamic> data);
  Future<UserModel> updateUserProfile(Map<String, dynamic> data);
  Future<int?> uploadFile(File file, {int? folderId});
  Future<Dashboard> getDashboard();
  Future<UserModel> deleteRecipient();
  Future<UserModel> restoreRecipient();
  Future<bool> addAddress(String address, String apartment);
  Future<bool> verifyInformation(Map<String, dynamic> body);
  Future<dynamic> createPlaylist(String name);
  Future<List<Playlist>> getPlaylists();
  Future<bool> removeTrackFromPlaylist(int playlistId, String trackId);
  Future<bool> deletePlaylist(int playlistId);
  Future<AddTrackResult> addTrackToPlaylist(int playlistId, String trackId);
  Future<Map<String, dynamic>> updatePlaylist(int playlistId, String newName);

  Future<FavoriteResponse> getFavorites();
  Future<bool> addToFavorite(String trackId);
  Future<bool> removeFavorite(String trackId);
}

class UserRepository extends BaseRepository implements UserBase {
  final ApiClient _apiClient;
  UserRepository(this._apiClient);

  @override
  Future<UserModel> getDetail() {
    return handleCall(() => ApiProvider.getDetail());
  }

  @override
  Future<UserModel?> updateUser(Map<String, dynamic> data) {
    return handleCall(() => ApiProvider.updateUser(data));
  }

  @override
  Future<UserModel> updateUserProfile(Map<String, dynamic> data){
    return handleCall(() => ApiProvider.updateUserProfile(data));
  }

  @override
  Future<UserModel> uploadAvatar(Uint8List bytes) {
    return handleCall(() => ApiProvider.uploadAvatar(bytes));
  }
  @override
  Future<int?> uploadFile(File file, {int? folderId}) {
    return handleCall(() => ApiProvider.uploadFile(file, folderId: folderId));
  }

  @override
  Future<bool> toggleNotify(bool val) {
    return handleCall(() => ApiProvider.toggleNotify(val));
  }

  @override
  Future<Dashboard> getDashboard() {
    return handleCall(() => ApiProvider.getDashboard());
  }
  
  @override
  Future<UserModel> deleteRecipient() {
    return handleCall(() => ApiProvider.deleteRecipient());
  }
  
  @override
  Future<UserModel> restoreRecipient() {
    return handleCall(() => ApiProvider.restoreRecipient());
  }
  
  @override
  Future<bool> addAddress(String address, String apartment) {
    return handleCall(() => ApiProvider.addAddress(address, apartment));
  }

  @override
  Future<bool> verifyInformation(Map<String, dynamic> body) {
    return handleCall(() => ApiProvider.verifyInformation(body));
  }

  @override
  Future<dynamic> createPlaylist(String name) { 
    return handleCall(() => ApiProvider.createPlaylist(name));
  }

  @override
  Future<List<Playlist>> getPlaylists() { 
    return handleCall(() async {
      print("UserRepository: Calling ApiProvider.getPlaylists...");
      // Gọi provider (không cần tham số name)
      final responseData = await ApiProvider.getPlaylists();

      // Lấy danh sách data (an toàn)
      final List<dynamic> playlistData = responseData['data'] as List<dynamic>? ?? [];
      print("UserRepository: Received ${playlistData.length} playlist items from API.");

      // Parse thành List<Playlist>
      final playlists = playlistData
          .map((map) => Playlist.fromMap(map as Map<String, dynamic>)) // Hoặc fromJson
          .toList();

      print("UserRepository: Parsed ${playlists.length} playlists successfully.");
      return playlists;
    });
  }
  
  @override
  Future<bool> removeTrackFromPlaylist(int playlistId, String trackId) {
    return handleCall(() => ApiProvider.removeTrackFromPlaylist(playlistId, trackId));
  }

  @override
  Future<bool> deletePlaylist(int playlistId) {
    return handleCall(() => ApiProvider.deletePlaylist(playlistId));
  }

  @override
  Future<AddTrackResult> addTrackToPlaylist(int playlistId, String trackId) {
    return handleCall(() => ApiProvider.addTrackToPlaylist(playlistId, trackId));
  }

  @override
  Future<Map<String, dynamic>> updatePlaylist(int playlistId, String newName) {
    return handleCall(() => ApiProvider.updatePlaylist(playlistId, newName));
  }

  Future<FavoriteResponse> getFavorites() async {
    return handleCall(() async {
      final responseData = await ApiProvider.getFavorites();
      return FavoriteResponse.fromJson(responseData);
    });
  }

  @override
  Future<bool> addToFavorite(String trackId) async {
    return handleCall(() async {
      await ApiProvider.addToFavorite(trackId);
      return true; // Giả định thành công nếu không có exception
    });
  }

  @override
  Future<bool> removeFavorite(String trackId) async {
    return handleCall(() async {
      await ApiProvider.removeFavorite(trackId);
      return true; // Hoặc xử lý response nếu API trả về
    });
  }

  Future<List<Map<String, dynamic>>> getSongs(List<String> songIds) async {
    final response = await _apiClient.post('/songs/by-ids', data: {
      'ids': songIds,
    });

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(response.data['songs']);
    } else {
      throw Exception('Failed to fetch songs');
    }
  }
  Future<Map<String, dynamic>> getSong(String songId) async {
    final response = await _apiClient.get('/songs/$songId');

    if (response.statusCode == 200) {
      return Map<String, dynamic>.from(response.data);
    } else {
      throw Exception('Failed to fetch song');
    }
  }
}
