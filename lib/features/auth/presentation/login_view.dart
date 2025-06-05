import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/get_it.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/custem_app_bar.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/login_body_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});
  static const String routeName = '/login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context, title: "Login", showLeading: false),
      body: BlocProvider(
        create: (context) => sl<AuthCubit>(),
        child: LoginViewBody(),
      ),
    );
  }
}
