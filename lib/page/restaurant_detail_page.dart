import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourantapp/models/restaurant_detail_model.dart';
import 'package:restourantapp/provider/restaurant_provider.dart';

class RestaurantDetailPage extends StatelessWidget {
  final String id;

  const RestaurantDetailPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Restaurant Detail"),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
      ),
      body: FutureBuilder<RestaurantDetailResult>(
        future: Provider.of<RestaurantProvider>(context, listen: false)
            .fetchRestaurantDetail(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: colorScheme.primary));
          } else if (snapshot.hasError) {
            return Center(
                child: Text("Error: ${snapshot.error}",
                    style: theme.textTheme.bodyLarge));
          } else if (snapshot.hasData) {
            final restaurant = snapshot.data!.restaurant;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: restaurant.pictureId,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  restaurant.name,
                                  style: theme.textTheme.headlineMedium,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: colorScheme.secondary.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star,
                                        size: 16, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      restaurant.rating.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: colorScheme.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.location_on,
                                  size: 16, color: colorScheme.primary),
                              const SizedBox(width: 4),
                              Text(
                                "${restaurant.address}, ${restaurant.city}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.textTheme.bodyMedium?.color
                                    ?.withOpacity(0.7)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            restaurant.description,
                            textAlign: TextAlign.justify,
                            style: theme.textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Food Menu
                  Text(
                    "Food Menu:",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                    children: restaurant.menus.foods
                        .map((food) => Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.fastfood,
                                      size: 40, color: colorScheme.primary),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      food.name,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  // Drink Menu
                  Text(
                    "Drink Menu:",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9,
                    children: restaurant.menus.drinks
                        .map((drink) => Card(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.local_drink,
                                      size: 40, color: colorScheme.primary),
                                  const SizedBox(height: 8),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    child: Text(
                                      drink.name,
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.bodyMedium,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  // Customer Reviews
                  Text(
                    "Customer Reviews:",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...restaurant.customerReviews
                      .map((review) => Card(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    review.name,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    review.review,
                                    style: theme.textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    review.date,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                        ?.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                  const SizedBox(height: 24),
                  // Add Review Form
                  Text(
                    "Add Your Review:",
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _AddReviewForm(restaurantId: restaurant.id),
                  const SizedBox(height: 20),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                "No data available",
                style: theme.textTheme.bodyLarge,
              ),
            );
          }
        },
      ),
    );
  }
}

class _AddReviewForm extends StatefulWidget {
  final String restaurantId;

  const _AddReviewForm({required this.restaurantId});

  @override
  State<_AddReviewForm> createState() => _AddReviewFormState();
}

class _AddReviewFormState extends State<_AddReviewForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _reviewController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submitReview(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    final provider = Provider.of<RestaurantProvider>(context, listen: false);
    await provider.submitReview(
      id: widget.restaurantId,
      name: _nameController.text,
      review: _reviewController.text,
    );

    if (provider.reviewError == null) {
      _nameController.clear();
      _reviewController.clear();

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Success"),
          content: const Text("Review submitted successfully!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(provider.reviewError ?? 'Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RestaurantProvider>(context);
    final isSubmitting = provider.isSubmittingReview;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _reviewController,
            decoration: const InputDecoration(
              labelText: 'Review',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
            validator: (value) =>
                value == null || value.isEmpty ? 'Enter your review' : null,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: isSubmitting ? null : () => _submitReview(context),
            child: isSubmitting
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
