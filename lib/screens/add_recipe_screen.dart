// lib/screens/add_recipe_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ki_fome/models/recipe.dart';
import 'package:ki_fome/providers/recipe_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p; // Para manipulação de caminhos

class AddRecipeScreen extends StatefulWidget {
  final Recipe? recipeToEdit; // Torna a receita opcional para edição

  const AddRecipeScreen({
    super.key,
    this.recipeToEdit,
  }); // Construtor com parâmetro opcional

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _prepTimeController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _instructionsController = TextEditingController();

  String _selectedCategory = 'Salgadas'; // Valor padrão
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
  _imageUrl; // Para armazenar o caminho final da imagem (asset ou File path)

  bool _isEditing = false; // Flag para saber se estamos editando

  @override
  void initState() {
    super.initState();
    if (widget.recipeToEdit != null) {
      _isEditing = true;
      // Preenche os campos com os dados da receita para edição
      _nameController.text = widget.recipeToEdit!.name;
      _prepTimeController.text =
          widget.recipeToEdit!.prepTimeMinutes.toString();
      _ingredientsController.text = widget.recipeToEdit!.ingredients.join('\n');
      _instructionsController.text = widget.recipeToEdit!.instructions.join(
        '\n',
      );
      _selectedCategory = widget.recipeToEdit!.category;
      _imageUrl =
          widget.recipeToEdit!.imageUrl; // Define a URL da imagem existente
    } else {
      _isEditing = false;
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

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _pickedImage = pickedFile;
        _imageUrl =
            null; // Limpa o imageUrl existente se uma nova imagem for selecionada
      });
    }
  }

  Future<String?> _saveImageLocally(XFile? imageFile) async {
    if (imageFile == null) return null;

    final appDir = await getApplicationDocumentsDirectory();
    final fileName = p.basename(imageFile.path);
    final savedImage = await File(
      imageFile.path,
    ).copy('${appDir.path}/$fileName');
    return savedImage.path;
  }

  Future<void> _submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Salva a nova imagem localmente se uma foi selecionada
      final String? finalImageUrl =
          _pickedImage != null
              ? await _saveImageLocally(_pickedImage)
              : (_imageUrl ??
                  ''); // Se não selecionou nova, mantém a antiga ou vazio

      final ingredientsList =
          _ingredientsController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();
      final instructionsList =
          _instructionsController.text
              .split('\n')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty)
              .toList();

      final int? prepTime = int.tryParse(_prepTimeController.text);

      if (prepTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, insira um tempo de preparo válido.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      final recipeProvider = Provider.of<RecipeProvider>(
        context,
        listen: false,
      );

      if (_isEditing) {
        // Estamos editando uma receita existente
        final updatedRecipe = widget.recipeToEdit!.copyWith(
          name: _nameController.text,
          prepTimeMinutes: prepTime,
          ingredients: ingredientsList,
          instructions: instructionsList,
          imageUrl: finalImageUrl,
          category: _selectedCategory,
          // isFavorite permanece como está no original
        );
        await recipeProvider.updateRecipe(updatedRecipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita atualizada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        // Estamos adicionando uma nova receita
        final newRecipe = Recipe(
          id: recipeProvider.uuid.v4(), // Gera um novo ID
          name: _nameController.text,
          prepTimeMinutes: prepTime,
          ingredients: ingredientsList,
          instructions: instructionsList,
          imageUrl: finalImageUrl ?? '',
          isFavorite: false,
          category: _selectedCategory,
        );
        await recipeProvider.addRecipe(newRecipe);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receita adicionada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
      Navigator.of(context).pop(); // Volta para a tela anterior
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Receita' : 'Adicionar Nova Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome da Receita',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da receita';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _prepTimeController,
                decoration: const InputDecoration(
                  labelText: 'Tempo de Preparo (minutos)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      int.tryParse(value) == null) {
                    return 'Por favor, insira um tempo válido';
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
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira os ingredientes';
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
                maxLines: 7,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira as instruções';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Exibição da imagem selecionada ou existente
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder:
                        (ctx) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Tirar Foto'),
                              onTap: () {
                                _pickImage(ImageSource.camera);
                                Navigator.of(ctx).pop();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.photo_library),
                              title: const Text('Escolher da Galeria'),
                              onTap: () {
                                _pickImage(ImageSource.gallery);
                                Navigator.of(ctx).pop();
                              },
                            ),
                          ],
                        ),
                  );
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      _pickedImage != null
                          ? Image.file(
                            File(_pickedImage!.path),
                            fit: BoxFit.cover,
                          )
                          : (_imageUrl != null && _imageUrl!.isNotEmpty
                              ? (_imageUrl!.startsWith('assets/')
                                  ? Image.asset(_imageUrl!, fit: BoxFit.cover)
                                  : Image.file(
                                    File(_imageUrl!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ))
                              : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.camera_alt,
                                    size: 50,
                                    color: Colors.grey[700],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Adicionar Imagem',
                                    style: TextStyle(color: Colors.grey[700]),
                                  ),
                                ],
                              )),
                ),
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
                child: Text(
                  _isEditing ? 'Salvar Alterações' : 'Adicionar Receita',
                  style: const TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
