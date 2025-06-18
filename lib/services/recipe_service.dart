// lib/services/recipe_service.dart
import '../models/recipe.dart';
import '../data/mock_recipes.dart'; // Para dados mockados

class RecipeService {
  Future<List<Recipe>> fetchRecipes() async {
    // Simula um atraso de rede
    await Future.delayed(const Duration(seconds: 1));
    // Retorna dados mockados por enquanto
    return mockRecipes;
  }

  // Futuramente, você pode adicionar métodos como:
  // Future<Recipe> getRecipeById(String id) async { ... }
  // Future<void> addRecipe(Recipe recipe) async { ... }
}
