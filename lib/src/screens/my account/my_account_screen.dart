import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shopsy/src/base/loading_widget.dart';
import 'package:shopsy/src/controllers/auth_controller.dart';
import 'package:shopsy/src/controllers/image_picker_controller.dart';
import 'package:shopsy/src/firebase/firebase_references.dart';
import 'package:shopsy/src/utils/app_colors.dart';
import 'package:shopsy/src/utils/app_images.dart';
import 'package:shopsy/src/widgets/mytext_widget.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(slivers: [
        SliverAppBar(
          centerTitle: true,
          pinned: true,
          elevation: 0,
          backgroundColor: Colors.white,
          expandedHeight: 150.h,
          flexibleSpace: LayoutBuilder(
            builder: (context, constraints) {
              return FlexibleSpaceBar(
                centerTitle: true,
                title: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: constraints.biggest.height <= 150.h ? 1 : 0,
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Text(
                      "My Account",
                      style: style.headline5,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color.fromARGB(255, 212, 69, 17),
                      AppColors.mainColor,
                    ]),
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h, left: 24.w),
                    child: FutureBuilder(
                      future: userRF.doc(authCurrentUser).get(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (!snapshot.hasData) {
                          return const Loading(
                            isContainer: false,
                          );
                        } else {
                          return Row(
                            children: [
                              //* --- Image Container
                              GetBuilder<ImagePickerController>(
                                  builder: (controller) {
                                return GestureDetector(
                                  onTap: () {
                                    controller.pickerBottomSheet(context);
                                  },
                                  child: Container(
                                    height: 100.h,
                                    width: 100.w,
                                    decoration: snapshot.data['profileImg'] ==
                                            null
                                        ? const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppColors.profilePicContainerBg,
                                            image: DecorationImage(
                                              image: AssetImage(ps5Controller),
                                            ))
                                        : BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                AppColors.profilePicContainerBg,
                                            image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  snapshot.data['profileImg']),
                                            )),
                                  ),
                                );
                              }),
                              Padding(
                                padding: EdgeInsets.only(left: 25.w),
                                child: MyTextWidget(
                                    title: snapshot.data['firstName'],
                                    style: style.headline2
                                        ?.copyWith(color: Colors.white)),
                              )
                            ],
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              Container(
                color: Colors.grey.shade300,
                child: Column(
                  children: [
                    const SizedBox(
                      height: 150,
                      child: Image(image: AssetImage(profileLogo)),
                    ),
                    ProfileHeaderLable(
                      style: style,
                      label: "Account Info.",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 260.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: FutureBuilder<DocumentSnapshot>(
                          future: userRF.doc(authCurrentUser).get(),
                          builder: (BuildContext context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return const SizedBox(
                                width: double.maxFinite,
                                child: Loading(
                                  isContainer: false,
                                ),
                              );
                            } else {
                              return Column(
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.mail),
                                    title: Text("Email Address",
                                        style: style.subtitle2),
                                    subtitle: Text(
                                        snapshot.data!['email'].toString(),
                                        style: style.subtitle1),
                                    trailing: GestureDetector(
                                      onTap: () {
                                        AuthController.instance.verifyEmail();
                                      },
                                      child: snapshot.data!['emailVerfied'] ==
                                              true
                                          ? Text(
                                              "Verified",
                                              style: style.subtitle2?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.green),
                                            )
                                          : Text(
                                              "Not Verified",
                                              style: style.subtitle2?.copyWith(
                                                  fontSize: 12.sp,
                                                  color: Colors.red),
                                            ),
                                    ),
                                  ),
                                  const OrangeDivider(),
                                  ListTile(
                                    leading: const Icon(Icons.phone),
                                    title: Text("Phone No.",
                                        style: style.subtitle2),
                                    subtitle: Text(
                                        snapshot.data!['phoneNumber']
                                            .toString(),
                                        style: style.subtitle1),
                                    trailing: GestureDetector(
                                        onTap: () {
                                          if (authCurrentUserVerifiedMail) {
                                            AuthController.instance
                                                .emailVerified();
                                          } else {
                                            AuthController.instance
                                                .verifyEmail();
                                          }
                                        },
                                        child: Text(
                                          "Not Verified",
                                          style: style.subtitle2?.copyWith(
                                              fontSize: 12.sp,
                                              color: Colors.red),
                                        )),
                                  ),
                                  const OrangeDivider(),
                                  ListTile(
                                    leading: const Icon(Icons.pin_drop),
                                    title:
                                        Text("Address", style: style.subtitle2),
                                    subtitle: Text(
                                        snapshot.data!['address'].toString(),
                                        style: style.subtitle1),
                                  ),
                                ],
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    ProfileHeaderLable(
                      style: style,
                      label: "Account Setting",
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 230.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          children: [
                            AccountSettingListTile(
                                style: style,
                                title: "Edit Profile",
                                icon: Icons.edit,
                                onTap: () {}),
                            const OrangeDivider(),
                            AccountSettingListTile(
                                style: style,
                                title: "Change Password",
                                icon: Icons.password,
                                onTap: () {}),
                            const OrangeDivider(),
                            AccountSettingListTile(
                                style: style,
                                title: "Logout",
                                icon: Icons.logout,
                                onTap: () {
                                  AuthController.instance.signOut();
                                }),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ]),
    );
  }
}

class OrangeDivider extends StatelessWidget {
  const OrangeDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 40.w),
      child: const Divider(
        color: AppColors.mainColor,
        thickness: 1,
      ),
    );
  }
}

class AccountSettingListTile extends StatelessWidget {
  const AccountSettingListTile({
    Key? key,
    required this.style,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final TextTheme style;
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(icon),
        title: Text(title, style: style.subtitle2),
      ),
    );
  }
}

class ProfileHeaderLable extends StatelessWidget {
  const ProfileHeaderLable({
    Key? key,
    required this.style,
    required this.label,
  }) : super(key: key);

  final TextTheme style;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          SizedBox(
            width: 50.w,
            child: const Divider(
              color: AppColors.mainColor,
              thickness: 1,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: MyTextWidget(
              title: label,
              style: style.headline2
                  ?.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(
            width: 50.w,
            child: const Divider(
              color: AppColors.mainColor,
              thickness: 1,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
