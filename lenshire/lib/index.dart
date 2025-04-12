import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenshire/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/mybookings.dart';
import 'package:lenshire/myprofile.dart';


// App Colors
class AppColors {
  static const Color primary = Color(0xFF2A9D8F);
  static const Color primaryDark = Color(0xFF1E7168);
  static const Color primaryLight = Color(0xFF4DB6A9);
  static const Color accent = Color(0xFFE9C46A);
  static const Color accentDark = Color(0xFFDDB957);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Colors.white;
  static const Color card = Colors.white;
  static const Color textPrimary = Color(0xFF2D3142);
  static const Color textSecondary = Color(0xFF4F5D75);
  static const Color textHint = Color(0xFF9098B1);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE76F51);
  static const Color warning = Color(0xFFF4A261);
  static const Color info = Color(0xFF264653);
  static const Color divider = Color(0xFFEEEEEE);
  static const Color disabled = Color(0xFFBDBDBD);
  static const Color shadow = Color(0x1A000000);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// App Text Styles
class AppTextStyles {
  static const String fontFamily = 'Poppins';

  static final TextStyle heading1 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle heading2 = TextStyle(
    fontFamily: fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle sectionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static final TextStyle bodyLarge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodyMedium = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
  );

  static final TextStyle bodySmall = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  static final TextStyle price = TextStyle(
    fontFamily: fontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  static final TextStyle actionLink = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static final TextStyle caption = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textHint,
    letterSpacing: 0.2,
  );

  static final TextStyle button = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  static final TextStyle appBarTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Colors.white,
    letterSpacing: 0.5,
  );
}

// Models
class Photographer {
  final String id;
  final String name;
  final String specialty; // Assuming specialty is derived or added
  final double rating; // Placeholder, as rating isn't in CSV
  final String? imageUrl;
  final String? bio;
  final String email;
  final String contact;
  final String address;
  final int status;
  final int placeId;

  Photographer({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    this.imageUrl,
    this.bio,
    required this.email,
    required this.contact,
    required this.address,
    required this.status,
    required this.placeId,
  });

  factory Photographer.fromJson(Map<String, dynamic> json) {
    return Photographer(
      id: json['photo_id'],
      name: json['photographer_name'],
      specialty: 'Photography', // Placeholder; update if specialty is available
      rating: 4.5, // Placeholder; update with real data if available
      imageUrl: json['photpgrapher_photo'],
      bio: null, // Add bio if available
      email: json['photographer_email'],
      contact: json['photographer_contact'],
      address: json['photographer_address'].trim(),
      status: json['photographer_status'],
      placeId: json['place_id'],
    );
  }
}

class GalleryPhoto {
  final int id;
  final String photoUrl;
  final String? caption;
  final String photographerId;

  GalleryPhoto({
    required this.id,
    required this.photoUrl,
    this.caption,
    required this.photographerId,
  });

  factory GalleryPhoto.fromJson(Map<String, dynamic> json) {
    return GalleryPhoto(
      id: json['id'],
      photoUrl: json['gallery_photo'],
      caption: json['gallery_caption'],
      photographerId: json['Photographer_id_id'],
    );
  }
}

class Package {
  final int id;
  final String name;
  final String type;
  final double price;
  final String duration;
  final String? description;
  final String? imageUrl;

  Package({
    required this.id,
    required this.name,
    required this.type,
    required this.price,
    required this.duration,
    this.description,
    this.imageUrl,
  });
}

// AppBarLogo Widget
class AppBarLogo extends StatelessWidget {
  const AppBarLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.camera_alt,
            size: 20,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "LensHire",
          style: AppTextStyles.appBarTitle,
        ),
      ],
    );
  }
}

// Photographer Card
class PhotographerCard extends StatelessWidget {
  final Photographer photographer;
  final VoidCallback onTap;

  const PhotographerCard({
    super.key,
    required this.photographer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'photographer-${photographer.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: photographer.imageUrl == null
                        ? AppColors.primaryGradient
                        : null,
                    image: photographer.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(photographer.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: photographer.imageUrl == null
                      ? const Icon(Icons.camera_alt, size: 32, color: Colors.white)
                      : null,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photographer.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      photographer.specialty,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            photographer.rating.toString(),
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                      Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.primary),
                    ],
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

// Package Card
class PackageCard extends StatelessWidget {
  final Package package;
  final VoidCallback onBookNow;

  const PackageCard({
    super.key,
    required this.package,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: package.imageUrl == null
                        ? (package.type == 'Premium'
                            ? AppColors.accentGradient
                            : AppColors.primaryGradient)
                        : null,
                    image: package.imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(package.imageUrl!),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: package.imageUrl == null
                      ? const Icon(Icons.photo_camera, size: 32, color: Colors.white)
                      : null,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: package.type == 'Premium'
                        ? AppColors.accent
                        : (package.type == 'Standard' ? AppColors.primary : AppColors.info),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    package.type,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  package.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        package.duration,
                        style: AppTextStyles.bodySmall,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '\$${package.price.toStringAsFixed(2)}',
                      style: AppTextStyles.price,
                    ),
                    ElevatedButton(
                      onPressed: onBookNow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Book',
                        style: AppTextStyles.button.copyWith(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Section Header
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.sectionTitle,
          ),
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Row(
                children: [
                  Text(actionText!, style: AppTextStyles.actionLink),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Custom Search Delegate with Filters
class CustomSearchDelegate extends SearchDelegate<String> {
  final List<Photographer> photographers;
  final List<Package> packages;
  String? statusFilter;
  int? placeIdFilter;

  CustomSearchDelegate(this.photographers, this.packages);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: AppTextStyles.appBarTitle,
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
        border: InputBorder.none,
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.filter_list),
        onPressed: () async {
          final filters = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (context) => FilterDialog(),
          );
          if (filters != null) {
            statusFilter = filters['status'];
            placeIdFilter = filters['placeId'];
            showResults(context);
          }
        },
      ),
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          statusFilter = null;
          placeIdFilter = null;
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    var filteredPhotographers = photographers.where((p) {
      final matchesQuery = p.name.toLowerCase().contains(query.toLowerCase()) ||
          p.specialty.toLowerCase().contains(query.toLowerCase());
      final matchesStatus = statusFilter == null || p.status.toString() == statusFilter;
      final matchesPlace = placeIdFilter == null || p.placeId == placeIdFilter;
      return matchesQuery && matchesStatus && matchesPlace;
    }).toList();

    final packageResults = packages
        .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (filteredPhotographers.isNotEmpty) ...[
            Text('Photographers', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredPhotographers.length,
              itemBuilder: (context, index) {
                final p = filteredPhotographers[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.primaryLight,
                    child: p.imageUrl != null
                        ? ClipOval(child: Image.network(p.imageUrl!, fit: BoxFit.cover))
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(p.name, style: AppTextStyles.bodyMedium),
                  subtitle: Text(p.specialty, style: AppTextStyles.bodySmall),
                  trailing: Text('${p.rating}', style: AppTextStyles.bodySmall),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PhotographerDetailsPage(photographer: p),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          if (packageResults.isNotEmpty) ...[
            Text('Packages', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: packageResults.length,
              itemBuilder: (context, index) {
                final p = packageResults[index];
                return ListTile(
                  leading: Icon(Icons.photo_camera, color: AppColors.primary),
                  title: Text(p.name, style: AppTextStyles.bodyMedium),
                  subtitle: Text('${p.type} - ${p.duration}', style: AppTextStyles.bodySmall),
                  trailing: Text('\$${p.price}', style: AppTextStyles.price),
                );
              },
            ),
          ],
          if (filteredPhotographers.isEmpty && packageResults.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No results found',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Filter Dialog
class FilterDialog extends StatefulWidget {
  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  String? selectedStatus;
  int? selectedPlaceId;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text('Filters', style: AppTextStyles.sectionTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            value: selectedStatus,
            items: [
              DropdownMenuItem(value: null, child: Text('All')),
              DropdownMenuItem(value: '1', child: Text('Active')),
              DropdownMenuItem(value: '0', child: Text('Inactive')),
            ],
            onChanged: (value) {
              setState(() {
                selectedStatus = value;
              });
            },
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              labelText: 'Place',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            value: selectedPlaceId,
            items: [
              DropdownMenuItem(value: null, child: Text('All')),
              DropdownMenuItem(value: 1, child: Text('Place 1')), // Adjust based on actual places
            ],
            onChanged: (value) {
              setState(() {
                selectedPlaceId = value;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel', style: AppTextStyles.actionLink),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'status': selectedStatus,
              'placeId': selectedPlaceId,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Apply', style: AppTextStyles.button),
        ),
      ],
    );
  }
}

// Main Page
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> with SingleTickerProviderStateMixin {
  List<Photographer> _featuredPhotographers = [];
  final List<Package> _photographyPackages = [
    Package(id: 1, name: 'Basic Portrait', type: 'Basic', price: 99.99, duration: '1 hour'),
    Package(id: 2, name: 'Wedding Standard', type: 'Standard', price: 299.99, duration: '4 hours'),
    Package(id: 3, name: 'Premium Event', type: 'Premium', price: 499.99, duration: '6 hours'),
    Package(id: 4, name: 'Family Photoshoot', type: 'Standard', price: 199.99, duration: '2 hours'),
  ];

  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchPhotographers();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });
  }

  Future<void> _fetchPhotographers() async {
    try {
      final response = await supabase.from('Guest_tbl_photographer').select();
      setState(() {
        _featuredPhotographers = response.map<Photographer>((json) => Photographer.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: _isScrolled ? 2 : 0,
      backgroundColor: _isScrolled ? AppColors.primaryDark : Colors.transparent,
      title: const AppBarLogo(),
      actions: [
        IconButton(
          icon: const Icon(Icons.search_rounded),
          onPressed: _showSearchDialog,
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none_rounded),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.info_outline),
          onPressed: () => _showAppInfo(context),
        ),
      ],
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(child: Text('Error: $_error', style: AppTextStyles.bodyMedium));
    }

    return RefreshIndicator(
      onRefresh: _fetchPhotographers,
      color: AppColors.primary,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.1,
                      child: Image.network(
                        'https://images.unsplash.com/photo-1542038784456-1ea8e935640e',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 80, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your Perfect\nPhotographer',
                          style: AppTextStyles.heading2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Professional services for every occasion',
                          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                readOnly: true,
                onTap: _showSearchDialog,
                decoration: InputDecoration(
                  hintText: 'Search photographers, packages...',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                  prefixIcon: Icon(Icons.search_rounded, color: AppColors.textHint),
                  suffixIcon: Icon(Icons.tune_rounded, color: AppColors.primary),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: 'Featured Photographers',
                  actionText: 'View All',
                  onActionTap: _viewAllPhotographers,
                ),
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _featuredPhotographers.length,
                    itemBuilder: (context, index) {
                      return PhotographerCard(
                        photographer: _featuredPhotographers[index],
                        onTap: () =>
                            _navigateToPhotographerDetails(_featuredPhotographers[index]),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: 'Photography Packages',
                  actionText: 'View All',
                  onActionTap: _viewAllPackages,
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = (constraints.maxWidth / 200).floor().clamp(1, 2);
                    return GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: _photographyPackages.length,
                      itemBuilder: (context, index) {
                        return PackageCard(
                          package: _photographyPackages[index],
                          onBookNow: () => _bookPackage(_photographyPackages[index]),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              children: [
                SectionHeader(
                  title: 'What Our Clients Say',
                  actionText: 'All Reviews',
                  onActionTap: () {},
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (_) => const Icon(Icons.star_rounded, color: Colors.amber, size: 20),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"The photographer was amazing! They captured every special moment of our wedding day perfectly."',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(Icons.person, color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Jennifer & Robert',
                                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
                              ),
                              Text(
                                'Wedding Photography',
                                style: AppTextStyles.bodySmall.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home'),
              _buildNavItem(1, Icons.explore_rounded, 'Explore'),
              _buildNavItem(2, Icons.calendar_today_rounded, 'Bookings'),
              _buildNavItem(3, Icons.person_rounded, 'Profile'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return InkWell(
      onTap: () => _onBottomNavTap(index),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        _viewAllPhotographers();
        break;
      case 2:
        Navigator.push(context, MaterialPageRoute(builder: (_) =>  MyBookingsPage()));
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (_) => const MyProfilePage()));
        break;
    }
  }

  void _navigateToPhotographerDetails(Photographer photographer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotographerDetailsPage(photographer: photographer),
      ),
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(_featuredPhotographers, _photographyPackages),
    );
  }

  void _showAppInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(Icons.camera_alt, color: AppColors.primary),
            const SizedBox(width: 8),
            Text('About LensHire', style: AppTextStyles.sectionTitle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text(
              'The premier photography booking platform.',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 16),
            Text(
              '© 2023 LensHire Inc.',
              style: AppTextStyles.caption,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: AppTextStyles.actionLink),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshContent() async {
    await _fetchPhotographers();
  }

  void _viewAllPhotographers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View all photographers coming soon')),
    );
  }

  void _viewAllPackages() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View all packages coming soon')),
    );
  }

  void _bookPackage(Package package) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Book ${package.name}', style: AppTextStyles.sectionTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$${package.price.toStringAsFixed(2)}', style: AppTextStyles.price),
            const SizedBox(height: 8),
            Text('Type: ${package.type}', style: AppTextStyles.bodyMedium),
            const SizedBox(height: 8),
            Text('Duration: ${package.duration}', style: AppTextStyles.bodySmall),
            const SizedBox(height: 16),
            Text('Confirm booking?', style: AppTextStyles.bodyMedium),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: AppTextStyles.actionLink),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${package.name} booked!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text('Confirm', style: AppTextStyles.button),
          ),
        ],
      ),
    );
  }
}

// Photographer Details Page
class PhotographerDetailsPage extends StatefulWidget {
  final Photographer photographer;

  const PhotographerDetailsPage({super.key, required this.photographer});

  @override
  _PhotographerDetailsPageState createState() => _PhotographerDetailsPageState();
}

class _PhotographerDetailsPageState extends State<PhotographerDetailsPage> {
  List<GalleryPhoto> _galleryPhotos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchGallery();
  }

  Future<void> _fetchGallery() async {
    try {
      final response = await supabase
          .from('Photographer_tbl_gallery')
          .select()
          .eq('Photographer_id_id', widget.photographer.id);
      setState(() {
        _galleryPhotos = response.map<GalleryPhoto>((json) => GalleryPhoto.fromJson(json)).toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: 'photographer-${widget.photographer.id}',
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: widget.photographer.imageUrl == null
                            ? AppColors.primaryGradient
                            : null,
                        image: widget.photographer.imageUrl != null
                            ? DecorationImage(
                                image: NetworkImage(widget.photographer.imageUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: widget.photographer.imageUrl == null
                          ? const Icon(Icons.camera_alt, size: 64, color: Colors.white)
                          : null,
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.photographer.name,
                          style: AppTextStyles.heading2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                widget.photographer.specialty,
                                style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                              ),
                              backgroundColor: AppColors.primaryLight,
                            ),
                            const SizedBox(width: 8),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, size: 16, color: Colors.amber),
                                const SizedBox(width: 4),
                                Text(
                                  '${widget.photographer.rating}',
                                  style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added ${widget.photographer.name} to favorites')),
                  );
                },
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('About', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  Text(
                    widget.photographer.bio ??
                        'Professional photographer specializing in ${widget.photographer.specialty.toLowerCase()}. Contact: ${widget.photographer.email}, ${widget.photographer.contact}. Address: ${widget.photographer.address}.',
                    style: AppTextStyles.bodyMedium,
                  ),
                  const SizedBox(height: 24),
                  Text('Portfolio', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  _isLoading
                      ? Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : _error != null
                          ? Text('Error: $_error', style: AppTextStyles.bodyMedium)
                          : _galleryPhotos.isEmpty
                              ? Text('No photos available', style: AppTextStyles.bodyMedium)
                              : GridView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 8,
                                    mainAxisSpacing: 8,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: _galleryPhotos.length,
                                  itemBuilder: (context, index) {
                                    final photo = _galleryPhotos[index];
                                    return GestureDetector(
                                      onTap: () {
                                        // Optional: Show full-screen image
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          image: DecorationImage(
                                            image: NetworkImage(photo.photoUrl),
                                            fit: BoxFit.cover,
                                            onError: (exception, stackTrace) => const Icon(Icons.error),
                                          ),
                                        ),
                                        child: photo.caption != null
                                            ? Align(
                                                alignment: Alignment.bottomCenter,
                                                child: Container(
                                                  color: Colors.black54,
                                                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                                  child: Text(
                                                    photo.caption!,
                                                    style: AppTextStyles.bodySmall.copyWith(color: Colors.white),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                  const SizedBox(height: 24),
                  Text('Available Packages', style: AppTextStyles.sectionTitle),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 3,
                    itemBuilder: (context, index) {
                      final packageTypes = ['Basic', 'Standard', 'Premium'];
                      final packagePrices = [99.99, 199.99, 299.99];
                      final packageDurations = ['1 hour', '2 hours', '4 hours'];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          leading: Icon(
                            Icons.photo_camera,
                            color: packageTypes[index] == 'Premium'
                                ? AppColors.accent
                                : AppColors.primary,
                          ),
                          title: Text(
                            '${packageTypes[index]} Package',
                            style: AppTextStyles.bodyMedium,
                          ),
                          subtitle: Text(
                            '${packageDurations[index]}',
                            style: AppTextStyles.bodySmall,
                          ),
                          trailing: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '\$${packagePrices[index]}',
                                style: AppTextStyles.price,
                              ),
                              const SizedBox(height: 4),
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${packageTypes[index]} booked!')),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  'Book',
                                  style: AppTextStyles.button.copyWith(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar:   ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Booking with ${widget.photographer.name} initiated')),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          child: Text('Book This Photographer', style: AppTextStyles.button),
        ),
      );
    
  }
}