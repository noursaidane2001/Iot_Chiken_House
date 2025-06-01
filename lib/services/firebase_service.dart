import 'package:firebase_database/firebase_database.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Écouter les changements de données en temps réel
  Stream<DatabaseEvent> listenToSensorData() {
    return _database.onValue;
  }

  // Obtenir les données des capteurs
  Future<Map<String, dynamic>?> getSensorData() async {
    try {
      final snapshot = await _database.get();
      if (snapshot.exists) {
        return Map<String, dynamic>.from(snapshot.value as Map);
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
      return null;
    }
  }

  // Contrôler la LED
  Future<void> controlLed(bool isOn) async {
    try {
      await _database.child('led').set(isOn ? 1 : 0);
      print('LED ${isOn ? 'allumée' : 'éteinte'}');
    } catch (e) {
      print('Erreur lors du contrôle de la LED: $e');
    }
  }

  // Contrôler la climatisation
  Future<void> controlAirConditioner(bool isOn) async {
    try {
      // Vous pouvez ajouter un nouveau nœud pour la climatisation
      await _database.child('airConditioner').set(isOn ? 1 : 0);
      print('Climatisation ${isOn ? 'activée' : 'désactivée'}');
    } catch (e) {
      print('Erreur lors du contrôle de la climatisation: $e');
    }
  }
  // Add this method to your FirebaseService class in firebase_service.dart

  Future<void> controlLightAuto(bool state) async {
    try {
      await _database.child('lightAuto').set(state ? 1 : 0);
    } catch (e) {
      throw Exception('Failed to control light auto mode: $e');
    }
  }

  // Contrôler le mode automatique de la climatisation
  Future<void> controlAirConditionerAuto(bool isAuto) async {
    try {
      await _database.child('airConditionerAuto').set(isAuto ? 1 : 0);
      print('Mode automatique de la climatisation ${isAuto ? 'activé' : 'désactivé'}');
    } catch (e) {
      print('Erreur lors du contrôle du mode automatique de la climatisation: $e');
    }
  }

  // Contrôler l'irrigation
  Future<void> controlIrrigation(bool isOn) async {
    try {
      await _database.child('irrigation').set(isOn ? 1 : 0);
      print('Irrigation ${isOn ? 'activée' : 'désactivée'}');
    } catch (e) {
      print('Erreur lors du contrôle de l\'irrigation: $e');
    }
  }

  // Contrôler le mode automatique de l'irrigation
  Future<void> controlIrrigationAuto(bool isAuto) async {
    try {
      await _database.child('irrigationAuto').set(isAuto ? 1 : 0);
      print('Mode automatique de l\'irrigation ${isAuto ? 'activé' : 'désactivé'}');
    } catch (e) {
      print('Erreur lors du contrôle du mode automatique de l\'irrigation: $e');
    }
  }

  // Obtenir la température
  Future<double?> getTemperature() async {
    try {
      final snapshot = await _database.child('temperature').get();
      if (snapshot.exists) {
        return double.tryParse(snapshot.value.toString());
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de la température: $e');
      return null;
    }
  }

  // Obtenir l'humidité
  Future<double?> getHumidity() async {
    try {
      final snapshot = await _database.child('humidity').get();
      if (snapshot.exists) {
        return double.tryParse(snapshot.value.toString());
      }
      return null;
    } catch (e) {
      print('Erreur lors de la récupération de l\'humidité: $e');
      return null;
    }
  }

  // Obtenir l'état du mouvement
  Future<bool> getMovementStatus() async {
    try {
      final snapshot = await _database.child('mouvement').get();
      if (snapshot.exists) {
        return snapshot.value == 1;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la récupération du statut de mouvement: $e');
      return false;
    }
  }

  // Obtenir l'état de la LED
  Future<bool> getLedStatus() async {
    try {
      final snapshot = await _database.child('led').get();
      if (snapshot.exists) {
        return snapshot.value == 1;
      }
      return false;
    } catch (e) {
      print('Erreur lors de la récupération du statut LED: $e');
      return false;
    }
  }
}