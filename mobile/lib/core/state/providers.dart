import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/models.dart';

// --- Pantry Provider ---
class PantryNotifier extends Notifier<List<PantryItem>> {
  static final List<PantryItem> _initialData = [
    PantryItem(id: '1', name: "Kangkong bundle", category: "Leafy Greens", zone: "Fridge", expiryDays: 1),
    PantryItem(id: '2', name: "Raw Pork Liempo (500g)", category: "Meat", zone: "Fridge", expiryDays: 1),
    PantryItem(id: '3', name: "Sitaw (String Beans)", category: "Vegetables", zone: "Fridge", expiryDays: 2),
    PantryItem(id: '4', name: "Bangus (Uncooked)", category: "Seafood", zone: "Fridge", expiryDays: 2),
    PantryItem(id: '5', name: "Tomato (Kamatis)", category: "Vegetables", zone: "Dry Pantry", expiryDays: 3),
    PantryItem(id: '6', name: "Garlic (Bawang)", category: "Aromatics", zone: "Dry Pantry", expiryDays: 14),
    PantryItem(id: '7', name: "Onion (Sibuyas)", category: "Aromatics", zone: "Dry Pantry", expiryDays: 21),
  ];

  @override
  List<PantryItem> build() {
    return _initialData;
  }

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

final pantryProvider = NotifierProvider<PantryNotifier, List<PantryItem>>(() {
  return PantryNotifier();
});

// --- Batches Provider ---
class BatchesNotifier extends Notifier<List<PreppedBatch>> {
  @override
  List<PreppedBatch> build() {
    return [
      PreppedBatch(id: 'b1', name: "Pork Sinigang", portions: 2, daysLeft: 2),
      PreppedBatch(id: 'b2', name: "Chicken Adobo", portions: 4, daysLeft: 4),
    ];
  }

  void consumePortion(String id) {
    state = state.map((batch) {
      if (batch.id == id) {
        return batch.copyWith(portions: batch.portions - 1);
      }
      return batch;
    }).where((batch) => batch.portions > 0).toList();
  }
}

final batchesProvider = NotifierProvider<BatchesNotifier, List<PreppedBatch>>(() {
  return BatchesNotifier();
});

// --- Shopping List Provider ---
class ShoppingListNotifier extends Notifier<List<ShoppingItem>> {
  @override
  List<ShoppingItem> build() {
    return [
      ShoppingItem(id: 's1', name: "Pork Liempo (500g)", type: "market"),
      ShoppingItem(id: 's2', name: "Kangkong bundle", type: "market"),
      ShoppingItem(id: 's3', name: "Garlic (Bawang)", type: "market"),
      ShoppingItem(id: 's4', name: "Soy Sauce (Datu Puti 1L)", type: "supermarket"),
      ShoppingItem(id: 's5', name: "Cooking Oil (1L)", type: "supermarket"),
    ];
  }

  void toggleCheck(String id) {
    state = state.map((item) {
      if (item.id == id) {
        return item.copyWith(checked: !item.checked);
      }
      return item;
    }).toList();
  }
}

final shoppingListProvider = NotifierProvider<ShoppingListNotifier, List<ShoppingItem>>(() {
  return ShoppingListNotifier();
});

// --- Waste Tracker Provider ---
class WasteNotifier extends Notifier<List<WasteLog>> {
  @override
  List<WasteLog> build() {
    return [
      WasteLog(id: 'w1', name: "Sayote", status: "Spoiled", cost: 25.0, date: "Yesterday"),
      WasteLog(id: 'w2', name: "Cabbage", status: "Spoiled", cost: 40.0, date: "2 days ago"),
      WasteLog(id: 'w3', name: "Chicken Breast", status: "Consumed", cost: 0, date: "3 days ago"),
    ];
  }
}

final wasteProvider = NotifierProvider<WasteNotifier, List<WasteLog>>(() {
  return WasteNotifier();
});
