import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xylophone_app/core/constants/app_colors.dart';
import 'package:xylophone_app/core/constants/app_string.dart';
import 'package:xylophone_app/presentation/screen/home/provider/media_provider.dart';
import 'package:xylophone_app/presentation/screen/home/widget/player_controller.dart';
import 'package:xylophone_app/presentation/screen/home/widget/song_list_iteam.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppString.appName,
          style: TextStyle(color: AppColors.textPrimary),
        ),
        backgroundColor: AppColors.surface,
      ),

      body: Column(
        children: [
          PlayerController(),
          Expanded(
            child: Consumer<MediaProvider>(
                builder: (context,provider,child){
                  final playlist=provider.playlist;
                  return ListView.builder(
                    itemCount: playlist.length,
                      itemBuilder: (context,index){
                    final song =playlist[index];

                    final isSelected =index ==provider.currentIndex;

                    return SongListIteam(
                      song: song,
                      index: index,
                      isPlaying: provider.isPlaying,
                      isSelected: isSelected,
                      onTap: (){
                        provider.playSongAtIndex(index);
                      }

                    );
                  }
                  );
                }
            ),
          )
        ],
      ),

    );
  }
}
