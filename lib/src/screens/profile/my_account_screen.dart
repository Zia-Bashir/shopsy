import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopsy/src/screens/profile/components/profile_image_container.dart';
import 'package:shopsy/src/utils/app_text.dart';
import 'package:shopsy/src/widgets/mytext_widget.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var style = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* Text
            Padding(
              padding: EdgeInsets.only(top: 20.h),
              child: MyTextWidget(title: tProfileTitle, style: style.headline5),
            ),

            //* Image Container

            const ProfileImageContainer(),

            //* Account Data Text Fields
          ],
        ),
      ),
    );
  }
}
