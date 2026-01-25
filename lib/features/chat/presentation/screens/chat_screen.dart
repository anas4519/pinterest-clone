import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const _InboxHeader(),
            const _MessagesSection(),
            const _UpdatesSection(),
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}

class _InboxHeader extends StatelessWidget {
  const _InboxHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Inbox',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.edit_outlined,
                color: theme.colorScheme.secondary,
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessagesSection extends StatelessWidget {
  const _MessagesSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Messages',
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Row(
                    children: [
                      Text(
                        'See all',
                        style: TextStyle(
                          color: theme.colorScheme.secondary,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: theme.colorScheme.secondary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const _MessageTile(
            isPinterest: false,
            name: 'Jonathan Carter',
            lastMessage: 'check this out',
            time: '2y',
          ),

          const _MessageTile(
            isPinterest: true,
            name: 'Pinterest India',
            lastMessage: 'Sent a Pin',
            time: '5y',
          ),

          const _FindPeopleTile(),
        ],
      ),
    );
  }
}

class _MessageTile extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final bool isPinterest;

  const _MessageTile({
    required this.name,
    required this.lastMessage,
    required this.time,
    this.isPinterest = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _buildAvatar(),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      color: theme.colorScheme.secondary.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Text(
              time,
              style: TextStyle(
                color: theme.colorScheme.secondary.withOpacity(0.6),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: isPinterest ? Color(0xFFE60023) : Colors.purple,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          isPinterest ? 'J' : 'P',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
          ),
        ),
      ),
    );
  }
}

class _FindPeopleTile extends StatelessWidget {
  const _FindPeopleTile();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.person_add_outlined,
                color: theme.colorScheme.secondary,
                size: 28,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Find people to message',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Connect to start chatting',
                    style: TextStyle(
                      color: theme.colorScheme.secondary.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UpdatesSection extends StatelessWidget {
  const _UpdatesSection();

  static const List<_UpdateItem> _updates = [
    _UpdateItem(topic: 'Kodama Minimalist Silhouette Art', time: '11h'),
    _UpdateItem(topic: 'Billie Jean', time: '3d'),
    _UpdateItem(topic: 'Vintage F1', time: '5d'),
    _UpdateItem(
      topic: 'Vintage Camera Patent Print Black And White',
      time: '2w',
    ),
    _UpdateItem(topic: 'Ghibli Landscape 8k', time: '12/25'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
            child: Text(
              'Updates',
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          ...List.generate(_updates.length, (index) {
            return _UpdateTile(item: _updates[index]);
          }),
        ],
      ),
    );
  }
}

class _UpdateItem {
  final String topic;
  final String time;

  const _UpdateItem({required this.topic, required this.time});
}

class _UpdateTile extends StatelessWidget {
  final _UpdateItem item;

  const _UpdateTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.search,
                color: theme.scaffoldBackgroundColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: theme.colorScheme.secondary,
                        fontSize: 15,
                        height: 1.3,
                      ),
                      children: [
                        const TextSpan(
                          text: 'Still searching? Explore ideas related to ',
                        ),
                        TextSpan(
                          text: item.topic,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    item.time,
                    style: TextStyle(
                      color: theme.colorScheme.secondary.withOpacity(0.6),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            GestureDetector(
              onTap: () => _showOptionsMenu(context),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.more_horiz,
                  color: theme.colorScheme.secondary.withOpacity(0.6),
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _UpdateOptionsSheet(topic: item.topic),
    );
  }
}

class _UpdateOptionsSheet extends StatelessWidget {
  final String topic;

  const _UpdateOptionsSheet({required this.topic});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 10,
              ),
              child: Text('Options', style: theme.textTheme.titleMedium),
            ),
            _OptionItem(
              icon: Icons.visibility_off_outlined,
              label: 'Delete update',
              onTap: () => Navigator.pop(context),
            ),
            _OptionItem(
              icon: Icons.notifications_off_outlined,
              label: 'View notification settings',
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  margin: EdgeInsets.all(16),
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text("Close", style: theme.textTheme.titleMedium),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                color: theme.colorScheme.secondary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
