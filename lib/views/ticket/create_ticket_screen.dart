import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/constants.dart';
import '../../models/city_model.dart';
import '../../models/enums.dart';
import '../../services/api_service.dart';
import '../../services/city_service.dart';
import '../../view_model/cubit/ticket_cubit.dart';
import '../widgets/app_text_field.dart';
import '../widgets/loading_button.dart';

class CreateTicketScreen extends StatefulWidget {
  const CreateTicketScreen({super.key});

  @override
  State<CreateTicketScreen> createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descCtrl = TextEditingController();
  final _imageUrlCtrl = TextEditingController();
  final _latCtrl = TextEditingController();
  final _lngCtrl = TextEditingController();

  Sector _sector = Sector.infrastructure;
  Priority _priority = Priority.low;
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a city')),
      );
      return;
    }
    context.read<TicketCubit>().createTicket(
      cityId: _selectedCity!.id,
      description: _descCtrl.text.trim(),
      latitude: double.parse(_latCtrl.text.trim()),
      longitude: double.parse(_lngCtrl.text.trim()),
      sector: _sector,
      priority: _priority,
      imageUrl: _imageUrlCtrl.text.trim().isEmpty ? null : _imageUrlCtrl.text.trim(),
    );
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    _imageUrlCtrl.dispose();
    _latCtrl.dispose();
    _lngCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Ticket')),
      body: BlocConsumer<TicketCubit, TicketState>(
        listener: (context, state) {
          if (state is TicketSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is TicketError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppTextField(
                    controller: _descCtrl,
                    label: 'Description',
                    maxLines: 4,
                    validator: (v) =>
                        v == null || v.isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    controller: _imageUrlCtrl,
                    label: 'Image URL (optional)',
                    keyboardType: TextInputType.url,
                    prefixIcon: const Icon(Icons.image_outlined),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _latCtrl,
                          label: 'Latitude',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          controller: _lngCtrl,
                          label: 'Longitude',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true, signed: true),
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (double.tryParse(v) == null) return 'Invalid';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
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
                  DropdownButtonFormField<Sector>(
                    value: _sector,
                    decoration: InputDecoration(
                      labelText: 'Sector',
                      prefixIcon: const Icon(Icons.category_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: Sector.values
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _sector = v!),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<Priority>(
                    value: _priority,
                    decoration: InputDecoration(
                      labelText: 'Priority',
                      prefixIcon: const Icon(Icons.flag_outlined),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    items: Priority.values
                        .map((p) => DropdownMenuItem(
                              value: p,
                              child: Text(p.name.toUpperCase()),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _priority = v!),
                  ),
                  const SizedBox(height: 32),
                  LoadingButton(
                    onPressed: _submit,
                    isLoading: state is TicketLoading,
                    label: 'Submit Ticket',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
