import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/app_router.dart';
import '../../models/city_model.dart';
import '../../services/city_service.dart';
import '../../services/api_service.dart';
import '../../core/constants.dart';
import '../../view_model/cubit/auth_cubit.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _secondNameCtrl = TextEditingController();
  final _thirdNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _userNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _nationalIdCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  DateTime? _birthdate;
  CityModel? _selectedCity;
  List<CityModel> _cities = [];
  bool _loadingCities = true;

  @override
  void initState() {
    super.initState();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await CityService(
        api: ApiService(baseUrl: AppConstants.baseUrl),
      ).getCities();
      if (mounted) setState(() { _cities = cities; _loadingCities = false; });
    } catch (_) {
      if (mounted) setState(() => _loadingCities = false);
    }
  }

  Future<void> _pickBirthdate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
    );
    if (picked != null) setState(() => _birthdate = picked);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_birthdate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your birthdate')),
      );
      return;
    }
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select your city')),
      );
      return;
    }
    context.read<AuthCubit>().register(
      firstName: _firstNameCtrl.text.trim(),
      secondName: _secondNameCtrl.text.trim(),
      thirdName: _thirdNameCtrl.text.trim(),
      lastName: _lastNameCtrl.text.trim(),
      userName: _userNameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phoneNumber: _phoneCtrl.text.trim(),
      nationalId: _nationalIdCtrl.text.trim(),
      password: _passwordCtrl.text,
      birthdate: _birthdate!.toIso8601String(),
      cityId: _selectedCity!.id,
    );
  }

  @override
  void dispose() {
    for (final c in [
      _firstNameCtrl, _secondNameCtrl, _thirdNameCtrl, _lastNameCtrl,
      _userNameCtrl, _emailCtrl, _phoneCtrl, _nationalIdCtrl, _passwordCtrl,
    ]) { c.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, AppRouter.home);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRow(
                    AppTextField(controller: _firstNameCtrl, label: 'First Name',
                        validator: _required),
                    AppTextField(controller: _secondNameCtrl, label: 'Second Name',
                        validator: _required),
                  ),
                  const SizedBox(height: 12),
                  _buildRow(
                    AppTextField(controller: _thirdNameCtrl, label: 'Third Name',
                        validator: _required),
                    AppTextField(controller: _lastNameCtrl, label: 'Last Name',
                        validator: _required),
                  ),
                  const SizedBox(height: 12),
                  AppTextField(controller: _userNameCtrl, label: 'Username',
                      prefixIcon: const Icon(Icons.person_outline),
                      validator: _required),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _emailCtrl,
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _phoneCtrl,
                    label: 'Phone Number',
                    keyboardType: TextInputType.phone,
                    prefixIcon: const Icon(Icons.phone_outlined),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _nationalIdCtrl,
                    label: 'National ID',
                    prefixIcon: const Icon(Icons.badge_outlined),
                    validator: _required,
                  ),
                  const SizedBox(height: 12),
                  // Birthdate picker
                  InkWell(
                    onTap: _pickBirthdate,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: 'Birthdate',
                        prefixIcon: const Icon(Icons.cake_outlined),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        _birthdate == null
                            ? 'Select birthdate'
                            : '${_birthdate!.year}-${_birthdate!.month.toString().padLeft(2, '0')}-${_birthdate!.day.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: _birthdate == null ? Colors.grey : null,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // City dropdown
                  _loadingCities
                      ? const LinearProgressIndicator()
                      : DropdownButtonFormField<CityModel>(
                          value: _selectedCity,
                          decoration: InputDecoration(
                            labelText: 'City',
                            prefixIcon: const Icon(Icons.location_city_outlined),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _cities
                              .map((c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _selectedCity = v),
                        ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _passwordCtrl,
                    label: 'Password',
                    obscureText: _obscurePassword,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) =>
                        v == null || v.length < 8 ? 'Min 8 characters' : null,
                  ),
                  const SizedBox(height: 32),
                  LoadingButton(
                    onPressed: _submit,
                    isLoading: state is AuthLoading,
                    label: 'Create Account',
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Sign In'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRow(Widget a, Widget b) => Row(
        children: [
          Expanded(child: a),
          const SizedBox(width: 12),
          Expanded(child: b),
        ],
      );

  String? _required(String? v) =>
      v == null || v.isEmpty ? 'Required' : null;
}
