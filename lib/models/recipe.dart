// lib/models/recipe.dart
import 'package:hive/hive.dart'; // Importe o Hive

part 'recipe.g.dart'; // Esta linha será gerada automaticamente

@HiveType(typeId: 0) // Define um tipo Hive com ID único
class Recipe {
  @HiveField(0) // Anota cada campo com um índice único
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final List<String> ingredients;
  @HiveField(3)
  final List<String> instructions;
  @HiveField(4)
  final String imageUrl;
  @HiveField(5)
  final int prepTimeMinutes;
  @HiveField(6)
  bool isFavorite;
  @HiveField(7)
  String category;

  Recipe({
    required this.id,
    required this.name,
    required this.ingredients,
    required this.instructions,
    required this.imageUrl,
    required this.prepTimeMinutes,
    this.isFavorite = false,
    required this.category,
  });

  Recipe copyWith({
    String? id,
    String? name,
    List<String>? ingredients,
    List<String>? instructions,
    String? imageUrl,
    int? prepTimeMinutes,
    bool? isFavorite,
    String? category,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      ingredients: ingredients ?? this.ingredients,
      instructions: instructions ?? this.instructions,
      imageUrl: imageUrl ?? this.imageUrl,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      isFavorite: isFavorite ?? this.isFavorite,
      category: category ?? this.category,
    );
  }

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'],
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: List<String>.from(json['instructions']),
      imageUrl: json['imageUrl'],
      prepTimeMinutes: json['prepTimeMinutes'],
      isFavorite: json['isFavorite'] ?? false,
      category: json['category'] ?? 'Outros',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions,
      'imageUrl': imageUrl,
      'prepTimeMinutes': prepTimeMinutes,
      'isFavorite': isFavorite,
      'category': category,
    };
  }
}
