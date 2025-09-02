import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/show.dart';

class TvMazeApiService {
  static const baseUrl = 'https://api.tvmaze.com';

  Future<List<Show>> fetchShows() async {
    final response = await http.get(Uri.parse('$baseUrl/shows'));
    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      List<Show> shows = body.map((dynamic item) => Show.fromJson(item)).toList();
      return shows;
    } else {
      throw Exception('Failed to load shows');
    }
  }
}
