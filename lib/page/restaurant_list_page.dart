import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restourantapp/provider/restaurant_provider.dart';
import 'restaurant_detail_page.dart';
import 'dart:async';

class RestaurantListPage extends StatefulWidget {
  const RestaurantListPage({super.key});

  @override
  State<RestaurantListPage> createState() => _RestaurantListPageState();
}

class _RestaurantListPageState extends State<RestaurantListPage> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final provider = Provider.of<RestaurantProvider>(context, listen: false);
      if (query.isNotEmpty) {
        provider.fetchSearchRestaurant(query);
      } else {
        provider.fetchAllRestaurants();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<RestaurantProvider>(
            builder: (context, state, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Restaurants",
                        style: theme.textTheme.headlineLarge?.copyWith(
                          color: colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.restaurant, color: colorScheme.primary, size: 28),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Recommendation restaurant for you!",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.textTheme.bodyLarge?.color?.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search restaurant...',
                      hintStyle: TextStyle(color: theme.hintColor),
                      prefixIcon: Icon(Icons.search, color: colorScheme.primary),
                      filled: true,
                      fillColor: theme.cardColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: colorScheme.primary, 
                          width: 2),
                      ),
                    ),
                    onChanged: _onSearchChanged,
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Builder(
                      builder: (_) {
                        if (state.state == ResultState.loading) {
                          return Center(
                            child: CircularProgressIndicator(
                              color: colorScheme.primary),
                          );
                        } else if (state.state == ResultState.hasData) {
                          return ListView.separated(
                            itemCount: state.result.restaurants.length,
                            separatorBuilder: (context, index) => 
                              const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final restaurant = state.result.restaurants[index];
                              return InkWell(
                                borderRadius: BorderRadius.circular(16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          RestaurantDetailPage(id: restaurant.id),
                                    ),
                                  );
                                },
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Hero(
                                          tag: restaurant.pictureId,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              'https://restaurant-api.dicoding.dev/images/medium/${restaurant.pictureId}',
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                restaurant.name,
                                                style: theme.textTheme.titleLarge,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon(Icons.location_on,
                                                      size: 16, 
                                                      color: colorScheme.primary),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    restaurant.city,
                                                    style: theme.textTheme.bodyMedium
                                                      ?.copyWith(
                                                        color: theme.textTheme.bodyMedium
                                                          ?.color?.withOpacity(0.7)),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  Icon( Icons.star,
                                                      size: 16,
                                                      color: Colors.amber),
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    restaurant.rating.toString(),
                                                    style: theme.textTheme.bodyMedium
                                                      ?.copyWith(
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  const Spacer(),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color: colorScheme.secondary
                                                        .withOpacity(0.2),
                                                      borderRadius:
                                                          BorderRadius.circular(12),
                                                    ),
                                                    child: Text(
                                                      restaurant.rating > 4.5
                                                          ? 'Premium'
                                                          : 'Standard',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: colorScheme.secondary,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        } else if (state.state == ResultState.noData) {
                          return Center(
                            child: Text(
                              state.message,
                              style: theme.textTheme.bodyLarge,
                            ),
                          );
                        } else {
                          return Center(
                            child: Text(
                              state.message,
                              style: theme.textTheme.bodyLarge,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}