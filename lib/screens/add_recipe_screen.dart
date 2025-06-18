// lib/screens/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>(); // Chave para validar o formulário
  final _nameController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _ingredientsController =
      TextEditingController(); // Para múltiplos ingredientes
  final _instructionsController =
      TextEditingController(); // Para múltiplas instruções

  String _selectedCategory = 'Salgadas'; // Valor padrão para a categoria

  // Lista de categorias disponíveis
  final List<String> _categories = [
    'Salgadas',
    'Doces',
    'Bebidas',
    'Fitness',
    'Bolos',
    'Outros',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _imageUrlController.dispose();
    _prepTimeController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _submitRecipe() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String imageUrl =
          _imageUrlController.text.isEmpty
              ? 'assets/images/default_recipe.jpg' // Imagem padrão se o usuário não fornecer
              : _imageUrlController.text;
      final int prepTime = int.tryParse(_prepTimeController.text) ?? 0;

      // Divide os ingredientes e instruções por nova linha, removendo espaços vazios
      final List<String> ingredients =
          _ingredientsController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final List<String> instructions =
          _instructionsController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      if (ingredients.isEmpty || instructions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Por favor, adicione pelo menos um ingrediente e uma instrução.',
            ),
          ),
        );
        return;
      }

      final newRecipe = Recipe(
        id: '', // O ID será gerado no Provider
        name: name,
        imageUrl: imageUrl,
        prepTimeMinutes: prepTime,
        ingredients: ingredients,
        instructions: instructions,
        category: _selectedCategory,
        isFavorite: false, // Nova receita não é favorita por padrão
      );

      Provider.of<RecipeProvider>(context, listen: false).addRecipe(newRecipe);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Receita adicionada com sucesso!')),
      );

      Navigator.pop(context); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Nova Receita')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nome da Receita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o nome da receita';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText:
                      'URL da Imagem (opcional, ou caminho local, ex: assets/images/pizza.jpg)',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prepTimeController,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Preparo (minutos)',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite o tempo de preparo';
                  }
                  if (int.tryParse(value) == null || int.parse(value) < 0) {
                    return 'Tempo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ingredientsController,
                decoration: const InputDecoration(
                  labelText: 'Ingredientes (um por linha)',
                  alignLabelWithHint: true,
                ),
                maxLines: null, // Múltiplas linhas
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Por favor, adicione os ingredientes';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _instructionsController,
                decoration: const InputDecoration(
                  labelText: 'Modo de Preparo (um passo por linha)',
                  alignLabelWithHint: true,
                ),
                maxLines: null, // Múltiplas linhas
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.isEmpty || value.trim().isEmpty) {
                    return 'Por favor, adicione o modo de preparo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items:
                    _categories.map((String category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCategory = newValue!;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitRecipe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Adicionar Receita',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
