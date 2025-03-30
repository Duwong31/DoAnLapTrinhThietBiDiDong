import 'package:flutter/material.dart';

class PersonalEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {s
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Save',
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/avatar.png'), // Thay bằng ảnh của bạn
              backgroundColor: Colors.blue,
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: () {},
              child: Text(
                'Change photo',
                style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Phong Hoàng',
                border: UnderlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
