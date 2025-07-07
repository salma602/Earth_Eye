import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'Drawer.dart';
import 'country.dart';
import 'package:url_launcher/url_launcher.dart';


List<Country> byArea = [];
List<Country> byPopulation = [];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Country> countries = [];
  Country? selectedCountry;
  bool isLoading = true;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  Future<void> fetchCountries() async {
    try {
      final response = await http.get(Uri.parse(
          "https://restcountries.com/v3.1/all?fields=name,capital,languages,population,flags,area,continents,latlng"));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        countries = data.map((e) => Country.fromJson(e)).toList();

        countries.sort((a, b) => a.name.compareTo(b.name));

        byPopulation = [...countries]..sort((a, b) => b.population.compareTo(a.population));
        byArea = [...countries]..sort((a, b) => b.area.compareTo(a.area));

        for (var country in countries) {
          country.populationRank = byPopulation.indexOf(country) + 1;
          country.areaRank = byArea.indexOf(country) + 1;
        }

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = "Failed to load countries.";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  Future<void> showCountryLocation(double lat, double lng, String name) async {
    final Uri mapUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    if (await canLaunchUrl(mapUrl)) {
      await launchUrl(mapUrl, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch map for $name';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0x80424242),
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("\ud83c\udf0c EARTHEYE", style: TextStyle(color: Colors.white, fontSize: 24)),
        centerTitle: true,
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: const MyDrawer(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage, style: const TextStyle(color: Colors.red)))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownSearch<Country>(
              items: countries,
              itemAsString: (Country c) => c.name,
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Select Country",
                  labelStyle: TextStyle(color: Colors.white, fontSize: 20),
                  border: OutlineInputBorder(),
                ),
              ),
              popupProps: PopupProps.menu(
                showSearchBox: false,
                itemBuilder: (context, country, isSelected) => Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  color: isSelected ? Colors.grey[700] : Colors.grey[900],
                  child: Text(
                    country.name,
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),
              dropdownBuilder: (context, selectedItem) {
                return Text(
                  selectedItem?.name ?? "Select Country",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
              onChanged: (value) {
                setState(() {
                  selectedCountry = value;
                });
              },
            ),
            if (selectedCountry != null) ...[
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      selectedCountry!.flagUrl,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 30),
                  Row(
                    children: [
                      const Icon(Icons.location_pin, color: Colors.indigo, size: 40),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Capital", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400)),
                          const SizedBox(height: 4),
                          Text(selectedCountry!.capital,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.public, color: Colors.indigo, size: 50),
                      const SizedBox(width: 8),
                      Text(
                        selectedCountry!.continent,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Icon(Icons.translate, color: Colors.indigo, size: 50),
                      const SizedBox(width: 8),
                      const Text("Language", style: TextStyle(fontWeight: FontWeight.w400, fontSize: 22)),
                      const SizedBox(width: 4),
                      Text(
                        selectedCountry!.language,
                        style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.map, color: Colors.indigo, size: 50),
                          const SizedBox(width: 8),
                          const Text("Area", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                          const SizedBox(width: 8),
                          Text("${selectedCountry!.area} km²",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                        ],
                      ),
                      Text("Rank #${selectedCountry!.areaRank}",
                          style: const TextStyle(color: Colors.red, fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 45),
                  Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.group, color: Colors.indigo, size: 50),
                          const SizedBox(width: 8),
                          const Text("Population",
                              style:
                              TextStyle(fontSize: 22, fontWeight: FontWeight.w400)),
                          const SizedBox(width: 8),
                          Text("${(selectedCountry!.population) / 1000000000} bn",
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                        ],
                      ),
                      Text("Rank #${selectedCountry!.populationRank}",
                          style: const TextStyle(color: Colors.red, fontSize: 22)),
                    ],
                  ),
                  const SizedBox(height: 70),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(40),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      if (selectedCountry != null) {
                        showCountryLocation(
                          selectedCountry!.latitude,
                          selectedCountry!.longitude,
                          selectedCountry!.name,
                        );
                      }
                    },
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.location_pin, color: Colors.indigo, size: 40),
                          SizedBox(width: 20),
                          Text("Show Location on Map",
                              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
