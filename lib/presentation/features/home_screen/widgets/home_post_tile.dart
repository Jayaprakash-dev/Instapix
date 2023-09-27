import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gallery/domain/entities/post.dart';

class HomePostTile extends StatefulWidget {
  final List<PostEntity> posts;

  const HomePostTile(this.posts, {super.key});

  @override
  State<HomePostTile> createState() => _HomePostTileState();
}

class _HomePostTileState extends State<HomePostTile> {

  bool _searchCloseIconVisibility = false;
  late final TextEditingController _searchController;

  late List<PostEntity> _posts;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _posts = widget.posts;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 50,
          padding: const EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(0, 225, 225, 225).withOpacity(1),
                offset: const Offset(3, 8),
                blurRadius: 10,
                spreadRadius: -7,
              )
            ]
          ),
          child: SearchAnchor(
            builder: (context, controller) {
              return SearchBar(
                controller: controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                onChanged: (String searchText) {
                  setState(() {
                    if (searchText.trim().isEmpty) {
                      _posts = widget.posts;
                      return;
                    }
                    _posts = widget.posts.where((element) => element.title.toLowerCase().contains(searchText.toLowerCase())).toList();
                    if (!_searchCloseIconVisibility) _searchCloseIconVisibility = true;
                  });
                },
                leading: const Icon(Icons.search, color: Colors.grey),
                trailing: <Widget>[
                  Visibility(
                    visible: _searchCloseIconVisibility,
                    child: IconButton(
                      onPressed: () { 
                        controller.clear();
                        
                        setState(() {
                          _posts = widget.posts;
                          _searchCloseIconVisibility = false;
                        });
                      },
                      icon: const Icon(Icons.close_rounded, color: Colors.grey)
                    )
                  )
                ],
                elevation: const MaterialStatePropertyAll(0),
                shape: const MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15))
                  )
                ),
                hintText: 'Search...',
                hintStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    color: Colors.grey
                  )
                ),
                textStyle: const MaterialStatePropertyAll(
                  TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500
                  )
                ),
              );
            },
            suggestionsBuilder: (context, controller) {
              return List<ListTile>.generate(5, (int index) {
                final String item = 'item $index';
                return ListTile(
                  title: Text(item),
                  onTap: () {
                    setState(() {
                      controller.closeView(item);
                    });
                  },
                );
              });
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _posts.length,
            itemBuilder: (context, index) {
              return _buildPostTile(_posts[index]);
            },
          ),
        ),
      ],
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
            height: 400,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(post.imagePath)),
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

  @override
  void didUpdateWidget(covariant HomePostTile oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.posts.hashCode != widget.posts.hashCode) {
      _posts = widget.posts;
    }
  }
}