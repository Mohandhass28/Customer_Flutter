import 'package:customer/domain/profile/entities/customer_details_params.dart';
import 'package:customer/presentation/profile/pages/user_details/bloc/profile_bloc.dart';
import 'package:customer/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:customer/core/config/theme/app_color.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class UserDetailsPage extends StatefulWidget {
  const UserDetailsPage({super.key});

  @override
  State<UserDetailsPage> createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  late ProfileBloc _profileBloc;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController =
      TextEditingController(text: '28/04/2025');
  String? _selectedGender;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];

  @override
  void initState() {
    super.initState();
    _profileBloc = sl<ProfileBloc>()..add(GetProfileEvent());
    _nameController.text = '';
    _emailController.text = '';
    _phoneController.text = '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColor.primaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  void _updateProfile() {
    _profileBloc.add(
      UpdateProfileEvent(
        params: CustomerDetailsParams(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          dob: _dobController.text,
          gender: _selectedGender ?? '',
        ),
        context: context,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(),
        ),
        title: Text(
          "Your Profile",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocProvider.value(
        value: _profileBloc,
        child: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state.status == ProfileStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.errorMessage ?? 'Unknown error',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  backgroundColor: Colors.red,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  duration: Duration(seconds: 3),
                ),
              );
            }
            if (state.status == ProfileStatus.success) {
              _nameController.text = state.customerDetails?.data.name ?? '';
              _emailController.text = state.customerDetails?.data.email ?? '';
              _phoneController.text = state.customerDetails?.data.phone ?? '';
              final dob = state.customerDetails?.data.dob;
              debugPrint("dob: $dob");
              if (dob != null) {
                _dobController.text = DateFormat('dd/MM/yyyy').format(
                  DateTime.parse(dob),
                );
              }
              _selectedGender = state.customerDetails?.data.gender;
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Picture
                    Center(
                      child: Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: AppColor.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          Positioned(
                            bottom: 2,
                            left: 2,
                            child: Container(
                              width: 45,
                              height: 45,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: IconButton(
                                  icon: Icon(Icons.camera_alt_outlined),
                                  color: AppColor.primaryColor,
                                  onPressed: () {
                                    openBottomSheet();
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32),

                    // Name Field
                    _buildFieldLabel('Name'),
                    _buildTextField(_nameController, 'Enter your name'),

                    SizedBox(height: 16),

                    // Email Field
                    _buildFieldLabel('Email ID'),
                    _buildTextField(
                      _emailController,
                      'Enter your email',
                    ),

                    SizedBox(height: 16),

                    // Phone Field
                    _buildFieldLabel('Phone Number'),
                    _buildTextField(
                      _phoneController,
                      'Enter your phone number',
                    ),

                    SizedBox(height: 16),

                    // Date of Birth Field
                    _buildFieldLabel('Date of Birth'),
                    _buildDateField(),

                    SizedBox(height: 16),

                    // Gender Field
                    _buildFieldLabel('Gender'),
                    _buildDropdownField(),

                    SizedBox(height: 32),

                    // Update Profile Button
                    _buildUpdateButton(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint,
      {Widget? suffixWidget}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
          suffixIcon: suffixWidget,
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return TextButton(
      onPressed: () {
        // Implement save logic for individual field
      },
      child: Text(
        'Save',
        style: TextStyle(
          color: AppColor.primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        controller: _dobController,
        readOnly: true,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: InputBorder.none,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.grey),
            onPressed: () => _selectDate(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          border: InputBorder.none,
          hintText: 'Select item',
          hintStyle: TextStyle(color: Colors.grey[400]),
        ),
        icon: Icon(Icons.keyboard_arrow_down),
        items: _genderOptions.map((String gender) {
          return DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedGender = newValue;
          });
        },
      ),
    );
  }

  Widget _buildUpdateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _updateProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          'Update Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  void openBottomSheet() {
    void openCamera() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
    }

    void openGallery() async {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    }

    void openImageModel() {
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 1.0,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            expand: false,
            builder: (context, scrollController) {
              return Container(
                color: Colors.black.withOpacity(0.7),
                child: Stack(
                  children: [
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          minHeight: 400,
                          minWidth: 400,
                        ),
                        height: 400,
                        width: 400,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/Ordalane.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 50,
                      right: 20,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    }

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          minChildSize: 0.2,
          maxChildSize: 0.6,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              padding: EdgeInsets.all(16),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  ListTile(
                    style: ListTileStyle.list,
                    trailing: Icon(
                      Icons.remove_red_eye_outlined,
                      size: 26,
                    ),
                    title: Text(
                      'View profile photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openImageModel();
                      // Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.list,
                    trailing: Icon(
                      Icons.image_outlined,
                      size: 26,
                    ),
                    title: Text(
                      'Upload from gallery',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openGallery();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.list,
                    trailing: Icon(
                      Icons.camera_alt_outlined,
                      size: 26,
                    ),
                    title: Text(
                      'Take photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      openCamera();
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    style: ListTileStyle.list,
                    trailing: Icon(
                      Icons.delete_outline,
                      size: 26,
                      color: Colors.red,
                    ),
                    title: Text(
                      'Delete photo',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onTap: () {
                      // Implement photo capture logic
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
