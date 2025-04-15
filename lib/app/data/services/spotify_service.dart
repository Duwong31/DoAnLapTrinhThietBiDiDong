// import 'package:spotify_sdk/spotify_sdk.dart';

// class SpotifyService {
//   static const _clientId    = 'e965f9c3a7464b76bd8116bfb96ddca3';
//   static const _redirectUrl = 'myapp://auth';
//   static const _scopes      = 'app-remote-control,streaming,user-read-email,user-read-private,user-modify-playback-state';

//   /// Khởi tạo kết nối với Spotify Remote SDK
//   static Future<bool> init() async {
//     try {
//       // 1. Lấy Access Token qua OAuth (PKCE)
//       final token = await SpotifySdk.getAccessToken(
//         clientId: _clientId,
//         redirectUrl: _redirectUrl,
//         scope: _scopes,
//       );

//       // 2. Kết nối đến Spotify App Remote
//       final connected = await SpotifySdk.connectToSpotifyRemote(
//         clientId: _clientId,
//         redirectUrl: _redirectUrl,
//       );

//       if (connected) {
//         print('✅ Đã kết nối Spotify Remote');
//       }
//       return connected;
//     } catch (e) {
//       print('⛔ Lỗi kết nối Spotify Remote: $e');
//       return false;
//     }
//   }
// }
