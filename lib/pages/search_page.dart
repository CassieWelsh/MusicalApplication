import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: const Text("Account"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
            child: Text("Выберите трек, который хотите добавить"),
          ),
          TextButton(
            onPressed: () async {
              final files = await FilePicker.platform.pickFiles(
                  type: FileType.custom, allowedExtensions: const ['mp3']);
              print(files!.files.single.path.toString());
            },
            child: const Text("123123"),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
