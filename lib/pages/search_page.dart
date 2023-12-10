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
            child: Text("Выберите контент, который вы хотите добавить"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("data"),
          ),
          const SizedBox(height: 100)
        ],
      ),
    );
  }
}
