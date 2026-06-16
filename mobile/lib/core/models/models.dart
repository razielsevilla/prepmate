class PantryItem {
  final String id;
  final String name;
  final String category;
  final String zone;
  final int expiryDays;

  PantryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.zone,
    required this.expiryDays,
  });

  PantryItem copyWith({
    String? id,
    String? name,
    String? category,
    String? zone,
    int? expiryDays,
  }) {
    return PantryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      zone: zone ?? this.zone,
      expiryDays: expiryDays ?? this.expiryDays,
    );
  }
}

class PreppedBatch {
  final String id;
  final String name;
  final int portions;
  final int daysLeft;

  PreppedBatch({
    required this.id,
    required this.name,
    required this.portions,
    required this.daysLeft,
  });

  PreppedBatch copyWith({
    String? id,
    String? name,
    int? portions,
    int? daysLeft,
  }) {
    return PreppedBatch(
      id: id ?? this.id,
      name: name ?? this.name,
      portions: portions ?? this.portions,
      daysLeft: daysLeft ?? this.daysLeft,
    );
  }
}

class ShoppingItem {
  final String id;
  final String name;
  final String type; // 'market' or 'supermarket'
  final bool checked;

  ShoppingItem({
    required this.id,
    required this.name,
    required this.type,
    this.checked = false,
  });

  ShoppingItem copyWith({
    String? id,
    String? name,
    String? type,
    bool? checked,
  }) {
    return ShoppingItem(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      checked: checked ?? this.checked,
    );
  }
}

class WasteLog {
  final String id;
  final String name;
  final String date;
  final String status;
  final double cost;

  WasteLog({
    required this.id,
    required this.name,
    required this.date,
    required this.status,
    required this.cost,
  });
}
