import 'package:flutter/Material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shopsy/src/utils/app_colors.dart';
import 'package:shopsy/src/utils/app_sizes.dart';

class ProfileImageContainer extends StatelessWidget {
  const ProfileImageContainer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 30.h),
      child: Container(
        height: profilePicContainerHeight,
        width: profilePicContainerWidth,
        decoration: BoxDecoration(
          color: AppColors.profilePicContainerBg,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: -7.w,
              bottom: -7.h,
              child: Container(
                height: profilePicUploadContainerHeight,
                width: profilePicUploadContainerWidth,
                decoration: BoxDecoration(
                  color: AppColors.profilePicUploadContainerBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                child: Center(
                  child: Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.secondaryColor,
                    size: 20.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
