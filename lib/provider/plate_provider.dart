import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PlateItem {
  final String id;
  final String name;
  final int price;
  final String image;

  PlateItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.image});

  factory PlateItem.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PlateItem(
      id: doc.id,
      name: data['name'],
      price: data['price'],
      image: data['image'],
    );
  }
}

class PlateState {
  final List<PlateItem> items;
  final List<int> counters;
  final int totalDishes;
  final double totalPrice;

  PlateState(
      {required this.items,
      required this.counters,
      required this.totalDishes,
      required this.totalPrice});
}

class PlateNotifier extends StateNotifier<PlateState> {
  PlateNotifier()
      : super(PlateState(
            items: [], counters: [], totalDishes: 0, totalPrice: 0.0)) {
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('plates').get();
      final items =
          snapshot.docs.map((doc) => PlateItem.fromFirestore(doc)).toList();
      final counters = List<int>.filled(items.length, 1);
      final totalDishes = items.length;
      final totalPrice = items.fold(0.0, (sum, item) => sum + item.price);

      state = PlateState(
          items: items,
          counters: counters,
          totalDishes: totalDishes,
          totalPrice: totalPrice);
    } catch (e) {
      print('Failed to fetch items: $e');
    }
  }

  Future<void> addToPlate(String name, double price, String imagePath) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      // Convert image to Base64 string from the device's file system
      final bytes = await rootBundle.load(imagePath);
      String base64Image = base64Encode(bytes.buffer.asUint8List());

      final plateItem = {
        'name': name,
        'price': price,
        'image': base64Image,
        'user_id': user?.uid,
        'timestamp': FieldValue.serverTimestamp(),
      };

      // Add the plate item to Firestore
      await FirebaseFirestore.instance.collection('plates').add(plateItem);

      // Fetch the updated items
      _fetchItems();

      print('Added to plate: $name, $price');
    } catch (e) {
      print('Failed to add to plate: $e');
    }
  }

  void incrementCounter(int index) {
    final updatedCounters = [...state.counters];
    updatedCounters[index]++;
    final updatedTotalPrice = state.totalPrice + state.items[index].price;

    state = PlateState(
      items: state.items,
      counters: updatedCounters,
      totalDishes: state.totalDishes,
      totalPrice: updatedTotalPrice,
    );
  }

  void decrementCounter(int index) {
    final updatedCounters = [...state.counters];
    if (updatedCounters[index] > 1) {
      updatedCounters[index]--;
      final updatedTotalPrice = state.totalPrice - state.items[index].price;

      state = PlateState(
        items: state.items,
        counters: updatedCounters,
        totalDishes: state.totalDishes,
        totalPrice: updatedTotalPrice,
      );
    }
  }

  Future<void> removeItem(int index) async {
    try {
      final itemId = state.items[index].id;

      // Remove the item from Firestore
      await FirebaseFirestore.instance
          .collection('plates')
          .doc(itemId)
          .delete();

      // Remove the item from the state
      final updatedItems = [...state.items]..removeAt(index);
      final updatedCounters = [...state.counters]..removeAt(index);
      final updatedTotalDishes = state.totalDishes - 1;
      final updatedTotalPrice =
          state.totalPrice - (state.items[index].price * state.counters[index]);

      state = PlateState(
        items: updatedItems,
        counters: updatedCounters,
        totalDishes: updatedTotalDishes,
        totalPrice: updatedTotalPrice,
      );
    } catch (e) {
      print('Failed to remove item: $e');
    }
  }
}

// Riverpod provider
final plateProvider = StateNotifierProvider<PlateNotifier, PlateState>((ref) {
  return PlateNotifier();
});
