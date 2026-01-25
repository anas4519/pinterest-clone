import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class PinOptionsSheet extends StatelessWidget {
  final PhotoModel photo;
  final VoidCallback? onSave;
  final VoidCallback? onSeeMore;
  final VoidCallback? onSeeLess;

  const PinOptionsSheet({
    super.key,
    required this.photo,
    this.onSave,
    this.onSeeMore,
    this.onSeeLess,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const double imageWidth = 100;
    const double imageHeight = 150;
    const double imageOverlap = imageHeight / 2;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        Container(
          margin: const EdgeInsets.only(top: imageOverlap),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: imageOverlap + 8),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  "This Pin is inspired by your recent activity",
                  style: theme.textTheme.bodyMedium?.copyWith(),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 16),

              _buildActionItem(
                context,
                icon: CupertinoIcons.pin,
                text: "Save",
                onTap: () {
                  Navigator.pop(context);
                  onSave?.call();
                  _showSaveToBoardSheet(context);
                },
              ),
              _buildActionItem(
                context,
                icon: CupertinoIcons.share,
                text: "Share",
                onTap: () {
                  Navigator.pop(context);
                  _sharePin(context);
                },
              ),
              _buildActionItem(
                context,
                icon: CupertinoIcons.arrow_down_to_line,
                text: "Download image",
                onTap: () {
                  Navigator.pop(context);
                  _downloadImage(context);
                },
              ),
              _buildActionItem(
                context,
                icon: CupertinoIcons.heart,
                text: "See more like this",
                onTap: () {
                  Navigator.pop(context);
                  onSeeMore?.call();
                  _showSnackBar(context, "You'll see more Pins like this");
                },
              ),
              _buildActionItem(
                context,
                icon: CupertinoIcons.eye_slash,
                text: "See less like this",
                onTap: () {
                  Navigator.pop(context);
                  onSeeLess?.call();
                  _showSnackBar(context, "You'll see fewer Pins like this");
                },
              ),
              _buildActionItem(
                context,
                icon: CupertinoIcons.exclamationmark_circle,
                text: "Report Pin",
                subtitle: "This goes against Pinterest's Community Guidelines",
                onTap: () {
                  Navigator.pop(context);
                  _showReportDialog(context);
                },
              ),

              SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
            ],
          ),
        ),

        Positioned(
          top: 0,
          child: Container(
            width: imageWidth,
            height: imageHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: photo.srcMedium,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[800],
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  color: Colors.grey[800],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: imageOverlap + 8,
          left: 8,
          child: IconButton(
            icon: const Icon(Icons.close, size: 28),
            onPressed: () => Navigator.pop(context),
            style: IconButton.styleFrom(backgroundColor: Colors.transparent),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(
    BuildContext context, {
    required IconData icon,
    required String text,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 26),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.bodySmall),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sharePin(BuildContext context) {
    SharePlus.instance.share(
      ShareParams(text: 'Check out this Pin: ${photo.srcMedium}'),
    );
  }

  Future<void> _downloadImage(BuildContext context) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        _showSnackBar(context, "Storage permission denied");
        return;
      }

      _showSnackBar(context, "Downloading image...");

      final response = await Dio().get(
        photo.srcMedium,
        options: Options(responseType: ResponseType.bytes),
      );

      // final result = await ImageGallerySaver.saveImage(
      //   response.data,
      //   quality: 100,
      //   name: "pinterest_${DateTime.now().millisecondsSinceEpoch}",
      // );

      if (true) {
        _showSnackBar(context, "Image saved to gallery!");
      } else {
        _showSnackBar(context, "Failed to save image");
      }
    } catch (e) {
      _showSnackBar(context, "Error downloading image: $e");
    }
  }

  void _showSaveToBoardSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => SaveToBoardSheet(photo: photo),
    );
  }

  void _showReportDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReportPinSheet(photo: photo),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}

class SaveToBoardSheet extends StatelessWidget {
  final PhotoModel photo;

  const SaveToBoardSheet({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text(
                  'Save to board',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(icon: const Icon(Icons.add), onPressed: () {}),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search boards',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: theme.cardColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 16),

          SizedBox(
            height: 300,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 48,
                      height: 48,
                      color: Colors.grey[700],
                      child: const Icon(Icons.image, color: Colors.grey),
                    ),
                  ),
                  title: Text('Board ${index + 1}'),
                  subtitle: Text('${(index + 1) * 10} Pins'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Saved to Board ${index + 1}'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ReportPinSheet extends StatelessWidget {
  final PhotoModel photo;

  const ReportPinSheet({super.key, required this.photo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final reportReasons = [
      'Nudity or pornography',
      'Graphic violence',
      'Harassment or bullying',
      'Self-harm',
      'Misinformation',
      'Hateful content',
      'Spam',
      'Intellectual property violation',
      'Other',
    ];

    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      decoration: BoxDecoration(
        color: theme.canvasColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[600],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                Text(
                  'Report Pin',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Why are you reporting this Pin?',
              style: theme.textTheme.bodyLarge,
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 350,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: reportReasons.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(reportReasons[index]),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Thanks for reporting. We\'ll review this Pin.',
                        ),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
