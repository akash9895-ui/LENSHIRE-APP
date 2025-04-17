import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/custompackage.dart';
import 'package:lenshire/packagebooking.dart';
import 'package:lenshire/index.dart'; // Import for AppColors, AppTextStyles, and models

class PhotographerDetailsPage extends StatefulWidget {
  final Photographer photographer;

  const PhotographerDetailsPage({super.key, required this.photographer});

  @override
  State<PhotographerDetailsPage> createState() => _PhotographerDetailsPageState();
}

class _PhotographerDetailsPageState extends State<PhotographerDetailsPage> {
  List<Package> _packages = [];
  List<GalleryPhoto> _galleryPhotos = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      // Fetch packages
      final packageResponse = await Supabase.instance.client
          .from('Photographer_tbl_package')
          .select()
          .eq('photographer_id_id', widget.photographer.id);

      // Fetch gallery photos
      final galleryResponse = await Supabase.instance.client
          .from('Photographer_tbl_gallery')
          .select()
          .eq('Photographer_id_id', widget.photographer.id);

      setState(() {
        _packages = (packageResponse as List<dynamic>)
            .map((data) => Package.fromMap(data as Map<String, dynamic>))
            .toList();
        _galleryPhotos = (galleryResponse as List<dynamic>)
            .map((data) => GalleryPhoto.fromMap(
                  data as Map<String, dynamic>,
                  photographerName: widget.photographer.name,
                ))
            .where((photo) => photo.photoUrl.isNotEmpty)
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load data: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const AppBarLogo(), // Reuse from IndexPage
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? Center(
                  child: Text(
                    'Error: $_error',
                    style: AppTextStyles.bodyMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildPhotographerCard(context, widget.photographer),
                      const SizedBox(height: 24),
                      SectionHeader(title: 'Packages', actionText: null),
                      _buildPackagesList(context, _packages),
                      const SizedBox(height: 24),
                      SectionHeader(title: 'Gallery', actionText: null),
                      _buildGalleryGrid(_galleryPhotos),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPhotographerCard(BuildContext context, Photographer photographer) {
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
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Hero(
              tag: 'photographer-${photographer.id}',
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppColors.primaryLight,
                child: photographer.imageUrl != null &&
                        photographer.imageUrl!.isNotEmpty
                    ? ClipOval(
                        child: Image.network(
                          photographer.imageUrl!,
                          fit: BoxFit.cover,
                          width: 100,
                          height: 100,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.person,
                                  size: 50, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              photographer.name,
              style: AppTextStyles.heading2,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              photographer.specialty,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star_rounded, size: 20, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  photographer.rating.toStringAsFixed(1),
                  style: AppTextStyles.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email, photographer.email.isNotEmpty ? photographer.email : 'Not provided'),
            _buildInfoRow(Icons.phone, photographer.contact.isNotEmpty ? photographer.contact : 'Not provided'),
            _buildInfoRow(Icons.location_on, photographer.address.isNotEmpty ? photographer.address : 'Not provided'),
            _buildInfoRow(Icons.place, 'New York, NY'), // Placeholder for place_id
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomPackageRequestPage(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: Text(
                'Request Custom Package',
                style: AppTextStyles.button,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagesList(BuildContext context, List<Package> packages) {
    if (packages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No packages available',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: packages.length,
      itemBuilder: (context, index) {
        return _buildPackageCard(context, packages[index]);
      },
    );
  }

  Widget _buildPackageCard(BuildContext context, Package package) {
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
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.photo_library,
                  size: 40, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              package.name,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              package.details,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              package.amount != null
                  ? '\$${package.amount!.toStringAsFixed(2)}'
                  : 'N/A',
              style: AppTextStyles.price,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                onPressed: package.amount != null
                    ? () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PackageBookingPage(
                                  package: package,
                                  photographer: widget.photographer,
                                ),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGalleryGrid(List<GalleryPhoto> gallery) {
    if (gallery.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          'No gallery items available',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: gallery.length,
      itemBuilder: (context, index) {
        return _buildGalleryItem(gallery[index]);
      },
    );
  }

  Widget _buildGalleryItem(GalleryPhoto item) {
    return Container(
      decoration: BoxDecoration(
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
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                item.photoUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: AppColors.divider,
                  child: const Icon(Icons.error, color: AppColors.error),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(12)),
            ),
            child: Text(
              item.caption ?? 'No caption',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}