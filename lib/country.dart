class Country {
  final String name;
  final String capital;
  final String language;
  final String flagUrl;
  final double area;
  final int population;
  final String continent;
  final double latitude;
  final double longitude;

  int populationRank = 0;
  int areaRank = 0;

  Country({
    required this.name,
    required this.capital,
    required this.language,
    required this.flagUrl,
    required this.area,
    required this.population,
    required this.continent,
    required this.latitude,
    required this.longitude,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    final name = json['name']?['common'];
    final capitalList = json['capital'];
    final languageMap = json['languages'];
    final flag = json['flags']?['png'];
    final area = json['area'];
    final population = json['population'];
    final continents = json['continents'];

    return Country(
      name: name is String ? name : 'N/A',
      capital: (capitalList is List && capitalList.isNotEmpty && capitalList[0] is String)
          ? capitalList[0]
          : 'N/A',
      language: (languageMap is Map && languageMap.values.isNotEmpty)
          ? languageMap.values.first.toString()
          : 'N/A',
      flagUrl: flag is String ? flag : '',
      area: area is num ? area.toDouble() : 0.0,
      population: population is int ? population : 0,
      continent: (continents is List && continents.isNotEmpty && continents[0] is String)
          ? continents[0]
          : 'N/A',
      latitude: (json['latlng'] is List && json['latlng'].length >= 2)
          ? (json['latlng'][0] as num).toDouble()
          : 0.0,
      longitude: (json['latlng'] is List && json['latlng'].length >= 2)
          ? (json['latlng'][1] as num).toDouble()
          : 0.0,
    );
  }
}
