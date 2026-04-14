import 'package:flutter/material.dart';

import '../../models/user_model.dart';
import '../widgets/loading_button.dart';
import '../widgets/app_text_field.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: _ProfileBody(
        user: const UserModel(
          id: '',
          firstName: 'Guest',
          secondName: '',
          thirdName: '',
          lastName: 'User',
          email: 'guest@app.com',
          userName: 'guest',
          phoneNumber: '',
          nationalId: '',
          birthdate: '2000-01-01T00:00:00Z',
          cityId: 1,
        ),
      ),
    );
  }
}

class _ProfileBody extends StatefulWidget {
  final UserModel user;
  const _ProfileBody({required this.user});

  @override
  State<_ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<_ProfileBody> {
  bool _editing = false;
  final _phoneCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _phoneCtrl.text = widget.user.phoneNumber;
  }

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 48,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Text(
              user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : '?',
              style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            user.fullName,
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(user.email,
              style: const TextStyle(color: Colors.grey)),
          if (user.roleName != null)
            Chip(label: Text(user.roleName!.toUpperCase())),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          _InfoTile(
              icon: Icons.person_outline,
              label: 'Username',
              value: user.userName),
          _InfoTile(
              icon: Icons.badge_outlined,
              label: 'National ID',
              value: user.nationalId),
          _InfoTile(
              icon: Icons.cake_outlined,
              label: 'Birthdate',
              value: user.birthdate.split('T').first),
          const SizedBox(height: 16),
          if (_editing) ...[
            AppTextField(
              controller: _phoneCtrl,
              label: 'Phone Number',
              keyboardType: TextInputType.phone,
              prefixIcon: const Icon(Icons.phone_outlined),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _editing = false),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: LoadingButton(
                    onPressed: () => setState(() => _editing = false),
                    isLoading: false,
                    label: 'Save',
                  ),
                ),
              ],
            ),
          ] else
            OutlinedButton.icon(
              onPressed: () => setState(() => _editing = true),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit Profile'),
            ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _InfoTile(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(label,
              style: const TextStyle(
                  color: Colors.grey, fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(value),
        ],
      ),
    );
  }
}
