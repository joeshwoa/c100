import 'dart:convert';

import 'package:c100/comment_model';
import 'package:flutter/material.dart';
import 'post_model.dart';
import 'package:http/http.dart' as http;

class PostScreen extends StatefulWidget {
  final PostModel post;
  const PostScreen({super.key, required this.post});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final List<CommentModel> _comments = [];

  String base = 'https://jsonplaceholder.typicode.com/';

  bool loading = true;
  bool loadingMore = false;

  ScrollController controller = ScrollController();

  int page = 1;
  int totalPage = 3;

  Future<void> _fetchComments({int p = 1}) async {
    if (totalPage < p) return;
    setState(() {
      loadingMore = true;
    });

    final res = await http.get(
      Uri.parse('${base}posts/${widget.post.id}/comments?page=$p'),
    );
    final resJson = json.decode(res.body);

    for (final e in resJson) {
      _comments.add(CommentModel.fromJson(e));
    }

    setState(() {
      page = p;
      loadingMore = false;
      loading = false;
    });
  }

  Future<void> _refreshComments() async {
    setState(() {
      _comments.clear();
      page = 1;
      loading = true;
    });
    await _fetchComments();
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      if (controller.position.pixels == controller.position.maxScrollExtent) {
        _fetchComments(p: page + 1);
      }
    });
    _fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Details'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refreshComments,
              child: ListView(
                controller: controller,
                padding: const EdgeInsets.all(16.0),
                children: [
                  // Post Content
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.post.title,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            widget.post.body,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'User: ${widget.post.userId}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                              const Spacer(),
                              Text(
                                'Post ID: ${widget.post.id}',
                                style: Theme.of(context).textTheme.labelMedium
                                    ?.copyWith(color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Comments Section Header
                  Text(
                    'Comments',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Comments List
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 32),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            child: Text(
                              comment.name.toUpperCase(),
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  comment.email!,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[800],
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  comment.name!,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[600],
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  comment.body!,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  if(loadingMore)
                    const Center(child: CircularProgressIndicator())
                ],
              ),
            ),
    );
  }
}
