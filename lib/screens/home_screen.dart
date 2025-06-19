// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:ki_fome/screens/add_recipe_screen.dart';
import 'package:ki_fome/widgets/recipe_card.dart';
import 'package:ki_fome/screens/recipe_detail_screen.dart'; // Importe se não estiver
import 'package:ki_fome/screens/favorites_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Adicione um controller para o campo de busca
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategoryFilter = 'Todos'; // Estado para o filtro de categoria

  // Lista de categorias (deve ser a mesma que você usa para adicionar receitas)
  // Certifique-se de que 'Todos' seja a primeira opção para exibir todas as receitas.
  final List<String> _categories = [
    'Todos', // Adicione esta opção para mostrar todas as receitas
    'Salgadas',
    'Doces',
    'Bebidas',
    'Fitness',
    'Bolos',
    'Outros',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
    });
  }

  // Função para mudar a categoria selecionada e fechar o drawer
  void _selectCategory(String category) {
    setState(() {
      _selectedCategoryFilter = category;
      Navigator.pop(context); // Fecha o drawer
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = Provider.of<RecipeProvider>(context);

    // Filtra as receitas baseadas na pesquisa e na categoria
    final filteredRecipes =
        recipeProvider.recipes.where((recipe) {
          final matchesSearch =
              _searchQuery.isEmpty ||
              recipe.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              recipe.ingredients.any(
                (ingredient) => ingredient.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              );

          final matchesCategory =
              _selectedCategoryFilter == 'Todos' ||
              recipe.category == _selectedCategoryFilter;

          return matchesSearch && matchesCategory;
        }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ki Fome'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar receitas...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      // --- INÍCIO DO MENU LATERAL (DRAWER) ---
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            // Cabeçalho do Drawer (opcional, mas recomendado)
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Categorias',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Explore por tipo de receita',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            // Itens da lista de categorias
            ..._categories.map((category) {
              return ListTile(
                leading: Icon(
                  _getCategoryIcon(
                    category,
                  ), // Função para obter ícone por categoria
                  color:
                      _selectedCategoryFilter == category
                          ? Theme.of(context).primaryColor
                          : Colors.grey[700],
                ),
                title: Text(
                  category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        _selectedCategoryFilter == category
                            ? FontWeight.bold
                            : FontWeight.normal,
                    color:
                        _selectedCategoryFilter == category
                            ? Theme.of(context).primaryColor
                            : Colors.black87,
                  ),
                ),
                selected:
                    _selectedCategoryFilter ==
                    category, // Marca o item selecionado
                onTap: () => _selectCategory(category),
              );
            }).toList(),
            const Divider(), // Divisor para separar categorias de outras opções (ex: Favoritos)
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text('Receitas Favoritas'),
              onTap: () {
                Navigator.pop(context); // Fecha o drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FavoritesScreen(),
                  ), // Se você tiver uma FavoritesScreen
                );
              },
            ),
          ],
        ),
      ),
      // --- FIM DO MENU LATERAL (DRAWER) ---
      body:
          filteredRecipes.isEmpty
              ? Center(
                child: Text(
                  _searchQuery.isNotEmpty
                      ? 'Nenhuma receita encontrada para "${_searchQuery}" na categoria "${_selectedCategoryFilter}".'
                      : 'Nenhuma receita na categoria "${_selectedCategoryFilter}".\nAdicione algumas!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2.0,
                  mainAxisSpacing: 2.0,
                  childAspectRatio:
                      0.6, // Ajuste se precisar para o tamanho do card
                ),
                itemCount: filteredRecipes.length,
                itemBuilder: (context, index) {
                  return RecipeCard(
                    recipe: filteredRecipes[index],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) => RecipeDetailScreen(
                                recipe: filteredRecipes[index],
                              ),
                        ),
                      );
                    },
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Função auxiliar para retornar um ícone com base na categoria
  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Salgadas':
        return Icons.local_pizza;
      case 'Doces':
        return Icons.cake;
      case 'Bebidas':
        return Icons.local_drink;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Bolos':
        return Icons.cake_outlined; // Ou outro ícone de bolo
      case 'Todos':
        return Icons.restaurant_menu;
      default:
        return Icons.category;
    }
  }
}
