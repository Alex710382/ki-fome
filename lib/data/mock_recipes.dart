// lib/data/mock_recipes.dart

import 'package:ki_fome/models/recipe.dart';
import 'package:uuid/uuid.dart';

final Uuid _uuid = const Uuid(); // Usar o mesmo Uuid do RecipeProvider

final List<Recipe> mockRecipes = [
  // --- Salgadas ---
  Recipe(
    id: _uuid.v4(),
    name: 'Salada Caesar',
    imageUrl: 'assets/images/salada_caesar.jpg',
    prepTimeMinutes: 20,
    ingredients: [
      '1 pé de alface romana',
      '1 xícara de croutons',
      '1/2 xícara de queijo parmesão ralado',
      'Molho Caesar a gosto',
      'Peito de frango grelhado (opcional)',
    ],
    instructions: [
      'Lave e seque bem a alface, rasgue as folhas e coloque em uma tigela grande.',
      'Adicione os croutons e o queijo parmesão.',
      'Regue com molho Caesar e misture delicadamente.',
      'Se for usar frango, adicione-o fatiado.',
    ],
    category: 'Salgadas',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Strogonoff de Frango',
    imageUrl: 'assets/images/strogonoff.jpg',
    prepTimeMinutes: 40,
    ingredients: [
      '500g de peito de frango em cubos',
      '1 cebola picada',
      '2 dentes de alho amassados',
      '1 lata de creme de leite',
      '1/2 xícara de molho de tomate',
      '1 colher de sopa de mostarda',
      '1 colher de sopa de ketchup',
      'Sal e pimenta a gosto',
      'Óleo para refogar',
    ],
    instructions: [
      'Em uma panela, aqueça o óleo e doure o frango.',
      'Adicione a cebola e o alho e refogue.',
      'Acrescente o molho de tomate, mostarda e ketchup, deixe apurar por 3 minutos.',
      'Desligue o fogo e adicione o creme de leite. Misture bem.',
      'Sirva com arroz branco e batata palha.',
    ],
    category: 'Salgadas',
    isFavorite: false,
  ),

  // --- Doces ---
  Recipe(
    id: _uuid.v4(),
    name: 'Bolo de Cenoura com Cobertura de Chocolate',
    imageUrl: 'assets/images/bolo_cenoura.jpg',
    prepTimeMinutes: 60,
    ingredients: [
      '3 cenouras médias',
      '4 ovos',
      '1 xícara de óleo',
      '2 xícaras de açúcar',
      '2 e 1/2 xícaras de farinha de trigo',
      '1 colher de sopa de fermento em pó',
      'Para a cobertura:',
      '1 lata de leite condensado',
      '4 colheres de sopa de chocolate em pó',
      '2 colheres de sopa de manteiga',
    ],
    instructions: [
      'No liquidificador, bata a cenoura, os ovos e o óleo.',
      'Em uma tigela, misture o açúcar e a farinha. Despeje a mistura do liquidificador e misture bem.',
      'Adicione o fermento e misture delicadamente.',
      'Leve ao forno preaquecido a 180°C por cerca de 40 minutos.',
      'Para a cobertura, misture os ingredientes em uma panela e leve ao fogo baixo, mexendo até engrossar. Despeje sobre o bolo ainda quente.',
    ],
    category: 'Doces',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Brigadeiro Tradicional',
    imageUrl: 'assets/images/brigadeiro.jpg',
    prepTimeMinutes: 20,
    ingredients: [
      '1 lata de leite condensado',
      '4 colheres de sopa de chocolate em pó',
      '1 colher de sopa de manteiga',
      'Granulado para decorar',
    ],
    instructions: [
      'Em uma panela, misture o leite condensado, o chocolate em pó e a manteiga.',
      'Leve ao fogo baixo, mexendo sempre até desgrudar do fundo da panela.',
      'Despeje em um prato untado e deixe esfriar.',
      'Enrole os brigadeiros e passe no granulado.',
    ],
    category: 'Doces',
    isFavorite: false,
  ),

  // --- Bebidas ---
  Recipe(
    id: _uuid.v4(),
    name: 'Suco Refrescante de Laranja com Limão',
    imageUrl: 'assets/images/suco.jpg',
    prepTimeMinutes: 10,
    ingredients: [
      '4 laranjas',
      '1 limão',
      '500ml de água gelada',
      'Açúcar ou adoçante a gosto',
      'Gelo a gosto',
    ],
    instructions: [
      'Esprema o suco das laranjas e do limão.',
      'Misture os sucos com a água gelada.',
      'Adicione açúcar ou adoçante a gosto e mexa bem.',
      'Sirva com gelo.',
    ],
    category: 'Bebidas',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Smoothie Verde Detox',
    imageUrl: 'assets/images/smoothie_verde.jpg', // Crie esta imagem ou use uma genérica
    prepTimeMinutes: 10,
    ingredients: [
      '1 folha grande de couve sem talo',
      '1 maçã verde picada',
      '1/2 pepino com casca',
      'Suco de 1 limão',
      '200ml de água de coco',
      'Gelo a gosto',
    ],
    instructions: [
      'Lave bem todos os ingredientes.',
      'Coloque a couve, maçã, pepino, suco de limão e água de coco no liquidificador.',
      'Bata até obter uma mistura homogênea e cremosa.',
      'Adicione gelo e bata novamente até ficar bem gelado.',
      'Sirva imediatamente.',
    ],
    category: 'Bebidas',
    isFavorite: false,
  ),

  // --- Fitness ---
  Recipe(
    id: _uuid.v4(),
    name: 'Frango Grelhado com Legumes no Vapor',
    imageUrl: 'assets/images/frango_legumes.jpg', // Certifique-se que esta imagem existe
    prepTimeMinutes: 30,
    ingredients: [
      '2 filés de peito de frango',
      '1 brócolis pequeno',
      '2 cenouras médias',
      '1 abobrinha pequena',
      'Sal, pimenta do reino, alho e ervas finas a gosto',
      'Azeite de oliva',
    ],
    instructions: [
      'Tempere os filés de frango com sal, pimenta, alho e ervas finas. Grelhe em uma frigideira antiaderente com um fio de azeite até dourar e cozinhar por completo.',
      'Corte o brócolis em floretes, as cenouras em rodelas e a abobrinha em cubos.',
      'Cozinhe os legumes no vapor até ficarem macios, mas ainda crocantes.',
      'Sirva o frango grelhado com os legumes no vapor.',
    ],
    category: 'Fitness',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Omelete de Legumes',
    imageUrl: 'assets/images/omelete_legumes.jpg', // Crie esta imagem ou use uma genérica
    prepTimeMinutes: 15,
    ingredients: [
      '2 ovos grandes',
      '1/4 xícara de brócolis picado',
      '1/4 xícara de pimentão picado',
      '1 colher de sopa de cebola roxa picada',
      'Sal e pimenta do reino a gosto',
      'Azeite ou spray de cozinha',
    ],
    instructions: [
      'Em uma tigela, bata os ovos com sal e pimenta.',
      'Em uma frigideira antiaderente, aqueça um fio de azeite e refogue os legumes (brócolis, pimentão, cebola) por 3-5 minutos, até ficarem macios.',
      'Despeje os ovos batidos sobre os legumes na frigideira.',
      'Cozinhe em fogo baixo até as bordas da omelete começarem a firmar. Vire e cozinhe o outro lado por mais 1-2 minutos.',
      'Sirva quente.',
    ],
    category: 'Fitness',
    isFavorite: false,
  ),

  // --- Bolos ---
  Recipe(
    id: _uuid.v4(),
    name: 'Bolo de Fubá Cremoso',
    imageUrl: 'assets/images/bolo_fuba.jpg', // Certifique-se que esta imagem existe
    prepTimeMinutes: 70,
    ingredients: [
      '3 ovos',
      '3 xícaras de leite',
      '1 xícara de óleo',
      '2 xícaras de açúcar',
      '1 xícara de fubá',
      '1/2 xícara de farinha de trigo',
      '50g de queijo parmesão ralado',
      '1 colher de sopa de fermento em pó',
    ],
    instructions: [
      'Bata no liquidificador os ovos, o leite, o óleo, o açúcar, o fubá e a farinha de trigo até ficar homogêneo.',
      'Adicione o queijo parmesão ralado e o fermento em pó, misturando levemente com uma colher.',
      'Despeje em uma forma untada e enfarinhada.',
      'Leve ao forno médio (180°C) preaquecido por cerca de 50-60 minutos, ou até dourar e firmar (o centro pode ficar cremoso).',
    ],
    category: 'Bolos',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Cheesecake de Frutas Vermelhas',
    imageUrl: 'assets/images/cheesecake.jpg', // Crie esta imagem ou use uma genérica
    prepTimeMinutes: 180, // Considerando o tempo de refrigeração
    ingredients: [
      'Para a base:',
      '200g de biscoito maisena triturado',
      '100g de manteiga derretida',
      'Para o creme:',
      '500g de cream cheese',
      '1 lata de leite condensado',
      '1/2 xícara de suco de limão',
      '1 envelope de gelatina sem sabor e incolor',
      'Para a cobertura:',
      '200g de frutas vermelhas (morangos, framboesas, mirtilos)',
      '1/2 xícara de açúcar',
      '1/4 xícara de água',
    ],
    instructions: [
      'Misture o biscoito triturado com a manteiga derretida e forre o fundo de uma forma de aro removível. Leve à geladeira por 15 minutos.',
      'Bata o cream cheese, leite condensado e suco de limão no liquidificador. Dissolva a gelatina conforme as instruções e adicione à mistura, batendo mais um pouco.',
      'Despeje o creme sobre a base de biscoito e leve à geladeira por no mínimo 4 horas, ou até firmar bem.',
      'Para a cobertura, leve as frutas vermelhas, açúcar e água ao fogo baixo, mexendo até as frutas amolecerem e o molho encorpar levemente. Deixe esfriar.',
      'Desenforme o cheesecake e cubra com a calda de frutas vermelhas.',
    ],
    category: 'Bolos',
    isFavorite: false,
  ),

  // --- Outros ---
  Recipe(
    id: _uuid.v4(),
    name: 'Molho Pesto Caseiro',
    imageUrl: 'assets/images/molho_pesto.jpg', // Certifique-se que esta imagem existe
    prepTimeMinutes: 10,
    ingredients: [
      '2 xícaras de folhas de manjericão fresco',
      '1/2 xícara de queijo parmesão ralado',
      '1/3 xícara de pinhões (ou castanha de caju)',
      '2 dentes de alho',
      '1/2 xícara de azeite de oliva extra virgem',
      'Sal e pimenta do reino a gosto',
    ],
    instructions: [
      'Em um processador de alimentos (ou liquidificador), coloque as folhas de manjericão, queijo parmesão, pinhões e alho.',
      'Processe pulsando até triturar bem. Com o processador ligado, adicione o azeite em fio fino até obter a consistência desejada.',
      'Tempere com sal e pimenta do reino. Sirva com massas, pães ou saladas.',
    ],
    category: 'Outros',
    isFavorite: false,
  ),
  Recipe(
    id: _uuid.v4(),
    name: 'Guacamole Fresco',
    imageUrl: 'assets/images/guacamole.jpg', // Crie esta imagem ou use uma genérica
    prepTimeMinutes: 15,
    ingredients: [
      '2 abacates maduros',
      '1/2 cebola roxa picada finamente',
      '1 tomate picado sem sementes',
      '1/4 xícara de coentro picado',
      'Suco de 1 limão',
      'Sal e pimenta do reino a gosto',
      'Opcional: 1 pimenta jalapeño picada (sem sementes)',
    ],
    instructions: [
      'Amasse os abacates em uma tigela com um garfo, deixando alguns pedaços.',
      'Adicione a cebola roxa, o tomate, o coentro e o suco de limão. Misture bem.',
      'Tempere com sal e pimenta do reino a gosto. Se usar, adicione a pimenta jalapeño.',
      'Sirva imediatamente com tortilhas, tacos ou como acompanhamento.',
    ],
    category: 'Outros',
    isFavorite: false,
  ),
];