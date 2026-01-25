import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pin_option_sheet.dart';
import '../../data/models/photo_model.dart';

class PinCard extends StatelessWidget {
  final PhotoModel photo;
  final bool isPin;

  const PinCard({super.key, required this.photo, this.isPin = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/pin/${photo.id}', extra: photo);
      },
      child: Column(
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: photo.width / photo.height,
                  child: Container(
                    color: Colors.grey[200],
                    child: CachedNetworkImage(
                      imageUrl: photo.srcMedium,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),
                ),
              ),
              if (isPin)
                Positioned(
                  right: 8,
                  bottom: 8,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Transform.rotate(
                      angle: 45 * 3.14159 / 180,
                      child: Icon(Icons.push_pin_outlined, size: 18),
                    ),
                  ),
                ),
            ],
          ),

          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => PinOptionsSheet(photo: photo),
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 4.0, right: 4.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: const Icon(Icons.more_horiz, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
