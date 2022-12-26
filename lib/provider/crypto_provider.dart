import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto_app/domain/domain.dart';
import 'package:crypto_app/presentation/presentation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

/* 
  Provider de la aplicación
 */

class CryptoProvider extends ChangeNotifier {
  /* 
    Instancias de Firebase y FirebaseAuth
   */

  final FirebaseFirestore _firebaseStorage = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /* 
    Instancias de los controladores de paginación 
    del home y favoritos
   */

  PagingController<int, CoinModel> homeController = PagingController(firstPageKey: 1);
  PagingController<int, CoinModel> favoriteController = PagingController(firstPageKey: 1);

  /* 
    Listados de cryptos para actualizar en 
    pantalla
   */

  List<CoinModel> favoriteCoins = [];
  List<String> favoriteIds = [];
  List<SuggestionModel> coinsList = [];

  /* 
    Listados de opciones para los filtros
   */

  final sortTypeList = [
    'Precio: de mayor a menor',
    'Precio: de menor a mayor',
  ];

  /* 
    Crypto seleccionada en el buscador 
    de comparación
   */

  SuggestionModel? _firstSelectedCoin;
  SuggestionModel? get firstSelectedCoin => _firstSelectedCoin;
  set setFirstSelectedCoin(SuggestionModel? value) {
    _firstSelectedCoin = value;
    notifyListeners();
  }

  /* 
    Crypto seleccionada en el buscador 
    de comparación
   */

  SuggestionModel? _secondSelectedCoin;
  SuggestionModel? get secondSelectedCoin => _secondSelectedCoin;
  set setSecondSelectedCoin(SuggestionModel? value) {
    _secondSelectedCoin = value;
    notifyListeners();
  }

  /* 
    Crypto obtenida para
    la comparación
   */

  CoinModel? _selectedLeftCoin;
  CoinModel? get selectedLeftCoin => _selectedLeftCoin;
  set setSelectedLeftCoin(CoinModel? value) {
    _selectedLeftCoin = value;
    notifyListeners();
  }

  /* 
    Crypto obtenida para
    la comparación
   */

  CoinModel? _selectedRightCoin;
  CoinModel? get selectedRightCoin => _selectedRightCoin;
  set setSelectedRightCoin(CoinModel? value) {
    _selectedRightCoin = value;
    notifyListeners();
  }

  /* 
    Tipo de ordenamiento seleccionado
   */

  String? _selectedSortType = 'Precio: de mayor a menor';
  String? get selectedSortType => _selectedSortType;
  set selectedSortType(String? value) {
    _selectedSortType = value;
    notifyListeners();
  }

  /* 
    Id de la crypto seleccionada
   */

  String? _selectedCoinId;
  String? get selectedCoinId => _selectedCoinId;
  set selectedCoinId(String? value) {
    _selectedCoinId = value;
    notifyListeners();
  }

  /* 
    Obtiene listado de cryptos y las parsea
    al modelo CoinModel
   */

  Future<List<CoinModel>> fetchCoins(int page, String order, List<String> coinIds) async {
    try {
      String ids = '';

      if (coinIds.isNotEmpty) {
        ids = coinIds.join('%2C%20');
      }

      final response = await Api.get(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&ids=$ids&order=$order&per_page=15&page=$page&sparkline=false',
      );

      return response.map<CoinModel>((e) => CoinModel.fromMap(e)).toList();
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Pagina las cryptos al controlador
   */

  Future<List<CoinModel>> getPaginatedCoins(
    int page,
    PagingController pageController,
    String order,
  ) async {
    try {
      if (page == 1) {
        pageController.itemList = <CoinModel>[];
      }

      List<CoinModel> fetchedCoins = await fetchCoins(page, order, []);

      if (fetchedCoins.length < 15) {
        pageController.appendLastPage(fetchedCoins);
      } else {
        pageController.appendPage(fetchedCoins, page + 1);
      }

      return fetchedCoins;
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado de cryptos 
    filtradas por Id
   */

  Future<List<CoinModel>> getCoinById(int page, PagingController pageController, String order, String coinId) async {
    try {
      pageController.itemList = <CoinModel>[];

      List<CoinModel> fetchedCoins = await fetchCoins(page, order, [coinId]);

      pageController.appendLastPage(fetchedCoins);

      return fetchedCoins;
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado de cryptos 
    favoritas del usuario
   */

  Future<List<CoinModel>> getFavoriteCoins(
    int page,
    PagingController pageController,
  ) async {
    try {
      final List<String> favorites = await getFavoritesByUser();

      if (favorites.isNotEmpty) {
        if (page == 1) {
          pageController.itemList = <CoinModel>[];
        }

        favoriteCoins = await fetchCoins(page, '', favorites);

        if (favoriteCoins.length < 15) {
          pageController.appendLastPage(favoriteCoins);
        } else {
          pageController.appendPage(favoriteCoins, page + 1);
        }

        return favoriteCoins;
      } else {
        pageController.appendLastPage(<CoinModel>[]);
        return [];
      }
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado de cryptos 
    filtradas por query
   */

  Future<List<SuggestionModel>> searchCoins(String query, PagingController pageController) async {
    try {
      final response = await Api.get('https://api.coingecko.com/api/v3/search?query=${query.replaceAll(' ', '%20')}');

      List<SuggestionModel> searchedCoins = response['coins'].map<SuggestionModel>((e) => SuggestionModel.fromMap(e)).toList();

      return searchedCoins;
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado ids favoritos 
    del usuario desde Firestore
   */

  Future<List<String>> getFavoritesByUser() async {
    try {
      CollectionReference favorites = FirebaseFirestore.instance.collection('favorite');

      DocumentSnapshot response = await favorites.doc(_firebaseAuth.currentUser!.uid).get();

      final Map<String, dynamic> favoritesMap = response.data() as Map<String, dynamic>;

      return List<String>.from(favoritesMap['favorites']);
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Agrega o elimina una crypto 
    de favoritos en firestore
   */

  Future<void> toggleFavorite(
    CoinModel coin,
  ) async {
    try {
      if (favoriteIds.contains(coin.id)) {
        favoriteIds.remove(coin.id);
        favoriteCoins.removeWhere((element) => element.id == coin.id);
        favoriteController.itemList!.removeWhere((element) => element.id == coin.id);
        notifyListeners();
      } else {
        favoriteIds.add(coin.id);
      }

      await _firebaseStorage.collection('favorite').doc(_firebaseAuth.currentUser!.uid).set({'favorites': favoriteIds});
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado completo
    de cryptos
   */

  Future<List<SuggestionModel>> fetchAllCoins() async {
    try {
      final response = await Api.get('https://api.coingecko.com/api/v3/coins/list');

      coinsList = response.map<SuggestionModel>((e) => SuggestionModel.fromMap(e)).toList();

      return coinsList;
    } catch (e) {
      Utils.showSnackBar('Ha ocurrido un error, por favor inténtalo de nuevo.', Colors.red);
      rethrow;
    }
  }

  /* 
    Obtiene listado de cryptos 
    filtradas seleccionadas
   */

  Future<void> getComparedCoins() async {
    final List<CoinModel> coins = await fetchCoins(1, '', [firstSelectedCoin!.id, secondSelectedCoin!.id]);

    _selectedLeftCoin = coins[0];

    _selectedRightCoin = coins[1];

    notifyListeners();
  }
}
