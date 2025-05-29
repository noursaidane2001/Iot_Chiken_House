import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> deviceIcons = [
    'lib/icons/HouseTempture.png',
    'lib/icons/IChouse.png',
    'lib/icons/Lights.png',
    'lib/icons/Plants.png',
    'lib/icons/WaterOnPlants.png',
  ];

  final List<String> deviceNames = [
    'Temperature',
    'Air Conditioning',
    'Lights',
    'Garden Plants',
    'Irrigation',
  ];

  final List<String> iconsWithButton = [
    'lib/icons/IChouse.png',
    'lib/icons/Lights.png',
  ];

  final Map<String, bool> deviceStates = {
    'lib/icons/HouseTempture.png': false,
    'lib/icons/IChouse.png': true,
    'lib/icons/Lights.png': false,
  };

  final Color mainColor = const Color(0xFFFE5D26);

  @override
  Widget build(BuildContext context) {
    // Séparer les indices des devices avec bouton et sans bouton
    final devicesWithButton = <int>[];
    final devicesWithoutButton = <int>[];

    for (int i = 0; i < deviceIcons.length; i++) {
      if (iconsWithButton.contains(deviceIcons[i])) {
        devicesWithButton.add(i);
      } else {
        devicesWithoutButton.add(i);
      }
    }

    // Nouvelle liste combinée : d'abord ceux avec bouton, puis les autres
    final orderedIndices = [...devicesWithButton, ...devicesWithoutButton];

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildHeaderButton('lib/icons/chickenOnTheHouse.png'),
                  _buildHeaderButton(null, icon: Icons.person_rounded),
                ],
              ),
            ),

            // Welcome Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Home!',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Control your smart Chikens House .',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),

            // Device Controls
            Expanded(
              child: ListView.builder(
                itemCount: deviceIcons.length,
                padding: EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final deviceIndex = orderedIndices[index];
                  final iconPath = deviceIcons[deviceIndex];
                  final hasButton = iconsWithButton.contains(iconPath);
                  final isOn = deviceStates[iconPath] ?? false;

                  return Container(
                    margin: EdgeInsets.only(bottom: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                        // Icon + Device Name
                        Row(
                          children: [
                            Image.asset(
                              iconPath,
                              height: 36,
                              color: mainColor,
                            ),
                            SizedBox(width: 12),
                            Text(
                              deviceNames[deviceIndex],
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        // ON/OFF + Switch ou See Details
                        if (hasButton)
                          Row(
                            children: [
                              SizedBox(width: 8),
                              Switch(
                                activeColor: mainColor,
                                value: isOn,
                                onChanged: (val) {
                                  setState(() {
                                    deviceStates[iconPath] = val;
                                  });
                                },
                              ),
                            ],
                          )
                        else
                          Text(
                            'See Details',
                            style: TextStyle(color: mainColor),
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
      padding: EdgeInsets.all(12),
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
      )
          : Icon(icon, size: 28, color: Colors.white),
    );
  }
}
