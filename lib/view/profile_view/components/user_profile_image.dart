import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../res/components/app_cached_network_image.dart';
import '../../../res/components/custom_text.dart';
import '../../../res/constants/app_colors.dart';
import '../../../services/shared_pref_service.dart';
import '../../../view_model/user_view_model.dart';

class UserProfileImage extends StatefulWidget {
  const UserProfileImage({super.key});

  @override
  State<UserProfileImage> createState() => _UserProfileImageState();
}

class _UserProfileImageState extends State<UserProfileImage> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  late String name = '';
  late String mobile = '';
  late String image = '';

  @override
  void initState() {
    super.initState();
    _getUserData();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      userViewModel.getUserApi(context);
    });
  }

  Future<void> _getUserData() async {
    final userData = await SharedPrefService.getPref('user');
    if (userData != null && mounted) {
      setState(() {
        name = userData['name']?.toString() ?? '';
        mobile = userData['mobile']?.toString() ?? '';
        image = userData['image']?.toString() ?? '';
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: source,
      imageQuality: 60,
      maxWidth: 800,
      maxHeight: 800,
    );

    if (pickedFile != null) {
      if (!mounted) return;
      Navigator.pop(context);
      setState(() {
        _image = File(pickedFile.path);
      });
      final userViewModel = Provider.of<UserViewModel>(context, listen: false);
      await userViewModel.editProfileApi(context, imagePath: pickedFile.path);
    }
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.transparentColor,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.secondaryColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withAlpha(40),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              CustomText(
                data: "Select Profile Photo",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),

              const SizedBox(height: 24),

              _buildOption(
                icon: CupertinoIcons.camera,
                label: "Camera",
                onTap: () => _pickImage(ImageSource.camera),
              ),
              SizedBox(height: 16),
              _buildOption(
                icon: CupertinoIcons.photo,
                label: "Gallery",
                onTap: () => _pickImage(ImageSource.gallery),
              ),

              const SizedBox(height: 10),

              Divider(color: AppColors.coolGrayColor),

              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.crimsonRedColor.withAlpha(40),
                  ),
                  child: Center(
                    child: CustomText(
                      data: 'Cancel',
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.crimsonRedColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColors.midnightBlueColor.withAlpha(160),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(icon, size: 22, color: AppColors.whiteColor),
            SizedBox(width: 16),
            CustomText(
              data: label,
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppColors.whiteColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        final user = userViewModel.user;
        final displayName =
            user?.name ?? (name.isNotEmpty ? name : 'Your Account');
        final displayMobile = user?.mobile ?? (mobile.isNotEmpty ? mobile : '');
        final displayImage = user?.image ?? image;

        return Center(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: _image != null
                        ? Image.file(
                            _image!,
                            height: 94,
                            width: 94,
                            fit: BoxFit.cover,
                          )
                        : displayImage.isNotEmpty
                        ? AppCachedNetworkImage(
                            imageUrl: displayImage,
                            height: 94,
                            width: 94,
                            fit: BoxFit.cover,
                          )
                        : AppCachedNetworkImage(
                            imageUrl:
                                'https://untitledui.com/images/avatars/olly-schroeder',
                            height: 94,
                            width: 94,
                            fit: BoxFit.cover,
                          ),
                  ),

                  InkWell(
                    onTap: _showImageSourceSheet,
                    borderRadius: BorderRadius.circular(100),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.midnightBlueColor,
                        border: Border.all(
                          color: AppColors.whiteColor.withAlpha(60),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(
                        CupertinoIcons.camera,
                        size: 14,
                        color: AppColors.whiteColor,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              CustomText(
                data: displayName,
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.whiteColor,
              ),
              if (displayMobile.isNotEmpty) ...[
                SizedBox(height: 6),
                CustomText(
                  data: '+91 $displayMobile',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.lightBlueGrayColor,
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
