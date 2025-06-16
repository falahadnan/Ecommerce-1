import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers (تقدر تعمرهم بالبيانات ديال المستخدم من Service)
  final _nameController = TextEditingController(text: "Ahmed El Khattabi");
  final _emailController = TextEditingController(text: "ahmed@example.com");
  final _phoneController = TextEditingController(text: "+212 612 345 678");
  final _addressController = TextEditingController(text: "Casablanca, Maroc");
  DateTime? _birthDate = DateTime(1994, 3, 12);

  Future<void> _selectBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // هنا دير الاتصال مع Service ولا API باش تسيفط البيانات
      print("Nom: ${_nameController.text}");
      print("Email: ${_emailController.text}");
      print("Téléphone: ${_phoneController.text}");
      print("Adresse: ${_addressController.text}");
      print("Date de naissance: $_birthDate");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profil mis à jour avec succès")),
      );

      Navigator.pop(context); // ترجع للصفحة السابقة
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier le profil")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nom complet"),
                validator: (value) => value!.isEmpty ? "Nom obligatoire" : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "Email"),
                validator: (value) =>
                    value!.isEmpty ? "Email obligatoire" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "Téléphone"),
                validator: (value) =>
                    value!.isEmpty ? "Téléphone obligatoire" : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "Adresse"),
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text(
                  _birthDate != null
                      ? "Né le: ${_birthDate!.toLocal().toString().split(' ')[0]}"
                      : "Sélectionner la date de naissance",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: _selectBirthDate,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: const Text("Enregistrer"),
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
