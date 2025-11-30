import 'dart:convert';

import 'package:c100/add_post.dart';
import 'package:c100/post_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'post_model.dart';

Future<void> main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<PostModel> _posts = [];
  bool loading = true;
  TextEditingController _controller = TextEditingController();

  String base = 'https://jsonplaceholder.typicode.com/';

  Future<void> _fetchPosts({int? id}) async {

    setState(() {
      loading = true;
      _posts.clear();
    });

    final res = await http.get(Uri.parse("${base}posts/${id ?? ''}"));
    final resJson = json.decode(res.body);

    if(id == null) {
      for (final e in resJson) {
      _posts.add(PostModel.fromJson(e));
    }
    } else {
      _posts.add(PostModel.fromJson(resJson));
    }

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    _fetchPosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(onPressed: _fetchPosts, icon: const Icon(Icons.refresh))
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Row(
                children: [
                  Expanded(child: TextFormField(
                    controller: _controller,
                  ),
                  ),
                  IconButton.filled(onPressed: () => _fetchPosts(id: int.tryParse(_controller.text)), icon: const Icon(Icons.search))
                ],
              ),
              Expanded(child: ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreen(post: post))),
                  child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          post.body,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'User ID: ${post.userId}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Post ID: ${post.id}',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                );
              },
            )) 
            ],
          ),
      floatingActionButton: FloatingActionButton(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AddPost())), child: const Icon(Icons.add)),
    );
  }
}
