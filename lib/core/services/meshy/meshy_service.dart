import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;

class MeshyService {
  static const String _baseUrl = 'https://api.meshy.ai';
  static const String _apiKey =
      'msy_SuZbXieiFCZBHeJTDqUduFOlRjkHmFlHanVa';

  static Future<String?> generateDesignImage({
    required String imageUrl,
    required String prompt,
    int maxPollingSeconds = 120,
  }) async {
    try {
      final taskId = await _createTask(imageUrl: imageUrl, prompt: prompt);
      if (taskId == null) return null;

      return await _pollTask(taskId, maxPollingSeconds: maxPollingSeconds);
    } catch (e) {
      print('MeshyService error: $e');
      return null;
    }
  }

  static Future<String?> _createTask({
    required String imageUrl,
    required String prompt,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/openapi/v1/image-to-image'),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'ai_model': 'nano-banana-2',
        'prompt': prompt,
        'reference_image_urls': [imageUrl],
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 202) {
      final data = jsonDecode(response.body);
      return data['result'] as String?;
    }

    print('Meshy create task error: ${response.statusCode} ${response.body}');
    return null;
  }

  static Future<String?> _pollTask(
    String taskId, {
    int maxPollingSeconds = 120,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    final start = DateTime.now();
    final deadline = start.add(Duration(seconds: maxPollingSeconds));

    while (DateTime.now().isBefore(deadline)) {
      final response = await http.get(
        Uri.parse('$_baseUrl/openapi/v1/image-to-image/$taskId'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final status = data['status'] as String?;

        if (status == 'SUCCEEDED') {
          final images = data['image_urls'] as List?;
          if (images != null && images.isNotEmpty) {
            return images[0].toString();
          }
          return null;
        }

        if (status == 'FAILED' || status == 'CANCELED') {
          print('Meshy task $status: $taskId');
          return null;
        }
      }

      await Future.delayed(const Duration(seconds: 3));
    }

    print('Meshy polling timed out for task: $taskId');
    return null;
  }
}
