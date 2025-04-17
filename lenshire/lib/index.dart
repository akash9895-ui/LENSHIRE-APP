import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lenshire/custompackage.dart';
import 'package:lenshire/packagebooking.dart';
import 'package:lenshire/photolist.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/mybookings.dart';
import 'package:lenshire/myprofile.dart';

// App Colors (unchanged)
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

// App Text Styles (unchanged)
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
  final String specialty;
  final double rating;
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

  factory Photographer.fromMap(Map<String, dynamic> data) {
    return Photographer(
      id: data['photo_id']?.toString() ?? '',
      name: data['photographer_name'] as String? ?? 'Unknown',
      specialty: data['photographer_specialty'] as String? ?? 'Photography',
      rating: (data['photographer_rating'] as num?)?.toDouble() ?? 4.5,
      imageUrl: data['photpgrapher_photo'] as String?,
      bio: data['photographer_bio'] as String?,
      email: data['photographer_email'] as String? ?? '',
      contact: data['photographer_contact'] as String? ?? '',
      address: (data['photographer_address'] as String?)?.trim() ?? '',
      status: data['photographer_status'] as int? ?? 0,
      placeId: data['place_id'] as int? ?? 0,
    );
  }
}

class GalleryPhoto {
  final String id;
  final String photoUrl;
  final String? caption;
  final String? photographerId;
  final String photographerName;

  GalleryPhoto({
    required this.id,
    required this.photoUrl,
    this.caption,
    this.photographerId,
    required this.photographerName,
  });

  factory GalleryPhoto.fromMap(Map<String, dynamic> map, {required String photographerName}) {
    return GalleryPhoto(
      id: map['id'].toString(),
      photoUrl: map['gallery_photo'] ?? '',
      caption: map['gallery_caption'],
      photographerId: map['Photographer_id_id']?.toString(),
      photographerName: photographerName,
    );
  }
}

class Package {
  final int id;
  final String name;
  final String details;
  final String duration;
  final String? typeId;
  final String? photographerId;
  final double? amount;
  final String? imageUrl;

  Package({
    required this.id,
    required this.name,
    required this.details,
    required this.duration,
    this.typeId,
    this.photographerId,
    this.amount,
    this.imageUrl,
  });

  factory Package.fromMap(Map<String, dynamic> data) {
    return Package(
      id: data['id'] as int? ?? 0,
      name: data['package_name'] as String? ?? 'Unnamed Package',
      details: data['package_details'] as String? ?? 'No details available',
      duration: data['package_duration'] as String? ?? 'Unknown duration',
      typeId: data['type_id']?.toString(),
      photographerId: data['photographer_id']?.toString(),
      amount: data['package_amount'] is num
          ? (data['package_amount'] as num).toDouble()
          : null,
      imageUrl: data['image_url'] as String?,
    );
  }
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: photographer.imageUrl == null ||
                            photographer.imageUrl!.isEmpty
                        ? AppColors.primaryGradient
                        : null,
                    image: photographer.imageUrl != null &&
                            photographer.imageUrl!.isNotEmpty
                        ? DecorationImage(
                            image: NetworkImage(photographer.imageUrl!),
                            fit: BoxFit.cover,
                            onError: (exception, stackTrace) =>
                                const Icon(Icons.error),
                          )
                        : null,
                  ),
                  child: photographer.imageUrl == null ||
                          photographer.imageUrl!.isEmpty
                      ? const Icon(Icons.camera_alt,
                          size: 32, color: Colors.white)
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      photographer.specialty,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              size: 16, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            photographer.rating.toStringAsFixed(1),
                            style: AppTextStyles.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded,
                          size: 14, color: AppColors.primary),
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

// Redesigned Package Card
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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primaryLight.withOpacity(0.3), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient:
                    package.imageUrl == null || package.imageUrl!.isEmpty
                        ? AppColors.primaryGradient
                        : null,
                image: package.imageUrl != null && package.imageUrl!.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(package.imageUrl!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) =>
                            const Icon(Icons.error),
                      )
                    : null,
              ),
              child: package.imageUrl == null || package.imageUrl!.isEmpty
                  ? const Icon(Icons.photo_camera, size: 40, color: Colors.white)
                  : null,
            ),
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
                    fontSize: 16,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  package.details,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        package.duration,
                        style: AppTextStyles.bodySmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        package.amount != null
                            ? '\$${package.amount!.toStringAsFixed(2)}'
                            : 'N/A',
                        style: AppTextStyles.price.copyWith(
                          fontSize: 16,
                          color: package.amount != null
                              ? AppColors.primary
                              : AppColors.textHint,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: package.amount != null ? onBookNow : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Book Now',
                        style: AppTextStyles.button.copyWith(fontSize: 12),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
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
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.sectionTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (actionText != null && onActionTap != null)
            TextButton(
              onPressed: onActionTap,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    actionText!,
                    style: AppTextStyles.actionLink,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_rounded,
                      size: 16, color: AppColors.primary),
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
  final List<GalleryPhoto> galleryPhotos;

  CustomSearchDelegate(this.photographers, this.galleryPhotos);

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

  String? statusFilter;
  int? placeIdFilter;

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
      final matchesStatus =
          statusFilter == null || p.status.toString() == statusFilter;
      final matchesPlace = placeIdFilter == null || p.placeId == placeIdFilter;
      return matchesQuery && matchesStatus && matchesPlace;
    }).toList();

    final photoResults = galleryPhotos
        .where((p) =>
            (p.photographerId?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (p.caption?.toLowerCase().contains(query.toLowerCase()) ?? false))
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
                    child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              p.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.person, color: Colors.white),
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    p.name,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    p.specialty,
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    '${p.rating}',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PhotographerDetailsPage(photographer: p),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
          ],
          if (photoResults.isNotEmpty) ...[
            Text('Gallery Photos', style: AppTextStyles.sectionTitle),
            const SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: photoResults.length,
              itemBuilder: (context, index) {
                final p = photoResults[index];
                return ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      p.photoUrl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.error, color: AppColors.error),
                    ),
                  ),
                  title: Text(
                    p.photographerName ?? 'Unknown',
                    style: AppTextStyles.bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    p.caption ?? 'No caption',
                    style: AppTextStyles.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              },
            ),
          ],
          if (filteredPhotographers.isEmpty && photoResults.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'No results found',
                  style: AppTextStyles.bodyLarge
                      .copyWith(color: AppColors.textSecondary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Status',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
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
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                value: selectedPlaceId,
                items: [
                  DropdownMenuItem(value: null, child: Text('All')),
                  DropdownMenuItem(value: 1, child: Text('Place 1')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedPlaceId = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel',
              style: AppTextStyles.actionLink,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text('Apply',
              style: AppTextStyles.button,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
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

class _IndexPageState extends State<IndexPage>
    with SingleTickerProviderStateMixin {
  List<Photographer> _featuredPhotographers = [];
  List<GalleryPhoto> _galleryPhotos = [];
  int _currentIndex = 0;
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  bool _isLoading = true;
  bool _isGalleryLoading = true;
  String? _error;
  String? _galleryError;

  @override
  void initState() {
    super.initState();
    _fetchPhotographers();
    _fetchGalleryPhotos();
    _scrollController.addListener(() {
      setState(() {
        _isScrolled = _scrollController.offset > 50;
      });
    });
  }

  Future<void> _fetchPhotographers() async {
    try {
      final response = await Supabase.instance.client
          .from('Guest_tbl_photographer')
          .select();
      if (response == null || response is! List<dynamic>) {
        throw Exception('Invalid response from Supabase');
      }
      setState(() {
        _featuredPhotographers = (response as List<dynamic>)
            .map<Photographer>(
                (data) => Photographer.fromMap(data as Map<String, dynamic>))
            .where((p) => p.id.isNotEmpty)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load photographers: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchGalleryPhotos() async {
    try {
      final galleryResponse = await Supabase.instance.client
          .from('Photographer_tbl_gallery')
          .select('id, gallery_photo, gallery_caption, Photographer_id_id, Guest_tbl_photographer!inner(photographer_name, photo_id)');
      print('Gallery response: $galleryResponse');

      if (galleryResponse == null || galleryResponse is! List<dynamic>) {
        throw Exception('Invalid gallery response from Supabase');
      }

      final photos = <GalleryPhoto>[];
      for (var data in (galleryResponse as List<dynamic>)) {
        final photographerName = data['Guest_tbl_photographer']['photographer_name'] as String? ?? 'Unknown';
        final photo = GalleryPhoto.fromMap(
          data as Map<String, dynamic>,
          photographerName: photographerName,
        );
        if (photo.photoUrl.isNotEmpty) {
          photos.add(photo);
        }
      }

      setState(() {
        _galleryPhotos = photos;
        _isGalleryLoading = false;
      });
    } catch (e) {
      setState(() {
        _galleryError = 'Failed to load gallery photos: $e';
        _isGalleryLoading = false;
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
    print('Building body: isLoading=$_isLoading, error=$_error');
    if (_isLoading) {
      return Center(child: CircularProgressIndicator(color: AppColors.primary));
    }
    if (_error != null) {
      return Center(
          child: Text(
        'Error: $_error',
        style: AppTextStyles.bodyMedium,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ));
    }

    print('Photographers count: ${_featuredPhotographers.length}');
    print('Gallery photos count: ${_galleryPhotos.length}');

    return RefreshIndicator(
      onRefresh: () async {
        await _fetchPhotographers();
        await _fetchGalleryPhotos();
      },
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
                        errorBuilder: (context, error, stackTrace) =>
                            Container(color: AppColors.divider),
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
                          style: AppTextStyles.heading2
                              .copyWith(color: Colors.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Professional services for every occasion',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: Colors.white70),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
                  hintText: 'Search photographers, photos...',
                  hintStyle: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textHint),
                  prefixIcon:
                      Icon(Icons.search_rounded, color: AppColors.textHint),
                  suffixIcon:
                      Icon(Icons.tune_rounded, color: AppColors.primary),
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
                  child: _featuredPhotographers.isEmpty
                      ? Center(
                          child: Text(
                            'No photographers available',
                            style: AppTextStyles.bodyMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          scrollDirection: Axis.horizontal,
                          itemCount: _featuredPhotographers.length,
                          itemBuilder: (context, index) {
                            return PhotographerCard(
                              photographer: _featuredPhotographers[index],
                              onTap: () => _navigateToPhotographerDetails(
                                  _featuredPhotographers[index]),
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
                  title: 'Photo Gallery',
                  actionText: 'View All',
                  onActionTap: _viewAllPhotos,
                ),
                _isGalleryLoading
                    ? Center(
                        child:
                            CircularProgressIndicator(color: AppColors.primary))
                    : _galleryError != null
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Text(
                              'Error: $_galleryError',
                              style: AppTextStyles.bodyMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : _galleryPhotos.isEmpty
                            ? Padding(
                                padding: const EdgeInsets.all(16),
                                child: Text(
                                  'No photos available',
                                  style: AppTextStyles.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.75,
                                ),
                                itemCount: _galleryPhotos.length,
                                itemBuilder: (context, index) {
                                  final photo = _galleryPhotos[index];
                                  print(
                                      'Photo: ID=${photo.photographerId}, Name=${photo.photographerName}');
                                  return GestureDetector(
                                    onTap: () {
                                      final photographer =
                                          _featuredPhotographers.firstWhere(
                                        (p) => p.id == photo.photographerId,
                                        orElse: () => Photographer(
                                          id: photo.photographerId ?? 'Unknown',
                                          name:
                                              photo.photographerName ?? 'Unknown',
                                          specialty: 'Photography',
                                          rating: 4.5,
                                          email: '',
                                          contact: '',
                                          address: '',
                                          status: 0,
                                          placeId: 0,
                                          imageUrl: null,
                                        ),
                                      );
                                      _navigateToPhotographerDetails(photographer);
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.shadow
                                                .withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      top: Radius.circular(12)),
                                              child: Image.network(
                                                photo.photoUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Container(
                                                  color: AppColors.divider,
                                                  child: const Icon(Icons.error,
                                                      color: AppColors.error),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.card,
                                              borderRadius:
                                                  const BorderRadius.vertical(
                                                      bottom:
                                                          Radius.circular(12)),
                                            ),
                                            child: Text(
                                              photo.photographerName ??
                                                  'Unknown',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                          (_) => const Icon(Icons.star_rounded,
                              color: Colors.amber, size: 20),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '"The photographer was amazing! They captured every special moment of our wedding day perfectly."',
                        style: AppTextStyles.bodyMedium
                            .copyWith(color: Colors.white),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.white.withOpacity(0.2),
                            child: const Icon(Icons.person,
                                color: Colors.white, size: 16),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Jennifer & Robert',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(color: Colors.white),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  'Wedding Photography',
                                  style: AppTextStyles.bodySmall
                                      .copyWith(color: Colors.white70),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MyBookingsPage()));
        break;
      case 3:
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => const MyProfilePage()));
        break;
    }
  }

  void _navigateToPhotographerDetails(Photographer photographer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PhotographerDetailsPage(photographer: photographer),
      ),
    );
  }

  void _showSearchDialog() {
    showSearch(
      context: context,
      delegate: CustomSearchDelegate(_featuredPhotographers, _galleryPhotos),
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
            Flexible(
              child: Text(
                'About LensHire',
                style: AppTextStyles.sectionTitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Version 1.0',
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  'The premier photography booking platform.',
                  style: AppTextStyles.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 16),
                Text(
                  '© 2023 LensHire Inc.',
                  style: AppTextStyles.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTextStyles.actionLink,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  void _viewAllPhotographers() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View all photographers coming soon')),
    );
  }

  void _viewAllPhotos() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('View all photos coming soon')),
    );
  }
}