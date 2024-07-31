import 'package:flutter/material.dart';
import 'custom_colors.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  color: CustomColors.primaryColor,
                  height: 250,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/images/img3.png'), // Replace with your image asset
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Jhon Abraham',
                            style: TextStyle(
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            '@jhonabraham20',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          const Text(
                            'Personal Information',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          ProfileInfoRow(
                            label: 'First Name',
                            value: 'Jhon',
                          ),
                          ProfileInfoRow(
                            label: 'Last Name',
                            value: 'Abraham',
                          ),
                          ProfileInfoRow(
                            label: 'Email Address',
                            value: 'jhon.abraham@example.com',
                          ),
                          ProfileInfoRow(
                            label: 'Address',
                            value: '123 Street Name, City, Country',
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Account Settings',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          ListTile(
                            leading: Icon(Icons.edit, color: CustomColors.primaryColor),
                            title: const Text('Change password'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                            onTap: () {
                              // Navigate to change password screen
                            },
                          ),
                          SwitchListTile(
                            activeColor: CustomColors.primaryColor,
                            contentPadding: EdgeInsets.zero,
                            title: const Text('Push notifications'),
                            value: true,
                            onChanged: (bool value) {
                              // Handle switch change
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Function(String)? onEdit;

  const ProfileInfoRow({
    required this.label,
    required this.value,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                editProfileInfo(context, label, value, onEdit!);
              },
            ),
        ],
      ),
    );
  }

  void editProfileInfo(BuildContext context, String label, String currentValue, Function(String) onSave) {
    TextEditingController controller = TextEditingController(text: currentValue);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
