import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageViewerPage extends StatefulWidget {
  final List<String> imageUrls; // 图片URL集合
  final int initialIndex; // 初始显示的图片索引
  final String heroTag; // 可选的hero动画标签

  const ImageViewerPage({
    super.key,
    required this.imageUrls,
    this.initialIndex = 0,
    this.heroTag = '',
  });

  @override
  State<ImageViewerPage> createState() => _ImageViewerPageState();
}

class _ImageViewerPageState extends State<ImageViewerPage> {
  late int currentIndex; // 当前显示的图片索引
  late PageController pageController; // 用于控制页面切换

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  // 处理页面切换回调
  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  // 构建单个图片项
  PhotoViewGalleryPageOptions _buildImageItem(BuildContext context, int index) {
    final imagePath = widget.imageUrls[index];
    
    // 判断是本地文件还是网络URL
    ImageProvider imageProvider;
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      // 网络图片
      imageProvider = CachedNetworkImageProvider(imagePath);
    } else {
      // 本地文件图片
      imageProvider = FileImage(File(imagePath));
    }

    return PhotoViewGalleryPageOptions(
      imageProvider: imageProvider,
      initialScale: PhotoViewComputedScale.contained,
      heroAttributes: widget.heroTag != ''
          ? PhotoViewHeroAttributes(tag: '${widget.heroTag}_$index')
          : null,
      minScale: PhotoViewComputedScale.contained * 0.8,
      maxScale: PhotoViewComputedScale.covered * 5.0,
      filterQuality: FilterQuality.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            '第${currentIndex + 1}页/共${widget.imageUrls.length}页',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: PhotoViewGallery.builder(
          itemCount: widget.imageUrls.length,
          builder: _buildImageItem,
          scrollPhysics: const BouncingScrollPhysics(),
          pageController: pageController,
          onPageChanged: onPageChanged,
          backgroundDecoration: const BoxDecoration(color: Colors.black),
          loadingBuilder: (context, event) => Center(
            child: SizedBox(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                value: event == null || event.expectedTotalBytes == null
                    ? 0
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
