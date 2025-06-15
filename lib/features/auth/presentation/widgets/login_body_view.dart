import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:moodtracker_app/core/utils/constants/logo_assets.dart';
import 'package:moodtracker_app/core/helper/shared_keys.dart';
import 'package:moodtracker_app/core/helper/shared_prefrence.dart';
import 'package:moodtracker_app/core/utils/app_colors.dart';
import 'package:moodtracker_app/core/utils/constant.dart';
import 'package:moodtracker_app/core/widgets/custem_text_feild.dart';
import 'package:moodtracker_app/core/widgets/custem_text_widget.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:moodtracker_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/auth_btn_custom.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/dividor_or.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/dont_have_account.dart';
import 'package:moodtracker_app/features/auth/presentation/widgets/main_login_widget.dart';
import 'package:moodtracker_app/features/home/Presentation/main_view.dart';

class LoginViewBody extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: KhorizontalPadding),
      child: SingleChildScrollView(
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
            if (state is AuthSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Login successful!')),
              );
              if (LocalDataCore.getData(key: SharedKey.isLogin) == true) {
                print('Navigating to MainView...');
              } else {
                LocalDataCore.setData(key: SharedKey.isLogin, value: true);
                print('Setting isLogin to true and navigating to MainView...');
              }
              Navigator.pushNamedAndRemoveUntil(context, MainView.routeName,(route) => false,);
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                const SizedBox(height: KhorizontalPadding),

                CustemTextFormFeild(
                  hintText: "Email",
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

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CustomText(
                      text: "Forgot Password?",
                      color: AppColors.primary.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                CustemButtom(
                  widget:
                      state is AuthLoading
                          ? LoadingAnimationWidget.staggeredDotsWave(
                              color: Colors.white,
                              size: 22,
                            )
                          : CustomText(
                            text: "Login",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                  color: AppColors.primary,
                  onPressed: () {
                    final email = emailController.text.trim();
                    final password = passwordController.text.trim();
                    if (email.isEmpty || password.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: AppColors.primary,
                          content: CustomText(
                            text: 'Please fill all fields',
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                      return;
                    }
                    context.read<AuthCubit>().login(
                      email: email,
                      password: password,
                    );
                  },
                ),

                const SizedBox(height: 32),

                const DontHaveAccount(),

                const SizedBox(height: 40),

                const OrDividor(),

                const SizedBox(height: 30),

                AuthCustomBtn(
                  text: "Login with Google",
                  image: Assets.assetsIconsGoogle,
                  onPressed: () {},
                ),

                const SizedBox(height: 20),

                AuthCustomBtn(
                  text: "Login with Facebook",
                  image: Assets.assetsIconsFacebook,
                  onPressed: () {},
                ),

                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }
}
