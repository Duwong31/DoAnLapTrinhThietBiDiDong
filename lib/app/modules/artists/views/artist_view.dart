import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../models/artist.dart';
import '../../../core/styles/style.dart';
import '../controllers/artist_controller.dart';

class ArtistView extends StatelessWidget {
  const ArtistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: .1,
        centerTitle: true,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'Artist',
          style: Theme.of(context).appBarTheme.titleTextStyle ??
              TextStyle(
                color: Theme.of(context).textTheme.titleLarge?.color,
                fontSize: 20,
              ),
        ),
      ),
      body: GetX<ArtistController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value),
                  ElevatedButton(
                    onPressed: controller.fetchArtists,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: controller.artistList.length,
            itemBuilder: (context, index) {
              final artist = controller.artistList[index];
              return ArtistCard(artist: artist);
            },
          );
        },
      ),
    );
  }
}

class ArtistCard extends StatelessWidget {
  final ArtistModel artist;

  const ArtistCard({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).cardColor,
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: () => _launchSpotify(artist.spotifyUrl),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  artist.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.music_note,
                    size: 80,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ),
              Dimes.width10,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      artist.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Dimes.height4,
                    Text(
                      'Followers: ${artist.followers.toStringAsFixed(0).replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                            (Match m) => '${m[1]},',
                      )}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      'Popularity: ${artist.popularity}/100',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (artist.genres.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Wrap(
                          spacing: 4,
                          children: artist.genres.take(3).map((genre) {
                            return Chip(
                              label: Text(genre),
                              visualDensity: VisualDensity.compact,
                              backgroundColor: Theme.of(context).chipTheme.backgroundColor,
                              labelStyle: Theme.of(context).chipTheme.labelStyle,
                            );
                          }).toList(),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.open_in_new, color: Theme.of(context).iconTheme.color),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchSpotify(String url) async {
    try {
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalApplication,
        );
      } else {
        Get.snackbar('Error', 'Could not launch Spotify');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to open URL: $e');
    }
  }
}
