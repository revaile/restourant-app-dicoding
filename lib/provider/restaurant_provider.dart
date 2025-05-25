// restaurant_provider.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:restourantapp/api/api_service.dart';
import 'package:restourantapp/models/restaurant_detail_model.dart';
import 'package:restourantapp/models/restaurant_list_model.dart';
import 'package:http/http.dart' as http;

enum ResultState { loading, hasData, noData, error }

class RestaurantProvider extends ChangeNotifier {
  final ApiService apiService;

  RestaurantProvider(this.apiService) {
    fetchAllRestaurants();
  }

  late RestaurantListResult _restaurantResult;
  ResultState _state = ResultState.loading;
  String _message = '';

  ResultState get state => _state;
  RestaurantListResult get result => _restaurantResult;
  String get message => _message;

  Future<void> fetchAllRestaurants() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final restaurant = await apiService.getRestaurantList();
      if (restaurant.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'No Data Found';
      } else {
        _state = ResultState.hasData;
        _restaurantResult = restaurant;
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Error --> $e';
      notifyListeners();
    }
  }

  Future<RestaurantDetailResult> fetchRestaurantDetail(String id) async {
    final response = await http
        .get(Uri.parse('https://restaurant-api.dicoding.dev/detail/$id'));
    if (response.statusCode == 200) {
      return RestaurantDetailResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load restaurant detail');
    }
  }

  Future<void> fetchSearchRestaurant(String query) async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final result = await apiService.getRestaurantSearch(query);
      if (result.restaurants.isEmpty) {
        _state = ResultState.noData;
        _message = 'No matching restaurants found.';
      } else {
        _state = ResultState.hasData;
        _restaurantResult = RestaurantListResult(
          error: false,
          message: "Search success",
          count: result.restaurants.length,
          restaurants: result.restaurants,
        );
      }
      notifyListeners();
    } catch (e) {
      _state = ResultState.error;
      _message = 'Search failed: $e';
      notifyListeners();
    }
  }

  Future<void> submitReview({
  required String id,
  required String name,
  required String review,
}) async {
  try {
    await apiService.postReview(id: id, name: name, review: review);
  } catch (e) {
    rethrow;
  }
}

}
