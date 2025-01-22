import 'package:flutter_riverpod/flutter_riverpod.dart';

// A list to hold the items added to the plate
final plateProvider = StateNotifierProvider<PlateNotifier, List<String>>((ref) {
  return PlateNotifier();
});

class PlateNotifier extends StateNotifier<List<String>> {
  PlateNotifier() : super([]);

  // Method to add an item to the plate
  void addItem(String item) {
    state = [...state, item];
  }

  // Method to remove an item from the plate
  void removeItem(String item) {
    state = state.where((i) => i != item).toList();
  }
}
