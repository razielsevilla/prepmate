import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

// --- Pantry Provider ---
class PantryNotifier extends StateNotifier<List<PantryItem>> {
  PantryNotifier() : super(_initialData);

  static final List<PantryItem> _initialData = [
    PantryItem(id: '1', name: "Kangkong bundle", category: "Leafy Greens", zone: "Fridge", expiryDays: 1),
    PantryItem(id: '2', name: "Raw Pork Liempo (500g)", category: "Meat", zone: "Fridge", expiryDays: 1),
    PantryItem(id: '3', name: "Sitaw (String Beans)", category: "Vegetables", zone: "Fridge", expiryDays: 2),
    PantryItem(id: '4', name: "Bangus (Uncooked)", category: "Seafood", zone: "Fridge", expiryDays: 2),
    PantryItem(id: '5', name: "Tomato (Kamatis)", category: "Vegetables", zone: "Dry Pantry", expiryDays: 3),
    PantryItem(id: '6', name: "Garlic (Bawang)", category: "Aromatics", zone: "Dry Pantry", expiryDays: 14),
    PantryItem(id: '7', name: "Onion (Sibuyas)", category: "Aromatics", zone: "Dry Pantry", expiryDays: 21),
  ];

  void consume(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void discard(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void add(PantryItem item) {
    state = [...state, item];
  }
}

final pantryProvider = StateNotifierProvider<PantryNotifier, List<PantryItem>>((ref) {
  return PantryNotifier();
});

// --- Batches Provider ---
class BatchesNotifier extends StateNotifier<List<PreppedBatch>> {
  BatchesNotifier() : super([
    PreppedBatch(id: 'b1', name: "Pork Sinigang", portions: 2, daysLeft: 2),
    PreppedBatch(id: 'b2', name: "Chicken Adobo", portions: 4, daysLeft: 4),
  ]);

  void consumePortion(String id) {
    state = state.map((batch) {
      if (batch.id == id) {
        return batch.copyWith(portions: batch.portions - 1);
      }
      return batch;
    }).where((batch) => batch.portions > 0).toList();
  }

  void addBatch(PreppedBatch batch) {
    state = [...state, batch];
  }
}

final batchesProvider = StateNotifierProvider<BatchesNotifier, List<PreppedBatch>>((ref) {
  return BatchesNotifier();
});

// --- Shopping List Provider ---
class ShoppingListNotifier extends StateNotifier<List<ShoppingItem>> {
  ShoppingListNotifier() : super([
    ShoppingItem(id: 's1', name: "Garlic (1 head)", type: "market", checked: false),
    ShoppingItem(id: 's2', name: "Onion (2 pcs)", type: "market", checked: false),
    ShoppingItem(id: 's3', name: "Pork Sinigang Mix (1 sachet)", type: "supermarket", checked: false),
    ShoppingItem(id: 's4', name: "Soy Sauce (Datu Puti 1L)", type: "supermarket", checked: false),
  ]);

  void toggleCheck(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(checked: !item.checked);
      }
      return item;
    }).toList();
  }
}

final shoppingListProvider = StateNotifierProvider<ShoppingListNotifier, List<ShoppingItem>>((ref) {
  return ShoppingListNotifier();
});

// --- Waste Tracker Provider ---
class WasteNotifier extends StateNotifier<List<WasteLog>> {
  WasteNotifier() : super([
    WasteLog(id: 'w1', name: "Calamansi (10pcs)", date: "3 days ago", status: "Spoiled", cost: 35),
    WasteLog(id: 'w2', name: "Kangkong bundle", date: "Last week", status: "Spoiled", cost: 25),
    WasteLog(id: 'w3', name: "Saba Banana pack", date: "2 weeks ago", status: "Consumed", cost: 0),
  ]);

  void addWaste(WasteLog log) {
    state = [log, ...state];
  }
}

final wasteProvider = StateNotifierProvider<WasteNotifier, List<WasteLog>>((ref) {
  return WasteNotifier();
});
