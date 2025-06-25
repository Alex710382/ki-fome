// lib/providers/recipe_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/services/recipe_service.dart'; // Mantenha este import se estiver usando
import 'package:uuid/uuid.dart';

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _searchTerm = '';
  String _selectedCategory = 'Todas';

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String get searchTerm => _searchTerm;
  String get selectedCategory => _selectedCategory;

  final _recipesBox = Hive.box<Recipe>('recipes');
  final Uuid uuid = Uuid();

  RecipeProvider() {
    _loadRecipes();
  }

  Future<void> _loadRecipes() async {
    _isLoading = true;
    notifyListeners();

    if (_recipesBox.isNotEmpty) {
      _recipes = _recipesBox.values.toList();
    } else {
      final fetchedRecipes = await RecipeService().fetchRecipes();
      _recipes =
          fetchedRecipes
              .map((recipe) => recipe.copyWith(id: uuid.v4()))
              .toList(); // Garante IDs únicos
      await _saveRecipesToHive();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveRecipesToHive() async {
    await _recipesBox.clear(); // Limpa a box antes de adicionar tudo de novo
    await _recipesBox.addAll(_recipes);
  }

  void setSearchTerm(String term) {
    _searchTerm = term;
    notifyListeners();
  }

  void setSelectedCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  List<Recipe> get filteredRecipes {
    List<Recipe> tempRecipes = List.from(_recipes);

    if (_searchTerm.isNotEmpty) {
      tempRecipes =
          tempRecipes
              .where(
                (recipe) =>
                    recipe.name.toLowerCase().contains(
                      _searchTerm.toLowerCase(),
                    ) ||
                    recipe.ingredients.any(
                      (ingredient) => ingredient.toLowerCase().contains(
                        _searchTerm.toLowerCase(),
                      ),
                    ),
              )
              .toList();
    }

    if (_selectedCategory != 'Todos') {
      // Corrigido de 'Todas' para 'Todos' para consistência
      tempRecipes =
          tempRecipes
              .where((recipe) => recipe.category == _selectedCategory)
              .toList();
    }

    return tempRecipes;
  }

  Future<void> addRecipe(Recipe newRecipe) async {
    final recipeWithId = newRecipe.copyWith(id: uuid.v4()); // Garante ID único
    _recipes.add(recipeWithId);
    await _saveRecipesToHive();
    notifyListeners();
  }

  Future<void> deleteRecipe(String recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    await _saveRecipesToHive();
    notifyListeners();
  }

  Future<void> toggleFavorite(Recipe recipe) async {
    final index = _recipes.indexWhere((r) => r.id == recipe.id);
    if (index != -1) {
      _recipes[index] = recipe.copyWith(isFavorite: !recipe.isFavorite);
      await _saveRecipesToHive();
      notifyListeners();
    }
  }

  // NOVO: Método para atualizar uma receita existente
  Future<void> updateRecipe(Recipe updatedRecipe) async {
    final index = _recipes.indexWhere((r) => r.id == updatedRecipe.id);
    if (index != -1) {
      _recipes[index] =
          updatedRecipe; // Substitui a receita antiga pela atualizada
      await _saveRecipesToHive(); // Salva as receitas atualizadas no Hive
      notifyListeners(); // Notifica os ouvintes para reconstruir a UI
    }
  }
}
