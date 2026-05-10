//import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:waitwise/data/models/session_model.dart';

Future<SessionModel> fetchSessionFromN8n({
  required String sessionId,
  required String userId,
  required String context,
  required String mood,
  required int duration,
}) async {
  //await dotenv.load(fileName: '.env');
  const webhookUrl = String.fromEnvironment('WEBHOOK_URL');
  /*const webhookUrl =
      'https://amenkalai23.app.n8n.cloud/webhook-test/7b38731c-d2a7-42c0-bc70-bf311d4b83a6';*/

  final response = await http
      .post(
        Uri.parse(/*dotenv.env['WEBHOOK_URL'] ?? ''*/ webhookUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'session_id': sessionId,
          'user_id': userId,
          'context': context,
          'mood': mood,
          'duration': duration,
        }),
      )
      .timeout(const Duration(seconds: 300)); // add timeout for better UX

  if (response.statusCode == 200) {
    final json = jsonDecode(response.body) as Map<String, dynamic>;
    if (json['id'] == null && json['session_id'] == null) {
      json['session_id'] = sessionId;
    }
    return SessionModel.fromJson(json); // your existing model
  } else {
    throw Exception('n8n workflow failed: ${response.statusCode}');
  }
}
