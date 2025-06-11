import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_cubit.dart';
import 'package:moodtracker_app/features/profile/presentation/cubits/profile_state.dart';

class ProfileBodyView extends StatelessWidget {
  const ProfileBodyView({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            final user = state.user;
            print( 'user profile loaded: ${user.fullName}, ${user.email}');
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const CircleAvatar(
                    radius: 64,
                    child: Icon(
                      Icons.person,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    user.fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold , color: Colors.black),
                  ),
                  Text(user.email, style: TextStyle(color: Colors.grey[700])),
                  const SizedBox(height: 16),
                  buildButton('View Statistics', Icons.bar_chart, const Color(0xFF9616FF)),
                  const SizedBox(height: 16),
                  buildSettingOption('App Language', 'English', null, 50),
                  const SizedBox(height: 16),
                  buildSettingOption('Dark Theme', null, Switch(value: false, onChanged: (_) {}), 50),
                  const SizedBox(height: 16),
                  buildSettingOption('Allow Notifications', null, Switch(value: true, onChanged: (_) {}), 50),
                  const Spacer(),
                  buildButton('Logout', null, const Color(0xFFFF0000)),
                  const SizedBox(height: 10),
                ],
              ),
            );
          } else if (state is ProfileError) {
            return Center(child: Text(state.message));
          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        },
    );
  }

  Widget buildButton(String text, IconData? icon, Color color) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: const Size(double.infinity, 70),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) Icon(icon, color: Colors.white),
          if (icon != null) const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 18)),
        ],
      ),
    );
  }

  Widget buildSettingOption(String title, String? value, Widget? trailing, double height) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],  
      ), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          trailing ?? Text(value ?? '', style: const TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
