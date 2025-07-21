import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:springr/utils/constants.dart';
import '../../../providers/profile_provider.dart';
import '../../../services/token_storage.dart';

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
  bool _isDataInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfile();
    });
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isDataInitialized = false;
    });
    final token = await TokenStorage.getToken();
    if (token != null && mounted) {
      await context.read<ProfileProvider>().getMyProfile(token);
    }
  }

  Future<void> _submitProfile() async {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // Logic create hoặc update
      final provider = context.read<ProfileProvider>();
      final token = await TokenStorage.getToken();
      if (token == null) return;

      final success = provider.profile != null
          ? await provider.updateProfile(
              token: token,
              fullName: _fullNameController.text.trim(),
              bio: _bioController.text.trim(),
              address: _addressController.text.trim(),
            )
          : await provider.createProfile(
              token: token,
              fullName: _fullNameController.text.trim(),
              bio: _bioController.text.trim(),
              address: _addressController.text.trim(),
            );

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.profile != null
                ? 'Profile updated successfully!'
                : 'Profile created successfully!'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();

    if (profileProvider.profile != null && !_isDataInitialized) {
      _fullNameController.text = profileProvider.profile!.fullName;
      _bioController.text = profileProvider.profile!.bio ?? '';
      _addressController.text = profileProvider.profile!.address ?? '';
      _isDataInitialized = true;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: heading2,),
        centerTitle: true,
        // Chỉnh màu AppBar thủ công
        backgroundColor: myColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: _loadProfile,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _buildBody(profileProvider),
    );
  }

  Widget _buildBody(ProfileProvider profileProvider) {
    if (profileProvider.isLoading && !_isDataInitialized) {
      return Center(child: CircularProgressIndicator(color: const Color.fromARGB(255, 166, 172, 166)));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 32),
            if (profileProvider.errorMessage != null) ...[
              _buildErrorWidget(profileProvider.errorMessage!),
              const SizedBox(height: 16),
            ],
            _buildTextField(
              controller: _fullNameController,
              labelText: 'Full Name',
              hintText: 'Enter your full name',
              prefixIcon: Icons.person_outline,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _bioController,
              labelText: 'Bio',
              hintText: 'Tell us about yourself',
              prefixIcon: Icons.info_outline,
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            _buildTextField(
              controller: _addressController,
              labelText: 'Address',
              hintText: 'Enter your address',
              prefixIcon: Icons.location_on_outlined,
            ),
            const SizedBox(height: 32),
            _buildSubmitButton(profileProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatarSection() {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          // Chỉnh màu Avatar thủ công
          backgroundColor: Colors.green[100],
          child: Icon(Icons.person, size: 50, color: Colors.green[800]),
        ),
        const SizedBox(height: 8),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.camera_alt, size: 18),
          label: const Text('Change Photo'),
          // Chỉnh màu TextButton thủ công
          style: TextButton.styleFrom(foregroundColor: Colors.green[800]),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
    required IconData prefixIcon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      style: smallTextStyle,
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: Icon(prefixIcon),
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        // Chỉnh màu viền khi focus
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: const Color.fromARGB(255, 93, 187, 98), width: 2),
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildSubmitButton(ProfileProvider profileProvider) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: profileProvider.isLoading
            ? Container(
                width: 24,
                height: 24,
                padding: const EdgeInsets.all(2.0),
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              )
            : const Icon(Icons.save),
        label: Text(
          profileProvider.profile != null ? 'Save Changes' : 'Create Profile',
        ),
        onPressed: profileProvider.isLoading ? null : _submitProfile,
        // Chỉnh màu ElevatedButton thủ công
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red.shade700),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w500),
            ),
          ),
        ],
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