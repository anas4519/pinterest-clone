import 'package:flutter/material.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Your account",
          style: theme.textTheme.titleMedium?.copyWith(fontSize: 18),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(
                            'https://i.pravatar.cc/150?img=11',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Anas", style: theme.textTheme.titleMedium),
                            Text(
                              "@nadeemanas617",
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildProfileButton(context, "View profile"),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildProfileButton(context, "Share profile"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                "Settings",
                style: theme.textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),

              _buildListTile(context, "Account management"),
              _buildListTile(context, "Profile visibility"),
              _buildListTile(context, "Refine your recommendations"),
              _buildListTile(context, "Claimed external accounts"),
              _buildListTile(context, "Social permissions"),
              _buildListTile(context, "Notifications"),
              _buildListTile(context, "Privacy and data"),
              _buildListTile(context, "Reports and violations centre"),

              const SizedBox(height: 24),

              Text("Login", style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),

              _buildListTile(context, "Add account"),
              _buildListTile(context, "Security"),
              _buildListTile(context, "Log out", showArrow: false),
              _buildListTile(context, "Support", showArrow: false),
              _buildListTile(context, "Help Centre"),
              _buildListTile(context, "Terms of Service"),
              _buildListTile(context, "Privacy Policy"),
              _buildListTile(context, "About"),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, String text) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.scaffoldBackgroundColor,
        foregroundColor: theme.colorScheme.secondary,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _buildListTile(
    BuildContext context,
    String title, {
    bool showArrow = true,
  }) {
    final theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      splashColor: Colors.transparent,
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: showArrow
          ? Icon(Icons.chevron_right, color: theme.iconTheme.color)
          : null,
      onTap: () {},
    );
  }
}
