import 'package:flutter/foundation.dart';

class LikedPetsProvider with ChangeNotifier {
  List<Map<String, String>> _likedPets = [];

  List<Map<String, String>> get likedPets => _likedPets;

  void addPet(Map<String, String> pet) {
    _likedPets.add(pet);
    notifyListeners();
  }

  void removePet(Map<String, String> pet) {
    _likedPets.remove(pet);
    notifyListeners();
  }
}
