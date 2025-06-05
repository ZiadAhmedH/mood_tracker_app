import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/custem_app_bar.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/sign_up_body_view.dart';

class SignUpView extends StatelessWidget {
  const SignUpView({super.key});

  static const String routeName = '/signUp';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(
        context,
        title: "New Mood Account",
        showLeading: true,
      ),

      backgroundColor: Colors.white,

      body: BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: SignUpViewBody(),
      ),
    );
  }
}
