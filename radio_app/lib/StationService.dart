import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:radio_app/Station.dart';

class StationService {
  final Dio _dio;
  // Server URL at which we will be connecting to retrieve the stations data.
  static final String _baseUrl = 'https://de1.api.radio-browser.info';
  // Extended URL with the root to the country list in the server.
  static final String _stationsByCountryCode =
      '$_baseUrl/json/stations/bycountrycodeexact/';

  // Constructor of this class.
  StationService(this._dio) {
    // Add an interceptor with the server url.
    _dio.interceptors
        .add(DioCacheManager(CacheConfig(baseUrl: _baseUrl)).interceptor);
  }

  // Method that givena country code and the amount of radios to get, returns a list of n radio stations from that country.
  // @param countryCode String the code from the country from which we want to obtain the list of radio stations.
  // @param offset int from which radio station we start retrieving the list.
  // @param maxRadios int the amount of radio stations to obtain.
  // @return A list of radio stations.
  Future<List<Station>> getRadioStationsByCountry(
      String countryCode, int offset, int maxRadios) async {
    // Full URL to get the radio stations from a country.
    final String stationsByCountryCodeUrl =
        _stationsByCountryCode + countryCode;
    final String validURL =
        _getValidHttpURL(stationsByCountryCodeUrl, offset, maxRadios);
    // HTTP response info in JSON format.
    final Response stationsData = await _dio.get(
      validURL,
    );

    // Map the JSON raw data to a list of Stations.
    final List<Station> stations = (stationsData.data as List)
        .map((data) => Station(data['url_resolved'], data['favicon'],
            data['name'], data['country'], data['language']))
        .toList();
    // Returns a future completed with a list of stations.
    return Future.value(stations);
  }

  // Method that given an URL and the offset and the maximum amount of radios to obtain, generates a valid URL for the HHTP request sorted by popularity.
  String _getValidHttpURL(String url, int offset, int maxRadios) {
    return '$url?hidebroken=true&order=clickcount&reverse=true&offset=$offset&limit=$maxRadios';
  }
}
