import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    // Black with different opacities
    const Color blackPrimary = Color(0xDE000000); // 87% opacity black
    const Color blackSecondary = Color(0x8A000000); // 54% opacity black
    const Color blackTertiary = Color(0x61000000); // 38% opacity black

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App Bar with monochrome gradient and profile image
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF303030),
                      Color(0xFF212121),
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const CircleAvatar(
                          radius: 42,
                          backgroundImage: NetworkImage(
                            "https://example.com/profile.jpg",
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "John Doe",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "john.doe@example.com",
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Activity Stats Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: Colors.grey.shade200),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatColumn(
                        context,
                        Icons.favorite_rounded,
                        '${wishlistProvider.wishlist.length}',
                        'Wishlist',
                        blackPrimary,
                        blackSecondary,
                      ),
                      _buildStatColumn(
                        context,
                        Icons.bookmark_rounded,
                        '0',
                        'Bookmarks',
                        blackPrimary,
                        blackSecondary,
                      ),
                      _buildStatColumn(
                        context,
                        Icons.history_rounded,
                        '12',
                        'Recent',
                        blackPrimary,
                        blackSecondary,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // User Options Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackPrimary,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          context,
                          Icons.person_outline,
                          'Edit Profile',
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                        Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                        _buildListTile(
                          context,
                          Icons.favorite_outline,
                          'My Wishlist',
                          trailing: Text(
                            '${wishlistProvider.wishlist.length}',
                            style: const TextStyle(
                              color: blackPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                        Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                        _buildListTile(
                          context,
                          Icons.bookmark_outline,
                          'Saved Listings',
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: blackPrimary,
                      ),
                    ),
                  ),
                  Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      children: [
                        _buildListTile(
                          context,
                          Icons.notifications_outlined,
                          'Notifications',
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                        Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                        _buildListTile(
                          context,
                          Icons.lock_outline,
                          'Privacy',
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                        Divider(height: 1, indent: 56, color: Colors.grey.shade200),
                        _buildListTile(
                          context,
                          Icons.help_outline,
                          'Help & Support',
                          onTap: () {},
                          iconColor: blackPrimary,
                          textColor: blackPrimary,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  Card(
                    elevation: 0.5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: _buildListTile(
                      context,
                      Icons.logout,
                      'Log Out',
                      textColor: Colors.red.shade700,
                      iconColor: Colors.red.shade700,
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
      BuildContext context,
      IconData icon,
      String value,
      String label,
      Color primaryColor,
      Color secondaryColor,
      ) {
    return Column(
      children: [
        Icon(
          icon,
          color: primaryColor,
          size: 28,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: primaryColor,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: secondaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildListTile(
      BuildContext context,
      IconData icon,
      String title, {
        Widget? trailing,
        required VoidCallback onTap,
        Color? textColor,
        Color? iconColor,
      }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      leading: Icon(
        icon,
        color: iconColor,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      trailing: trailing ?? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
      onTap: onTap,
    );
  }
}