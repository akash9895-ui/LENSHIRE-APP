import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lenshire/index.dart';

class RatingPage extends StatefulWidget {
  final String bookingId;
  final String photographerName;
  final String serviceType;
  final String serviceDate;
  final String location;

  const RatingPage({
    Key? key,
    required this.bookingId,
    required this.photographerName,
    required this.serviceType,
    required this.serviceDate,
    required this.location,
  }) : super(key: key);

  @override
  _RatingPageState createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int _rating = 0;
  final TextEditingController _reviewController = TextEditingController();
  bool _isSubmitting = false;
  Map<String, dynamic>? _photographerData;
  bool _isLoading = true;
  String? _error;
  bool _hasRated = false;

  @override
  void initState() {
    super.initState();
    _fetchPhotographerData();
  }

  Future<void> _fetchPhotographerData() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Get photographer_id from booking
      final bookingResponse = await Supabase.instance.client
          .from('User_tbl_packagebooking')
          .select('package_id_id')
          .eq('id', widget.bookingId)
          .maybeSingle();

      if (bookingResponse == null) {
        throw Exception('Booking not found for ID ${widget.bookingId}');
      }

      final packageResponse = await Supabase.instance.client
          .from('Photographer_tbl_package')
          .select('photographer_id_id')
          .eq('id', bookingResponse['package_id_id'])
          .maybeSingle();

      if (packageResponse == null) {
        throw Exception('Package not found for ID ${bookingResponse['package_id_id']}');
      }

      final photographerId = packageResponse['photographer_id_id'];
      if (photographerId == null) {
        throw Exception('Photographer ID is missing');
      }

      // Check if user has already rated this photographer
      final ratingResponse = await Supabase.instance.client
          .from('User_tbl_rating')
          .select('id')
          .eq('user_id', userId)
          .eq('photographer_id', photographerId)
          .limit(1);

      if (ratingResponse.isNotEmpty) {
        setState(() {
          _hasRated = true;
          _isLoading = false;
        });
        return;
      }

      // Calculate total_ratings and average_rating from User_tbl_rating
      final ratingsResponse = await Supabase.instance.client
          .from('User_tbl_rating')
          .select('rating_data')
          .eq('photographer_id', photographerId);

      int totalRatings = 0;
      double averageRating = 0.0;
      if (ratingsResponse.isNotEmpty) {
        final validRatings =
            ratingsResponse.where((r) => r['rating_data'] > 0).toList();
        totalRatings = validRatings.length;
        if (totalRatings > 0) {
          final sum = validRatings.fold<int>(
              0, (sum, r) => sum + (r['rating_data'] as int));
          averageRating = sum / totalRatings;
        }
      }

      setState(() {
        _photographerData = {
          'name': widget.photographerName,
          'total_ratings': totalRatings,
          'average_rating': averageRating,
          'avatar_url': null, // Update with Supabase storage if available
        };
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching photographer data: $e');
      setState(() {
        _error = 'Failed to load photographer details: $e';
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            _error!,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
          ),
        ),
      );
    }

    if (_hasRated) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: AppColors.primary,
          title: const Text('Rating Submitted'),
          titleTextStyle: AppTextStyles.sectionTitle.copyWith(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.2),
              SizedBox(height: screenWidth * 0.05),
              Text(
                'You have already rated this photographer.',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: screenWidth * 0.045,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primary,
        title: const Text('Rate Your Experience'),
        titleTextStyle: AppTextStyles.sectionTitle.copyWith(color: Colors.white),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Photographer Profile Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColors.card,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: screenWidth * 0.08,
                      backgroundImage: _photographerData!['avatar_url'] != null
                          ? NetworkImage(_photographerData!['avatar_url'])
                          : const AssetImage('assets/avatars/placeholder.jpg')
                              as ImageProvider,
                    ),
                    SizedBox(width: screenWidth * 0.04),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _photographerData!['name'],
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.045,
                            ),
                          ),
                          SizedBox(height: screenWidth * 0.01),
                          Row(
                            children: [
                              Icon(Icons.star,
                                  color: Colors.amber, size: screenWidth * 0.04),
                              Text(
                                ' ${_photographerData!['average_rating'].toStringAsFixed(1)} (${_photographerData!['total_ratings']} reviews)',
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.06),

            // Booking Details Card
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: AppColors.card,
              child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Booking Details',
                      style: AppTextStyles.sectionTitle.copyWith(
                        fontSize: screenWidth * 0.045,
                      ),
                    ),
                    SizedBox(height: screenWidth * 0.03),
                    _buildDetailRow('Service Type', widget.serviceType, screenWidth),
                    _buildDetailRow('Date', widget.serviceDate, screenWidth),
                    _buildDetailRow('Location', widget.location, screenWidth),
                    _buildDetailRow('Booking ID', widget.bookingId, screenWidth),
                  ],
                ),
              ),
            ),

            SizedBox(height: screenWidth * 0.075),

            // Rating Section
            Text(
              'How would you rate this experience?',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: screenWidth * 0.045,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: screenWidth * 0.04),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: screenWidth * 0.1,
                    ),
                    onPressed: () {
                      setState(() {
                        _rating = index + 1;
                      });
                    },
                  );
                }),
              ),
            ),
            SizedBox(height: screenWidth * 0.02),
            Text(
              _getRatingText(_rating),
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textHint,
                fontStyle: FontStyle.italic,
                fontSize: screenWidth * 0.035,
              ),
            ),

            SizedBox(height: screenWidth * 0.075),

            // Review Section
            Text(
              'Share your experience (optional)',
              style: AppTextStyles.sectionTitle.copyWith(
                fontSize: screenWidth * 0.04,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: screenWidth * 0.025),
            TextField(
              controller: _reviewController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'What did you like about the service? How could we improve?',
                hintStyle:
                    AppTextStyles.bodyMedium.copyWith(color: AppColors.textHint),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.divider),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              style: AppTextStyles.bodyMedium.copyWith(fontSize: screenWidth * 0.035),
            ),

            SizedBox(height: screenWidth * 0.075),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _rating == 0 || _isSubmitting ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: screenWidth * 0.04),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: _isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        'SUBMIT REVIEW',
                        style: AppTextStyles.button.copyWith(
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.015),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
              fontSize: screenWidth * 0.035,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: screenWidth * 0.035,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return 'Tap stars to rate';
    }
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    try {
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not logged in');
      }

      // Get photographer_id
      final bookingResponse = await Supabase.instance.client
          .from('User_tbl_packagebooking')
          .select('package_id_id')
          .eq('id', widget.bookingId)
          .maybeSingle();

      if (bookingResponse == null) {
        throw Exception('Booking not found for ID ${widget.bookingId}');
      }

      final packageResponse = await Supabase.instance.client
          .from('Photographer_tbl_package')
          .select('photographer_id_id')
          .eq('id', bookingResponse['package_id_id'])
          .maybeSingle();

      if (packageResponse == null) {
        throw Exception('Package not found for ID ${bookingResponse['package_id_id']}');
      }

      final photographerId = packageResponse['photographer_id_id'];
      if (photographerId == null) {
        throw Exception('Photographer ID is missing');
      }

      // Insert rating into User_tbl_rating
      await Supabase.instance.client.from('User_tbl_rating').insert({
        'rating_data': _rating,
        'user_review': _reviewController.text.trim().isEmpty
            ? null
            : _reviewController.text.trim(),
        'photographer_id': photographerId,
        'user_id': userId,
        'datetime': DateTime.now().toUtc().toIso8601String(),
        // 'datetime' is set by Supabase default (now())
      });

      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Thank you for your $_rating-star review!'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 3),
          ),
        );

        // Return to previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error submitting rating: $e');
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            title: Text(
              'Error',
              style: AppTextStyles.sectionTitle.copyWith(color: AppColors.error),
            ),
            content: Text(
              'Failed to submit review: $e',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'OK',
                  style: AppTextStyles.actionLink,
                ),
              ),
            ],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }
}