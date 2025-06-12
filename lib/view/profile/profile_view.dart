import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('assets/lottie/1.json'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'User',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  Text(
                    user?.email ?? '',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(user?.email ?? 'Not set'),
            ),
            ListTile(
              leading: const Icon(Icons.verified_user),
              title: const Text('Email Verified'),
              subtitle: Text(user?.emailVerified == true ? 'Yes' : 'No'),
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Last Sign In'),
              subtitle:
                  Text(user?.metadata.lastSignInTime?.toString() ?? 'Unknown'),
            ),
          ],
        ),
      ),
    );
  }
}
