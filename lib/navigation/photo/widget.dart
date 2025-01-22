import 'package:flutter/material.dart';
import 'package:kaist_map/api/building/data.dart';
import 'package:kaist_map/constant/colors.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class BuildingPhotoView extends StatelessWidget {
  final BuildingData buildingData;

  const BuildingPhotoView(this.buildingData, {super.key});

  List<String> get imageUrls => buildingData.imageUrls;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Container(
        color: Colors.black.withAlpha(150),
        child: PhotoViewGallery.builder(
          itemCount: imageUrls.length,
          builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider: NetworkImage(imageUrls[index].trim()),
              initialScale: PhotoViewComputedScale.contained * 0.8,
              heroAttributes: PhotoViewHeroAttributes(tag: buildingData.name),
            ),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(color: KMapColors.darkBlue),
          ),
          backgroundDecoration: const BoxDecoration(color: Colors.transparent),
          pageController: PageController(initialPage: 0),
        ),
      ),
    );
  }
}