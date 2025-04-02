import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soundflow/presentation/library_catalog/artists_view.dart';
import 'package:soundflow/presentation/songs/albums_view.dart';
import 'package:soundflow/presentation/songs/all_songs_view.dart';
import 'package:soundflow/presentation/songs/playlist_view.dart';

import '../../core/configs/theme/app_colors.dart';

class SongsView extends StatefulWidget {
  const SongsView({super.key});

  @override
  State<SongsView> createState() => _SongsViewState();
}

class _SongsViewState extends State<SongsView> with SingleTickerProviderStateMixin{

  TabController? controller;
  int selectTab = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = TabController(length: 4, vsync: this);
    controller?.addListener(() {
      selectTab = controller?.index ?? 0;
      setState(() {

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Songs",
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: kToolbarHeight,
            child: TabBar(
                controller: controller,
                indicatorColor: AppColors.primary,
                indicatorPadding: const EdgeInsets.symmetric(horizontal: 5),
                // isScrollable: true,
                labelStyle: TextStyle(
                  color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: TextStyle(
                  // color: AppColors.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
              Tab(text: "All Songs",),
              Tab(text: "PLaylist",),
              Tab(text: "Albums",),
              Tab(text: "Artists",),
            ]),
          ),
          Expanded(
              child: TabBarView(
                  controller: controller,
                children: [
                  const AllSongsView(),
                  const PlaylistView(),
                  const AlbumsView(),
                  const ArtistsView(),
                ],
              ))
        ],
      ),
    );
  }
}
