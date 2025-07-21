import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/profile_model.dart';
import '../models/post_model.dart';
import '../models/api_response.dart';
import 'config.dart';

class ApiService {
  static String get baseUrl => url; // Using the URL from config.dart

  // Headers for authenticated requests
  static Map<String, String> _getAuthHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // PROFILE API METHODS

  /// Create a new profile
  static Future<ApiResponse<ProfileModel>> createProfile({
    required String token,
    required String fullName,
    String? bio,
    String? avatar,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}profile'),
        headers: _getAuthHeaders(token),
        body: jsonEncode({
          'fullName': fullName,
          'bio': bio,
          'avatar': avatar,
          'address': address,
        }),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == true) {
        return ApiResponse.success(
          ProfileModel.fromJson(data['profile']),
          data['message'],
        );
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to create profile');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Get current user's profile
  static Future<ApiResponse<ProfileModel>> getMyProfile(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}profile/me'),
        headers: _getAuthHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return ApiResponse.success(ProfileModel.fromJson(data['profile']));
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Update current user's profile
  static Future<ApiResponse<ProfileModel>> updateProfile({
    required String token,
    String? fullName,
    String? bio,
    String? avatar,
    String? address,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      if (fullName != null) updateData['fullName'] = fullName;
      if (bio != null) updateData['bio'] = bio;
      if (avatar != null) updateData['avatar'] = avatar;
      if (address != null) updateData['address'] = address;

      final response = await http.put(
        Uri.parse('${baseUrl}profile'),
        headers: _getAuthHeaders(token),
        body: jsonEncode(updateData),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return ApiResponse.success(
          ProfileModel.fromJson(data['profile']),
          data['message'],
        );
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  // POST API METHODS

  /// Create a new post
  static Future<ApiResponse<PostModel>> createPost({
    required String token,
    required String title,
    required String content,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${baseUrl}posts'),
        headers: _getAuthHeaders(token),
        body: jsonEncode({'title': title, 'content': content}),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201 && data['status'] == true) {
        return ApiResponse.success(
          PostModel.fromJson(data['post']),
          data['message'],
        );
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to create post');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Get current user's posts
  static Future<ApiResponse<List<PostModel>>> getMyPosts(String token) async {
    try {
      final response = await http.get(
        Uri.parse('${baseUrl}posts/me'),
        headers: _getAuthHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        List<PostModel> posts = (data['posts'] as List)
            .map((post) => PostModel.fromJson(post))
            .toList();
        return ApiResponse.success(posts);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to get posts');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Update a post
  static Future<ApiResponse<PostModel>> updatePost({
    required String token,
    required String postId,
    String? title,
    String? content,
  }) async {
    try {
      Map<String, dynamic> updateData = {};
      if (title != null) updateData['title'] = title;
      if (content != null) updateData['content'] = content;

      final response = await http.put(
        Uri.parse('${baseUrl}posts/$postId'),
        headers: _getAuthHeaders(token),
        body: jsonEncode(updateData),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return ApiResponse.success(
          PostModel.fromJson(data['post']),
          data['message'],
        );
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to update post');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }

  /// Delete a post
  static Future<ApiResponse<void>> deletePost({
    required String token,
    required String postId,
  }) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}posts/$postId'),
        headers: _getAuthHeaders(token),
      );

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['status'] == true) {
        return ApiResponse.success(null, data['message']);
      } else {
        return ApiResponse.error(data['message'] ?? 'Failed to delete post');
      }
    } catch (e) {
      return ApiResponse.error('Network error: $e');
    }
  }
}
