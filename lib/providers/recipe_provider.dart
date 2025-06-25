// lib/providers/recipe_provider.dart
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Importe Hive
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/services/recipe_service.dart';
import 'package:uuid/uuid.dart'; // Para gerar IDs únicos 

class RecipeProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];
  bool _isLoading = false;
  String _searchTerm = '';
  String _selectedCategory = 'Todas';

  List<Recipe> get recipes => _recipes;
  bool get isLoading => _isLoading;
  String get searchTerm => _searchTerm;
  String get selectedCategory => _selectedCategory;

  final _recipesBox = Hive.box<Recipe>('recipes'); // Acessa a caixa do Hive
  final Uuid uuid = Uuid(); // Instância para gerar IDs

  RecipeProvider() {
    _loadRecipes(); // Carrega receitas ao inicializar
  }

  Future<void> _loadRecipes() async {
    _isLoading = true;
    notifyListeners();

    // Tenta carregar do Hive primeiro
    if (_recipesBox.isNotEmpty) {
      _recipes = _recipesBox.values.toList();
    } else {
      // Se não houver no Hive, carrega as mockadas
      final fetchedRecipes = await RecipeService().fetchRecipes();
      _recipes =
          fetchedRecipes
              .map((recipe) => recipe.copyWith(isFavorite: false))
              .toList();
      await _saveRecipesToHive(); // Salva as mockadas no Hive na primeira vez
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _saveRecipesToHive() async {
    await _recipesBox.clear(); // Limpa a caixa atual
    await _recipesBox.addAll(_recipes); // Adiciona todas as receitas da lista
  }

  void toggleFavorite(String recipeId) {
    final index = _recipes.indexWhere((recipe) => recipe.id == recipeId);
    if (index != -1) {
      _recipes[index] = _recipes[index].copyWith(
        isFavorite: !_recipes[index].isFavorite,
      );
      _saveRecipesToHive(); // Salva no Hive
      notifyListeners();
    }
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
                (recipe) => recipe.name.toLowerCase().contains(
                  _searchTerm.toLowerCase(),
                ),
              )
              .toList();
    }

    if (_selectedCategory != 'Todas') {
      tempRecipes =
          tempRecipes
              .where((recipe) => recipe.category == _selectedCategory)
              .toList();
    }

    return tempRecipes;
  }

  // NOVO: Método para adicionar uma nova receita pelo usuário
  Future<void> addRecipe(Recipe newRecipe) async {
    // Gera um ID único para a nova receita
    final recipeWithId = newRecipe.copyWith(id: uuid.v4());
    _recipes.add(recipeWithId);
    await _saveRecipesToHive(); // Salva no Hive
    notifyListeners();
  }

  // NOVO: Método para remover uma receita (útil para futuras expansões)
  Future<void> deleteRecipe(String recipeId) async {
    _recipes.removeWhere((recipe) => recipe.id == recipeId);
    await _saveRecipesToHive();
    notifyListeners();
  }
}
