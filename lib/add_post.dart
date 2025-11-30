import 'dart:convert';

import 'package:c100/post_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPost extends StatefulWidget {
  const AddPost({super.key});

  @override
  State<AddPost> createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  TextEditingController title = TextEditingController();
  TextEditingController body = TextEditingController();

  String base = 'https://jsonplaceholder.typicode.com/';

  bool sending = false;

  Future<void> _addPost() async {
    if (sending) return;

    try {

      setState(() {
      sending = true;
    });

    final res = await http.post(
      Uri.parse("${base}posts"),
      body: {"title": title.text, "body": body.text},
      headers: {"Auth": "bablablabla"},
    );

    if (res.statusCode >= 200 && res.statusCode < 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Post added successfully'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add post'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }

    
    
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to add post'),
          backgroundColor: Colors.redAccent,
        ),
      );
    } finally {
      setState(() {
      sending = false;
    });
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: title,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: body,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Body',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _addPost, child: sending ? const CircularProgressIndicator() : const Text('Add Post')),
          ],
        ),
      ),
    );
  }
}
