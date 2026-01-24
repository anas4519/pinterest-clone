import 'package:flutter/material.dart';

class CreateBottomSheet extends StatelessWidget {
  const CreateBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => const CreateBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Start creating now',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(width: 44),
                ],
              ),

              const SizedBox(height: 16),

              // Create options
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _CreateOption(
                    icon: Icons.push_pin_outlined,
                    label: 'Pin',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle Pin creation
                      _handleCreatePin(context);
                    },
                  ),
                  const SizedBox(width: 24),
                  _CreateOption(
                    icon: Icons.auto_awesome_mosaic_outlined,
                    label: 'Collage',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle Collage creation
                      _handleCreateCollage(context);
                    },
                  ),
                  const SizedBox(width: 24),
                  _CreateOption(
                    icon: Icons.dashboard_outlined,
                    label: 'Board',
                    onTap: () {
                      Navigator.pop(context);
                      // Handle Board creation
                      _handleCreateBoard(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleCreatePin(BuildContext context) {
    // TODO: Navigate to create pin screen or show pin creation UI
    debugPrint('Create Pin tapped');
  }

  void _handleCreateCollage(BuildContext context) {
    // TODO: Navigate to create collage screen
    debugPrint('Create Collage tapped');
  }

  void _handleCreateBoard(BuildContext context) {
    // TODO: Navigate to create board screen
    debugPrint('Create Board tapped');
  }
}

class _CreateOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _CreateOption({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.grey[800],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
