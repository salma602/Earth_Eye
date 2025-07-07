import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:url_launcher/url_launcher.dart';

import 'homescreen.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // Function to get current position
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw Exception("Location services are disabled.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception("Location permissions are permanently denied.");
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
  }

  // Function to get city name from coordinates
  Future<String> _getCityFromCoordinates(Position position) async {
    List<Placemark> placemarks =
    await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      return placemarks.first.locality ?? "Unknown city";
    } else {
      return "No city found";
    }
  }

  // Function to show location on map
  Future<void> showMyCurrentLocationOnMap(BuildContext context) async {
    try {
      Position position = await _getCurrentPosition();
      String city = await _getCityFromCoordinates(position);

      final url =
          'https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}';
      if (await canLaunchUrl(Uri.parse(url))) {
        await launchUrl(Uri.parse(url));
      } else {
        throw "Could not launch map.";
      }

      // Show city name
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("📍 You are in: $city")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF121212),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurpleAccent,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/moon.png',
                  width: 100,
                  height: 100,
                  fit: BoxFit.contain,
                ),
                const Text(
                  'EARTHEYE',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.location_on_outlined, color: Colors.white),
            title: const Text(
              'Show my location',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () async {
              await showMyCurrentLocationOnMap(context);
            },
          ),

          ListTile(
              leading: const Icon(Icons.stacked_bar_chart, color: Colors.white),
              title: const Text(
                'Ranking by area',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);

                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.7,
                    maxChildSize: 0.95,
                    minChildSize: 0.5,
                    builder: (context, scrollController) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "Countries Ranked by Area",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: byArea.length,
                              itemBuilder: (context, index) {
                                final country = byArea[index];
                                return Card(
                                  color: Colors.deepPurple.shade400,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(country.flagUrl),
                                    ),
                                    title: Text(
                                      "${country.name}",
                                      style: const TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      "Area: ${country.area} km²\nRank: ${country.areaRank}",
                                      style: const TextStyle(color: Colors.white70,fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

          ),

          ListTile(
              leading: const Icon(Icons.group, color: Colors.white),
              title: const Text(
                'Ranking by Population',
                style: TextStyle(color: Colors.white, fontSize: 22),
              ),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.black,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (context) => DraggableScrollableSheet(
                    expand: false,
                    initialChildSize: 0.7,
                    maxChildSize: 0.95,
                    minChildSize: 0.5,
                    builder: (context, scrollController) => Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "Countries Ranked by Population",
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              controller: scrollController,
                              itemCount: byPopulation.length,
                              itemBuilder: (context, index) {
                                final country = byPopulation[index];
                                return Card(
                                  color: Colors.deepPurple.shade400,
                                  margin: const EdgeInsets.symmetric(vertical: 8),
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(country.flagUrl),
                                    ),
                                    title: Text(
                                      "${country.name}",
                                      style: const TextStyle(color: Colors.white, fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      "Population: ${(country.population)/1000000000} billion\nRank: ${country.populationRank}",
                                      style: const TextStyle(color: Colors.white70,fontSize: 18),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),


          ListTile(
            leading: const Icon(Icons.info, color: Colors.white),
            title: const Text(
              'About Us',
              style: TextStyle(color: Colors.white, fontSize: 22),
            ),
            onTap: () {
              Navigator.pop(context);
              showDialog(
                context: context,
                builder: (context) => Theme(
                  data: Theme.of(context).copyWith(
                    dialogTheme: DialogThemeData(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.white, width: 2),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                  child: AlertDialog(
                    title: const Text(
                      "🌍 About EARTHEYE",
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                    content: const Text(
                      "EarthEye is an app to explore countries visually and informatively.",
                      style: TextStyle(color: Colors.white, fontSize: 22),
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          "Close",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
