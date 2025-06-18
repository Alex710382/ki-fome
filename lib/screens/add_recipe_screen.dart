// lib/screens/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:image_picker/image_picker.dart'; // Importar o image_picker
import 'dart:io'; // Para File
import 'package:path_provider/path_provider.dart'; // Para getApplicationDocumentsDirectory
import 'package:path/path.dart' as p; // Para manipulação de caminhos

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedCategory = 'Salgadas';
  final List<String> _categories = [
    'Salgadas',
    'Doces',
    'Bebidas',
    'Fitness',
    'Bolos',
    'Outros',
  ];

  XFile? _pickedImage; // Para armazenar a imagem temporariamente
  String?
  _imagePathForRecipe; // O caminho final da imagem para a receita no Hive

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: source,
      imageQuality: 80,
    ); // Qualidade da imagem

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
        // O _imagePathForRecipe será definido ao salvar a imagem localmente no _submitRecipe
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Galeria'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Câmera'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Novo método para salvar a imagem no diretório da aplicação
  Future<String> _saveImageLocally(XFile imageFile) async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    // Cria um subdiretório para imagens de receita se não existir
    final recipeImagesDir = Directory(
      p.join(appDocumentDir.path, 'recipe_images'),
    );
    if (!await recipeImagesDir.exists()) {
      await recipeImagesDir.create(recursive: true);
    }

    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${p.basename(imageFile.path)}'; // Nome único
    final localPath = p.join(recipeImagesDir.path, fileName);

    final newImage = await File(
      imageFile.path,
    ).copy(localPath); // Copia a imagem para o novo local
    return newImage.path; // Retorna o caminho permanente
  }

  void _submitRecipe() async {
    // Tornar o método async
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final int prepTime = int.tryParse(_prepTimeController.text) ?? 0;

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

      String finalImagePath;
      if (_pickedImage != null) {
        // Se uma imagem foi selecionada, salve-a localmente
        finalImagePath = await _saveImageLocally(_pickedImage!);
      } else {
        // Se nenhuma imagem foi selecionada, use a imagem padrão do asset
        finalImagePath =
            'assets/images/default_recipe.jpg'; // Certifique-se de ter esta imagem no seu assets/images
      }

      final newRecipe = Recipe(
        id: '', // O ID será gerado no Provider
        name: name,
        imageUrl: finalImagePath, // Usar o caminho da imagem final
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
  void dispose() {
    _nameController.dispose();
    _prepTimeController.dispose();
    _ingredientsController.dispose();
    _instructionsController.dispose();
    super.dispose();
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
              // Área para seleção da imagem
              GestureDetector(
                onTap: () => _showImageSourceActionSheet(context),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child:
                      _pickedImage != null
                          ? Image.file(
                            // Exibe a imagem selecionada do picker
                            File(_pickedImage!.path),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                          : (_imagePathForRecipe != null &&
                              _imagePathForRecipe!.startsWith(
                                'assets/',
                              )) // Verifica se é um asset (para o caso de edição futura, se o _imagePathForRecipe for pré-preenchido)
                          ? Image.asset(
                            _imagePathForRecipe!, // Exibe a imagem padrão se nenhuma for selecionada e não houver _pickedImage
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder:
                                (context, error, stackTrace) => const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.grey,
                                ),
                          )
                          : const Column(
                            // Placeholder se nenhuma imagem foi selecionada
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.add_a_photo,
                                size: 50,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Tocar para adicionar imagem',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
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
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
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
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
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
