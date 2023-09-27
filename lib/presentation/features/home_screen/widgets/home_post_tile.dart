import 'package:flutter/material.dart';
import 'package:gallery/domain/entities/post.dart';

class HomePostTile extends StatefulWidget {
  final List<PostEntity> posts;

  const HomePostTile(this.posts, {super.key});

  @override
  State<HomePostTile> createState() => _HomePostTileState();
}

class _HomePostTileState extends State<HomePostTile> {
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.posts.length,
      itemBuilder: (context, index) {
        return _buildPostTile(widget.posts[index]);
      },
    );
  }

  Widget _buildPostTile(PostEntity post) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image
          Container(
            height: 200,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(post.imageBytesData),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.all(Radius.circular(15))
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 3, top: 10),
            child: Text(
              post.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
  
          // Caption
          Padding(
            padding: const EdgeInsets.only(left: 3, top: 10),
            child: Text(
              post.caption,
              style: const TextStyle(fontSize: 16),
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      )
    );
  }
}