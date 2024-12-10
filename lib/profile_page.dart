import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  TextEditingController nameController = TextEditingController();
  File? _image; // Menyimpan gambar yang dipilih

  // Fungsi untuk memilih gambar
  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Gambar Profil
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 60,
              backgroundImage: _image != null
                  ? FileImage(_image!) // Menampilkan gambar yang dipilih
                  : AssetImage('assets/default_avatar.png') as ImageProvider,
              child: _image == null
                  ? Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.white,
                    )
                  : null, // Menampilkan ikon kamera jika belum ada gambar
            ),
          ),
          SizedBox(height: 20),
          
          // Nama Profil
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Nama',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 20),

          // Tombol Simpan
          ElevatedButton(
            onPressed: () {
              String name = nameController.text;
              if (name.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Profil berhasil disimpan!'),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Harap masukkan nama!'),
                  ),
                );
              }
            },
            child: Text('Simpan Profil'),
          ),
        ],
      ),
    );
  }
}
