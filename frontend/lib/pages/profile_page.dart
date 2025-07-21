import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _bioController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  void _loadProfile() async {
    // Mock token for testing
    const String token = "test_token";
    await context.read<ProfileProvider>().getMyProfile(token);
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      const String token = "test_token";

      final profileProvider = context.read<ProfileProvider>();
      bool success;

      if (profileProvider.profile != null) {
        // Update existing profile
        success = await profileProvider.updateProfile(
          token: token,
          fullName: _fullNameController.text.trim(),
          bio: _bioController.text.trim(),
          address: _addressController.text.trim(),
        );
      } else {
        // Create new profile
        success = await profileProvider.createProfile(
          token: token,
          fullName: _fullNameController.text.trim(),
          bio: _bioController.text.trim(),
          address: _addressController.text.trim(),
        );
      }

      // Show result message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Profile saved successfully!'
                  : 'Failed to save profile: ${profileProvider.errorMessage ?? "Unknown error"}',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(onPressed: _loadProfile, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profileProvider, child) {
          // Pre-fill form if profile exists
          if (profileProvider.profile != null &&
              _fullNameController.text.isEmpty) {
            _fullNameController.text = profileProvider.profile!.fullName;
            _bioController.text = profileProvider.profile!.bio ?? '';
            _addressController.text = profileProvider.profile!.address ?? '';
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Loading indicator
                  if (profileProvider.isLoading)
                    const LinearProgressIndicator(),

                  const SizedBox(height: 16),

                  // Error message
                  if (profileProvider.errorMessage != null)
                    Container(
                      padding: const EdgeInsets.all(12.0),
                      margin: const EdgeInsets.only(bottom: 16.0),
                      decoration: BoxDecoration(
                        color: Colors.red.shade100,
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.red.shade300),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.error, color: Colors.red.shade700),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              profileProvider.errorMessage!,
                              style: TextStyle(color: Colors.red.shade800),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Form fields
                  TextFormField(
                    controller: _fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.info),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Save button
                  ElevatedButton(
                    onPressed: profileProvider.isLoading ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: profileProvider.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(
                            profileProvider.profile != null
                                ? 'Update Profile'
                                : 'Create Profile',
                            style: const TextStyle(fontSize: 16),
                          ),
                  ),

                  const SizedBox(height: 16),

                  // Test button to show notification
                  OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Test notification - Button is working!',
                          ),
                          backgroundColor: Colors.blue,
                        ),
                      );
                    },
                    child: const Text('Test Notification'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _bioController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
