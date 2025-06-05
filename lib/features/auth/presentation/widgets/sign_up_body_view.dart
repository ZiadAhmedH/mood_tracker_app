import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/utils/constant.dart';
import 'package:moodtracker_app/core/widgets/custem_text_feild.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/main_login_widget.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/terms_widget.dart';

class SignUpViewBody extends StatelessWidget {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

   SignUpViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );
          Navigator.pop(context); 
        } else if (state is AuthError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: KhorizontalPadding),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: KhorizontalPadding),

                CustemTextFormFeild(
                  hintText: "Full name",
                  controller: fullNameController,
                  iconData: Icons.abc_outlined,
                  isPassword: false,
                  textInputType: TextInputType.name,
                ),

                const SizedBox(height: 20),

                CustemTextFormFeild(
                  hintText: "Email Address",
                  controller: emailController,
                  iconData: Icons.email_outlined,
                  isPassword: false,
                  textInputType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                CustemTextFormFeild(
                  hintText: "Password",
                  controller: passwordController,
                  iconData: Icons.remove_red_eye,
                  isPassword: true,
                  textInputType: TextInputType.visiblePassword,
                ),

                const SizedBox(height: 16),

                const TermsAndConditionsWidget(),

                const SizedBox(height: 20),

                CustemButtom(
                  widget:
                      state is AuthLoading
                          ? CircularProgressIndicator(color: AppColors.gray,)
                          : CustomText(
                            text: "Create Account",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                  color: AppColors.primary,
                  onPressed: () {
                    final fullName = fullNameController.text.trim();
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();

                    if (fullName.isEmpty || email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please fill all fields')),
                      );
                      return;
                    }

                    context.read<AuthCubit>().signUp(
                      email: email,
                      password: password,
                      fullName: fullName,
                    );
                  },
                ),

                const SizedBox(height: 20),

                Text.rich(
                  TextSpan(
                    text: "Already have an account?",
                    style: const TextStyle(
                      color: AppColors.gray1,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: " Sign In",
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        recognizer:
                            TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pop(context);
                              },
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
