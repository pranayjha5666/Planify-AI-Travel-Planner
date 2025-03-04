import 'dart:io';
import 'package:ai_travel_planner/Common/widget/custom_button.dart';
import 'package:ai_travel_planner/Components/Screen/About_Me/about_me.dart';
import 'package:ai_travel_planner/Components/Screen/Help_And_Support/help_and_support_screen.dart';
import 'package:ai_travel_planner/Components/Screen/Notification/notification_screen.dart';
import 'package:ai_travel_planner/Components/Screen/Profile/Services/cloudinaryservices.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../Model/profile_model.dart';
import '../Auth/Pages/change_password.dart';
import '../Auth/Pages/login_page.dart';
import 'Services/profile_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileModel? profile;
  final ProfileService _profileService = ProfileService();
  bool isLoading = false;
  XFile? _selectedImage;
  bool isEditing = false;
  late TextEditingController _nameController =
      TextEditingController(text: profile!.name);

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    ProfileModel fetchedProfile = await _profileService.fetchProfileData();
    setState(() {
      profile = fetchedProfile;
    });
  }

  Future<void> _saveProfile() async {
    setState(() {
      isLoading = true;
    });


    if (_selectedImage != null) {
      await CloudinaryService().updateProfileImage(_selectedImage!);
    }
    if (_nameController.text != profile!.name) {
      await CloudinaryService().updateProfile(_nameController.text);
    }

    await loadProfile();

    setState(() {
      isEditing = false;
      isLoading = false;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Profile",
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing:
                isLoading,
            child: profile == null
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                    imageUrl: profile!.profileImage,
                                    placeholder: (context, url) =>
                                        _shimmerEffect(
                                            width: 120, height: 120),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                    imageBuilder: (context, imageProvider) =>
                                        CircleAvatar(
                                          radius: 60,
                                          backgroundImage: _selectedImage !=
                                                  null
                                              ? FileImage(
                                                  File(_selectedImage!.path))
                                              : NetworkImage(
                                                      profile!.profileImage)
                                                  as ImageProvider,
                                        )),
                                if (isEditing)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: GestureDetector(
                                      onTap: _pickImage,
                                      child: Container(
                                        height: 30,
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          color: Colors.black,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          isEditing
                              ? TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Name',
                                  ),
                                )
                              : Text(
                                  profile!.name,
                                  style: const TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                          Text(
                            profile!.email,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            width: double.infinity,
                            text: isEditing ? "Save Profile" : "Edit Profile",
                            buttonColor: Colors.black,
                            textColor: Colors.white,
                            onTap: () {
                              if (isEditing) {
                                _saveProfile();
                              } else {
                                setState(() {
                                  isEditing = true;
                                });
                              }
                            },
                          ),
                          const SizedBox(height: 32),
                          _buildOption(Icons.lock_outline, "Change Password",
                              () {
                                Navigator.pushNamed(
                                  context,
                                  ChangePasswordPage.routeName,
                                );

                          }),
                          _buildOption(
                              Icons.notifications_outlined, "Notifications",
                              () {
                                Navigator.pushNamed(
                                  context,
                                  NotificationScreen.routeName,
                                );
                          }),
                          _buildOption(Icons.help_outline, "Help & Support",
                              () {
                                Navigator.pushNamed(
                                  context,
                                  HelpAndSupportPage.routeName,
                                );
                          }),
                          _buildOption(Icons.info_outline, "About Me", () {
                            Navigator.pushNamed(
                              context,
                              AboutMePage.routeName,
                            );
                          }),
                          _buildOption(Icons.logout, "Logout", () async {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setStringList("notifications", []);

                            FirebaseAuth.instance.signOut();
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              LoginPage.routeName,
                              (route) => false,
                            );
                          }, iconColor: Colors.red),
                        ],
                      ),
                    ),
                  ),
          ),
          if (isLoading)
            Container(
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap,
      {Color? iconColor}) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.black),
          title: Text(
            title,
            style: const TextStyle(
              fontFamily: 'OutFit',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          trailing:
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          onTap: onTap,
        ),
        Divider(color: Colors.grey[300]),
      ],
    );
  }

  Widget _shimmerEffect({required double width, required double height}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
      ),
    );
  }
}
