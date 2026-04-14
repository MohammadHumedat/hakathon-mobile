import '../models/city_model.dart';

class PalestineCities {
  static final List<CityModel> all = [
    const CityModel(id: 1, name: 'Hebron'),
    const CityModel(id: 2, name: 'Jerusalem'),
    const CityModel(id: 3, name: 'Ramallah'),
    const CityModel(id: 4, name: 'Nablus'),
    const CityModel(id: 5, name: 'Bethlehem'),
    const CityModel(id: 6, name: 'Jenin'),
    const CityModel(id: 7, name: 'Tulkarm'),
    const CityModel(id: 8, name: 'Qalqilya'),
    const CityModel(id: 9, name: 'Salfit'),
    const CityModel(id: 10, name: 'Tubas'),
    const CityModel(id: 11, name: 'Jericho'),
    const CityModel(id: 12, name: 'Gaza'),
    const CityModel(id: 13, name: 'Khan Yunis'),
    const CityModel(id: 14, name: 'Rafah'),
    const CityModel(id: 15, name: 'Deir al-Balah'),
    const CityModel(id: 16, name: 'North Gaza'),
  ];

  static final CityModel defaultCity = all.first; // Hebron
}
