import 'package:flutter/material.dart';
import '../models/profile_model.dart';
import '../services/api_service.dart';

class ProfileProvider with ChangeNotifier {
  ProfileModel? _profile;
  bool _isLoading = false;
  String? _errorMessage;

  ProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _setProfile(ProfileModel? profile) {
    _profile = profile;
    notifyListeners();
  }

  /// Create a new profile
  Future<bool> createProfile({
    required String token,
    required String fullName,
    String? bio,
    String? avatar,
    String? address,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await ApiService.createProfile(
        token: token,
        fullName: fullName,
        bio: bio,
        avatar: avatar,
        address: address,
      );

      if (response.status && response.data != null) {
        _setProfile(response.data);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Get current user's profile
  Future<bool> getMyProfile(String token) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await ApiService.getMyProfile(token);

      if (response.status && response.data != null) {
        _setProfile(response.data);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Update current user's profile
  Future<bool> updateProfile({
    required String token,
    String? fullName,
    String? bio,
    String? avatar,
    String? address,
  }) async {
    _setLoading(true);
    _setError(null);

    try {
      final response = await ApiService.updateProfile(
        token: token,
        fullName: fullName,
        bio: bio,
        avatar: avatar,
        address: address,
      );

      if (response.status && response.data != null) {
        _setProfile(response.data);
        return true;
      } else {
        _setError(response.message);
        return false;
      }
    } catch (e) {
      _setError('An unexpected error occurred');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  /// Clear profile data (for logout)
  void clearProfile() {
    _profile = null;
    _errorMessage = null;
    notifyListeners();
  }
}
