import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import '../services/firebase_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService _firebaseService = FirebaseService();

  final List<String> deviceIcons = [
    'lib/icons/HouseTempture.png',
    'lib/icons/IChouse.png',
    'lib/icons/Lights.png',
    'lib/icons/Chicken.png',
    'lib/icons/WaterOnPlants.png',
  ];

  final List<String> deviceNames = [
    'Temperature',
    ' ',
    '',
    'Chickens',
    ' ',
  ];

  final List<String> iconsWithButton = [
    'lib/icons/IChouse.png',
    'lib/icons/Lights.png',
    'lib/icons/WaterOnPlants.png',
  ];

  // Device states synchronized with Firebase
  Map<String, bool> deviceStates = {
    'lib/icons/IChouse.png': false,
    'lib/icons/Lights.png': false,
    'lib/icons/WaterOnPlants.png': false,
  };

  // Mode automatique pour tous les appareils contrôlables
  Map<String, bool> autoModeStates = {
    'lib/icons/IChouse.png': false,
    'lib/icons/Lights.png': false,  // Ajout du mode auto pour les lumières
    'lib/icons/WaterOnPlants.png': false,
  };

  // Sensor data
  double? temperature;
  double? humidity;
  double? distance; // Ajout de la variable distance
  bool movement = false;
  bool isConnected = false;

  final Color mainColor = const Color(0xFFFE5D26);

  @override
  void initState() {
    super.initState();
    _initializeFirebaseConnection();
    _listenToFirebaseChanges();
  }

  // Initialize Firebase connection and retrieve initial data
  void _initializeFirebaseConnection() async {
    try {
      final data = await _firebaseService.getSensorData();
      if (data != null) {
        setState(() {
          temperature = double.tryParse(data['temperature']?.toString() ?? '0');
          humidity = double.tryParse(data['humidity']?.toString() ?? '0');
          distance = 500 - (double.tryParse(data['distance']?.toString() ?? '0') ?? 0);
          // Ajout de la distance
          movement = data['mouvement'] == 1;
          deviceStates['lib/icons/Lights.png'] = data['led'] == 1;
          deviceStates['lib/icons/IChouse.png'] = data['airConditioner'] == 1;
          deviceStates['lib/icons/WaterOnPlants.png'] = data['irrigation'] == 1;
          autoModeStates['lib/icons/IChouse.png'] = data['airConditionerAuto'] == 1;
          autoModeStates['lib/icons/Lights.png'] = data['lightAuto'] == 1;  // Récupération du mode auto LED
          autoModeStates['lib/icons/WaterOnPlants.png'] = data['irrigationAuto'] == 1;
          isConnected = true;
        });
      }
    } catch (e) {
      print('Initialization error: $e');
      setState(() {
        isConnected = false;
      });
    }
  }

  // Listen to real-time changes
  void _listenToFirebaseChanges() {
    _firebaseService.listenToSensorData().listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        final data = Map<String, dynamic>.from(event.snapshot.value as Map);
        setState(() {
          temperature = double.tryParse(data['temperature']?.toString() ?? '0');
          humidity = double.tryParse(data['humidity']?.toString() ?? '0');
          distance = double.tryParse(data['distance']?.toString() ?? '0'); // Ajout de la distance
          movement = data['mouvement'] == 1;
          deviceStates['lib/icons/Lights.png'] = data['led'] == 1;
          deviceStates['lib/icons/IChouse.png'] = data['airConditioner'] == 1;
          deviceStates['lib/icons/WaterOnPlants.png'] = data['irrigation'] == 1;
          autoModeStates['lib/icons/IChouse.png'] = data['airConditionerAuto'] == 1;
          autoModeStates['lib/icons/Lights.png'] = data['lightAuto'] == 1;  // Écoute du mode auto LED
          autoModeStates['lib/icons/WaterOnPlants.png'] = data['irrigationAuto'] == 1;
          isConnected = true;
        });
      }
    }, onError: (error) {
      print('Firebase connection error: $error');
      setState(() {
        isConnected = false;
      });
    });
  }

  // Control devices via Firebase
  void _controlDevice(String iconPath, bool newState) async {
    try {
      if (iconPath == 'lib/icons/Lights.png') {
        await _firebaseService.controlLed(newState);
      } else if (iconPath == 'lib/icons/IChouse.png') {
        await _firebaseService.controlAirConditioner(newState);
      } else if (iconPath == 'lib/icons/WaterOnPlants.png') {
        await _firebaseService.controlIrrigation(newState);
      }

      // State will be automatically updated via the listener
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${_getDeviceName(iconPath)} ${newState ? 'activated' : 'deactivated'}'),
          backgroundColor: mainColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Unable to control device'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  // Control automatic mode
  void _controlAutoMode(String iconPath, bool newState) async {
    try {
      if (iconPath == 'lib/icons/IChouse.png') {
        await _firebaseService.controlAirConditionerAuto(newState);
      } else if (iconPath == 'lib/icons/Lights.png') {
        // Ajout du contrôle automatique pour les LED
        await _firebaseService.controlLightAuto(newState);
      } else if (iconPath == 'lib/icons/WaterOnPlants.png') {
        await _firebaseService.controlIrrigationAuto(newState);
      }

      // State will be automatically updated via the listener
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Auto mode ${_getDeviceName(iconPath)} ${newState ? 'activated' : 'deactivated'}'),
          backgroundColor: mainColor,
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: Unable to control automatic mode'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  String _getDeviceName(String iconPath) {
    final index = deviceIcons.indexOf(iconPath);
    return index != -1 ? deviceNames[index] : 'Device';
  }

  @override
  Widget build(BuildContext context) {
    final devicesWithButton = <int>[];
    final devicesWithoutButton = <int>[];

    for (int i = 0; i < deviceIcons.length; i++) {
      if (iconsWithButton.contains(deviceIcons[i])) {
        devicesWithButton.add(i);
      } else {
        devicesWithoutButton.add(i);
      }
    }

    final orderedIndices = [...devicesWithButton, ...devicesWithoutButton];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with connection indicator
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderButton('lib/icons/chickenOnTheHouse.png'),
                  Row(
                    children: [
                      // Connection indicator
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isConnected ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              isConnected ? Icons.wifi : Icons.wifi_off,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              isConnected ? 'Connected' : 'Disconnected',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildHeaderButton(null, icon: Icons.person_rounded),
                    ],
                  ),
                ],
              ),
            ),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome Home!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Control your smart Chicken House.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Sensor data display
                  if (isConnected) ...[
                    Row(
                      children: [
                        _buildSensorCard('Temp', '${temperature?.toStringAsFixed(1) ?? '--'}°C', Icons.thermostat),
                        const SizedBox(width: 12),
                        _buildSensorCard('Humid', '${humidity?.toStringAsFixed(1) ?? '--'}%', Icons.water_drop),
                        const SizedBox(width: 12),
                        _buildSensorCard('Water Level', '${distance?.toStringAsFixed(1) ?? '--'} ml',Icons.waves), // Remplacé Motion par Distance
                      ],
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Device Controls
            Expanded(
              child: ListView.builder(
                itemCount: deviceIcons.length,
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final deviceIndex = orderedIndices[index];
                  final iconPath = deviceIcons[deviceIndex];
                  final hasButton = iconsWithButton.contains(iconPath);
                  final isOn = deviceStates[iconPath] ?? false;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      color: isOn ? mainColor.withOpacity(0.3) : Colors.grey[900],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOn ? mainColor : Colors.grey.shade800,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              iconPath,
                              height: 36,
                              color: mainColor,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.device_unknown, color: mainColor, size: 36);
                              },
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  deviceNames[deviceIndex],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if (deviceIndex == 0 && temperature != null) // Temperature
                                  Text(
                                    '${temperature!.toStringAsFixed(1)}°C',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),

                        if (hasButton)
                          Row(
                            children: [
                              // Mode automatique pour tous les appareils contrôlables
                              Text(
                                autoModeStates[iconPath] ?? false ? 'AUTO' : 'MANUAL',
                                style: TextStyle(
                                  color: autoModeStates[iconPath] ?? false ? mainColor : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                activeColor: mainColor,
                                value: autoModeStates[iconPath] ?? false,
                                onChanged: isConnected ? (val) {
                                  _controlAutoMode(iconPath, val);
                                } : null,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                isOn ? 'ON' : 'OFF',
                                style: TextStyle(
                                  color: isOn ? mainColor : Colors.white70,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Switch(
                                activeColor: mainColor,
                                value: isOn,
                                onChanged: (isConnected && !(autoModeStates[iconPath] ?? false)) ? (val) {
                                  _controlDevice(iconPath, val);
                                } : null,
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: () {
                              // Show sensor details
                              _showSensorDetails(deviceIndex);
                            },
                            child: Text(
                              'See Details',
                              style: TextStyle(color: mainColor),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderButton(String? assetPath, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: assetPath != null
          ? Image.asset(
        assetPath,
        height: 28,
        color: Colors.white,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.home, size: 28, color: Colors.white);
        },
      )
          : Icon(icon, size: 28, color: Colors.white),
    );
  }

  Widget _buildSensorCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: mainColor, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 10,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSensorDetails(int deviceIndex) {
    String title = deviceNames[deviceIndex];
    String content = '';

    switch (deviceIndex) {
      case 0: // Temperature
        content = 'Current temperature: ${temperature?.toStringAsFixed(1) ?? '--'}°C\n'
            'Humidity: ${humidity?.toStringAsFixed(1) ?? '--'}%';
        break;
      case 3: // Chickens
        content = 'Chickens State:\n'
            'Temperature: ${temperature?.toStringAsFixed(1) ?? '--'}°C\n'
            'Humidity: ${humidity?.toStringAsFixed(1) ?? '--'}%\n'
            'Distance: ${distance?.toStringAsFixed(1) ?? '--'} cm\n' // Ajout de la distance dans les détails
            'Movement detected: ${movement ? 'Yes' : 'No'}';
        break;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(title, style: const TextStyle(color: Colors.white)),
        content: Text(content, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close', style: TextStyle(color: mainColor)),
          ),
        ],
      ),
    );
  }
}