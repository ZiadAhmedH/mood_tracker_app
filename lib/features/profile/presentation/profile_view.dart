import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/widgets/profile_body_view.dart';

class ProfileView extends StatelessWidget {
  
  static const String routeName = "/profile";

  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: CustomText(
          text: "Your profile",
          color: AppColors.black,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => sl<ProfileCubit>()..loadUserProfile(),
        child: ProfileBodyView(),
      ),
    );
  }
}
