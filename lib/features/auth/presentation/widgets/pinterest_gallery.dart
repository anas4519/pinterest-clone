import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/constants/app_images.dart';

class PinterestGallery extends StatelessWidget {
  const PinterestGallery({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final centerWidth = screenWidth * 0.44;
    final sideColumnWidth = screenWidth * 0.4;
    final peekImageWidth = screenWidth * 0.22;
    final gap = 10.0;

    final sideOffset = screenWidth * 0.05 * -1;
    final peekOffset = peekImageWidth * 0.55;

    return SafeArea(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: sideOffset - 10,
            top: -80,
            width: sideColumnWidth,
            child: Column(
              children: [
                ZoomingGalleryItem(
                  imageUrl: AppImages.loginBackgroundImages[0],
                  borderRadius: 16,
                  height: screenHeight * 0.18,
                ),
                SizedBox(height: 100),
                ZoomingGalleryItem(
                  imageUrl: AppImages.loginBackgroundImages[1],
                  borderRadius: 16,
                  height: screenHeight * 0.2,
                ),
              ],
            ),
          ),

          Positioned(
            right: sideColumnWidth - sideOffset + gap - peekOffset - 80,
            top: screenHeight * 0.12,
            width: peekImageWidth,
            child: ZoomingGalleryItem(
              imageUrl: AppImages.loginBackgroundImages[6],
              borderRadius: 14,
              height: screenHeight * 0.1,
            ),
          ),

          // RIGHT COLUMN
          Positioned(
            right: -70,
            top: -90,
            width: sideColumnWidth,
            child: Column(
              children: [
                ZoomingGalleryItem(
                  imageUrl: AppImages.loginBackgroundImages[3],
                  borderRadius: 16,
                  height: screenHeight * 0.12,
                ),
                SizedBox(height: gap * 25),
                ZoomingGalleryItem(
                  imageUrl: AppImages.loginBackgroundImages[4],
                  borderRadius: 16,
                  height: screenHeight * 0.1,
                ),
              ],
            ),
          ),
          Positioned(
            left: (screenWidth - centerWidth) / 2,
            top: screenHeight * 0.06,
            width: centerWidth,
            child: ZoomingGalleryItem(
              imageUrl: AppImages.loginBackgroundImages[2],
              borderRadius: 20,
              height: screenHeight * 0.275,
            ),
          ),
        ],
      ),
    );
  }
}

class ZoomingGalleryItem extends StatefulWidget {
  final String imageUrl;
  final double borderRadius;
  final double height;

  const ZoomingGalleryItem({
    super.key,
    required this.imageUrl,
    this.borderRadius = 16,
    required this.height,
  });

  @override
  State<ZoomingGalleryItem> createState() => _ZoomingGalleryItemState();
}

class _ZoomingGalleryItemState extends State<ZoomingGalleryItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    final randomDuration = 1250;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: randomDuration),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.075).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );

    final randomDelay = _random.nextInt(1500);

    Future.delayed(Duration(milliseconds: randomDelay), () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          alignment: Alignment.center,
          child: child,
        );
      },
      child: Container(
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          child: CachedNetworkImage(
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: widget.height,
            placeholder: (context, url) =>
                Container(color: const Color(0xFF2A2A2A)),
            errorWidget: (context, url, error) => Container(
              color: const Color(0xFF2A2A2A),
              child: const Icon(Icons.error, color: Colors.grey),
            ),
          ),
        ),
      ),
    );
  }
}
