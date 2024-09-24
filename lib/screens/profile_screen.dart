import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/material.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/images/client4.png'),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Alexa Burgaj',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Add functionality to view account details
                    },
                    child: const Text(
                      'Shiko Detajet e Llogarisë',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildProfileOption(
              context: context,
              title: 'Kërkesat e Mia',
              subtitle: 'Shiko dhe menaxho kërkesat e tua për shërbimet e ofruara',
              onTap: () {
                // Navigate to the user's requests screen
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Metodat e Pagesës',
              subtitle: 'Shto, modifiko, ose hiq opsionet e pagesave',
              onTap: () {
                // Navigate to the payment methods screen
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Vlerësimet dhe komentet',
              subtitle: 'Shiko vlerësimet që ke dhënë',
              onTap: () {
                // Navigate to reviews and ratings screen
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Konfigurimet e Njoftimeve',
              subtitle: 'Menaxho preferencat e njoftimeve',
              onTap: () {
                // Navigate to notifications settings
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Promocionet dhe Zbritjet',
              subtitle: 'Shiko zbritjet dhe ofertat e disponueshme',
              onTap: () {
                // Navigate to promotions screen
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Fto nje shok',
              subtitle: 'Ndaj kodin tënd të referimit dhe perfito 10 euro duke ftuar nje profesionist',
              onTap: () {
                // Navigate to invite friends screen
              },
            ),
            _buildProfileOption(
              context: context,
              title: 'Kerko ndihme',
              subtitle: 'Merr ndihmë ose kontakto per cdo paqartesi apo informacion',
              onTap: () {
                // Navigate to support screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption({
    required BuildContext context,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16, 
              color: AppColors.grey700,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.grey500,
            ),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppColors.grey700,
          ),
          onTap: onTap,
        ),
      ],
    );
  }
}
