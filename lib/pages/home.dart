import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final tracks = FirebaseFirestore.instance.collection('track');

  HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
          future: tracks.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              var a = snapshot.data!.docs.toList();
              return ListView.builder(
                  itemCount: a.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemBuilder: (context, ind) {
                    var item = a[ind];
                    return ListTile(
                      title: Text(item.id),
                      subtitle: Text(item.data().toString()),
                    );
                  });
            }

            return Text("loading");
          },
        ),
      ],
    );
  }
}
