import 'dart:convert';

import 'package:http/http.dart' as http;

import 'firebase_service.dart';

import '../models/product.dart';
import '../models/auth_token.dart';

class ProbooksService extends FirebaseService {
  ProbooksService([AuthToken? authToken]) : super(authToken);

  Future<List<Probook>> fetchProbooks([bool filterByUser = false]) async {
    final List<Probook> probooks = [];
    try {
      final filters =
          filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
      final probooksUrl =
          Uri.parse('$databaseUrl/probooks.json?auth=$token&$filters');
      final response = await http.get(probooksUrl);
      final probooksMap = json.decode(response.body) as Map<String, dynamic>;

      if (response.statusCode != 200) {
        print(probooksMap['error']);
        return probooks;
      }

      final starBooksUrl =
          Uri.parse('$databaseUrl/starBooks/$userId.json?auth=$token');
      final starBooksResponse = await http.get(starBooksUrl);
      final starBooksMap = json.decode(starBooksResponse.body);

      final comBooksUrl =
          Uri.parse('$databaseUrl/comBooks/$userId.json?auth=$token');
      final comBooksResponse = await http.get(comBooksUrl);
      final comBooksMap = json.decode(comBooksResponse.body);

      probooksMap.forEach((probookId, probook) {
        final isStar =
            (starBooksMap == null) ? false : (starBooksMap[probookId] ?? false);

        final isCompleted =
            (comBooksMap == null) ? false : (comBooksMap[probookId] ?? false);
        probooks.add(
          Probook.fromJson({
            'id': probookId,
            ...probook,
          }).copyWith(isStar: isStar, isCompleted: isCompleted),
        );
      });
      return probooks;
    } catch (error) {
      print(error);
      return probooks;
    }
  }

  Future<Probook?> addProbook(Probook probook) async {
    try {
      final url = Uri.parse('$databaseUrl/probooks.json?auth=$token');
      final response = await http.post(
        url,
        body: json.encode(
          probook.toJson()
            ..addAll({
              'creatorId': userId,
            }),
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return probook.copyWith(
        id: json.decode(response.body)['name'],
      );
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<bool> updateProbook(Probook probook) async {
    try {
      final url =
          Uri.parse('$databaseUrl/probooks/${probook.id}.json?auth=$token');
      final response = await http.patch(
        url,
        body: json.encode(probook.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> deleteProbook(String id) async {
    try {
      final url = Uri.parse('$databaseUrl/probooks/$id.json?auth=$token');
      final response = await http.delete(url);

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveStarStatus(Probook probook) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/starBooks/$userId/${probook.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          probook.isStar,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }

  Future<bool> saveCompletedStatus(Probook probook) async {
    try {
      final url = Uri.parse(
          '$databaseUrl/comBooks/$userId/${probook.id}.json?auth=$token');
      final response = await http.put(
        url,
        body: json.encode(
          probook.isCompleted,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception(json.decode(response.body)['error']);
      }

      return true;
    } catch (error) {
      print(error);
      return false;
    }
  }
}
