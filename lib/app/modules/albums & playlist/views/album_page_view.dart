import 'package:dartz/dartz.dart' as album;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/styles/style.dart';
import '../../../routes/app_pages.dart';
import '../controllers/album_page_controller.dart';
import '../../../../models/album.dart';

class AlbumView extends GetView<AlbumController> {
  const AlbumView({Key? key}) : super(key: key);

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
          'Album',
          style: TextStyle(
            color: Theme.of(context).textTheme.titleLarge?.color ?? AppTheme.labelColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: _buildAlbumList(context),
        );
      }),
    );
  }

  Widget _buildAlbumList(BuildContext context) {
    final items = controller.playlists;
    final rowCount = (items.length / 2).ceil();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: rowCount,
      itemBuilder: (context, rowIndex) {
        final int firstIndex = rowIndex * 2;
        final int secondIndex = firstIndex + 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAlbumCard(context, items[firstIndex])),
            const SizedBox(width: 12),
            if (secondIndex < items.length)
              Expanded(child: _buildAlbumCard(context, items[secondIndex]))
            else
              const Spacer(),
          ],
        );
      },
    );
  }

  Widget _buildAlbumCard(BuildContext context, AlbumModel item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.albumnow , arguments: item.id);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
            ),
            Dimes.height8,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                item.artist,
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey),
              ),
            ),
            Dimes.height8
          ],
        ),
      ),
    );
  }
}