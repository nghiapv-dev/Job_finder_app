import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../config/theme/app_colors.dart';
import '../../../core/utils/storage_service.dart';
import '../../../core/repositories/auth_repository.dart';
import '../bloc/auth_bloc.dart';
import 'dart:convert';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  State<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dateOfBirthController = TextEditingController();
  final _addressController = TextEditingController();
  final _occupationController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  bool _isLoading = true;
  String? _avatarUrl;
  bool _isUploadingAvatar = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userString = await StorageService.getUser();
      if (userString != null) {
        final userData = json.decode(userString);
        print('📊 User data loaded: $userData'); // Debug log
        
        setState(() {
          // Try both fullName and full_name (backend might use either)
          _fullNameController.text = userData['fullName'] ?? userData['full_name'] ?? '';
          _emailController.text = userData['email'] ?? '';
          // Try both dateOfBirth and date_of_birth
          _dateOfBirthController.text = userData['dateOfBirth'] ?? userData['date_of_birth'] ?? '';
          _addressController.text = userData['address'] ?? '';
          _occupationController.text = userData['occupation'] ?? '';
          // Load avatar URL
          _avatarUrl = userData['avatar_url'];
          _isLoading = false;
        });
      } else {
        print('⚠️ No user data found in storage');
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Lỗi khi tải dữ liệu người dùng: $e');
      // If stored user data is invalid JSON (from older saves), remove it
      try {
        await StorageService.removeUser();
        print('Invalid stored user data removed.');
      } catch (_) {}
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _occupationController.dispose();
    super.dispose();
  }

  Future<void> _handleAvatarUpload() async {
    // Show options: Camera or Gallery
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: AppColors.primary),
              title: const Text('Chụp ảnh'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: AppColors.primary),
              title: const Text('Chọn từ thư viện'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _isUploadingAvatar = true;
        });

        // Upload to server
        final avatarUrl = await _uploadAvatarToServer(image);

        setState(() {
          _avatarUrl = avatarUrl;
          _isUploadingAvatar = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tải ảnh lên thành công!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isUploadingAvatar = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tải ảnh: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String> _uploadAvatarToServer(XFile image) async {
    try {
      final authRepo = AuthRepository();
      final avatarUrl = await authRepo.uploadAvatar(image);
      return avatarUrl;
    } catch (e) {
      throw Exception('Upload failed: $e');
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirthController.text = 
            '${picked.month}/${picked.day}/${picked.year}';
      });
    }
  }

  void _handleConfirm() {
    if (_formKey.currentState!.validate()) {
      // Gửi event cập nhật profile
      context.read<AuthBloc>().add(
        AuthProfileUpdateRequested(
          fullName: _fullNameController.text.trim(),
          dateOfBirth: _dateOfBirthController.text.trim(),
          address: _addressController.text.trim(),
          occupation: _occupationController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(Icons.person, color: Colors.white, size: 16),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Hồ sơ',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthProfileUpdateSuccess) {
            // Cập nhật thành công, chuyển đến home screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cập nhật hồ sơ thành công!'),
                backgroundColor: Colors.green,
              ),
            );
            context.go('/home');
          } else if (state is AuthError) {
            // Hiển thị lỗi
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
              ),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
            key: _formKey,
            child: Column(
              children: [
                // Avatar upload
                GestureDetector(
                  onTap: _isUploadingAvatar ? null : _handleAvatarUpload,
                  child: Stack(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[100],
                          border: Border.all(color: AppColors.primary, width: 2),
                          image: _avatarUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    _avatarUrl!.startsWith('http')
                                        ? _avatarUrl!
                                        : 'http://localhost:5000$_avatarUrl',
                                  ),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: _isUploadingAvatar
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  strokeWidth: 3,
                                ),
                              )
                            : _avatarUrl == null
                                ? Icon(
                                    Icons.person_outline,
                                    size: 50,
                                    color: Colors.grey[400],
                                  )
                                : null,
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tải lên ảnh hồ sơ',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // Full Name
                _buildLabel('Họ và tên*'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _fullNameController,
                  decoration: _buildInputDecoration('Họ và tên'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Họ và tên là bắt buộc';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Email
                _buildLabel('Email*'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _buildInputDecoration('Email')
                      .copyWith(suffixIcon: const Icon(Icons.email_outlined)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email là bắt buộc';
                    }
                    if (!value.contains('@')) {
                      return 'Vui lòng nhập email hợp lệ';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Date of Birth
                _buildLabel('Ngày sinh*'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dateOfBirthController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: _buildInputDecoration('Ngày sinh')
                      .copyWith(suffixIcon: const Icon(Icons.calendar_today_outlined)),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ngày sinh là bắt buộc';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Address
                _buildLabel('Địa chỉ*'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  decoration: _buildInputDecoration('Địa chỉ'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Địa chỉ là bắt buộc';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Occupation
                _buildLabel('Nghề nghiệp*'),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _occupationController,
                  decoration: _buildInputDecoration('Nghề nghiệp'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nghề nghiệp là bắt buộc';
                    }
                    return null;
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Confirm Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _handleConfirm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : const Text(
                                'Xác nhận',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ), // Column
          ), // Form
        ), // SingleChildScrollView
      ), // SafeArea
      ), // BlocListener child
    ); // Scaffold
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: Colors.grey[400],
        fontSize: 14,
      ),
      filled: true,
      fillColor: Colors.grey[50],
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
    );
  }
}

