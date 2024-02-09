import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:random_avatar/random_avatar.dart';

import 'package:social_media_feed_task/model/ImageResponse.dart';
import 'package:social_media_feed_task/model/comment_info.dart';
import 'package:social_media_feed_task/model/commentsResponse.dart';
import 'package:social_media_feed_task/model/post.dart';
import 'package:random_name_generator/random_name_generator.dart';
import 'package:social_media_feed_task/screen/liked_post_page.dart';
import 'package:social_media_feed_task/screen/save_post_screen.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Post> listPosts = [];
  List<Post> likedPosts = [];
  List<Post> savedPosts = [];
  final ScrollController _scrollController = ScrollController();
  final TextEditingController commentController = TextEditingController();
  List<String> imageUrls = [];
  // List<String> cmtList = [];
  // List<String> cmtUsername = [];
  List<CommentInfo> commentInfoList = [];

  int id = 100;
  var randomNames = RandomNames(Zone.india);
  String randomImage = "https://source.unsplash.com/random/900×700/?person";
  dynamic svgCode =
      RandomAvatar(DateTime.now().second.toString(), height: 40, width: 40);
  dynamic cmtAPI;
  int imageNum = 0;
  bool isLoading = false;
  void addData() {
    setState(() {
      isLoading = true;
    });
    for (var i = 0; i < 10; i++) {
      id = id + 1;

      // Check if imageUrls list is not empty before accessing its elements
      if (imageUrls.isNotEmpty) {
        listPosts.add(
          Post(
            id: id.toString(),
            name: randomNames.name(),
            img: imageUrls[imageNum],
            avatar: svgCode,
            like: false,
            save: false,
          ),
        );

        // ignore: avoid_print
        print(imageUrls[imageNum]);
        // Increment imageNum
        imageNum++;

        // Reset imageNum to 0 if it reaches the end of the list
        if (imageNum == imageUrls.length) {
          imageNum = 0;
        }
      } else {
        // ignore: avoid_print
        print('Warning: imageUrls list is empty.');
      }
    }
    // ignore: avoid_print
    print(listPosts.length);
    setState(() {
      isLoading = false;
    });
  }

  getResponse() async {
    setState(() {
      isLoading = true;
    });
    var response = await http.get(Uri.parse("https://dummyjson.com/products"));

    if (response.statusCode == 200) {
      // ignore: unnecessary_null_comparison
      if (response.body != null && response.body.isNotEmpty) {
        // Parse the JSON string
        Map<String, dynamic> responseBody = json.decode(response.body);

        // Now you can create an ImageResponse object from the parsed data
        ImageResponse responseImage = ImageResponse.fromJson(responseBody);

        // ignore: avoid_print
        print('Hello ${responseImage.total}');
        List<Products> products = responseImage.products!;

        // ignore: avoid_print
        print('Length of products : ${products.length}');
        for (int i = 0; i < products.length; i++) {
          imageUrls.add(products[i].thumbnail.toString());
        }
        // ignore: avoid_print
        print('Length of images Url : ${imageUrls.length}');
        addData();
      }
    }
  }

  getComments() async {
    var rs = await http.get(Uri.parse("https://dummyjson.com/comments"));
    if (rs.statusCode == 200) {
      // ignore: unnecessary_null_comparison
      if (rs.body != null && rs.body.isNotEmpty) {
        Map<String, dynamic> rsBody = json.decode(rs.body);

        CommentResponse commentResponse = CommentResponse.fromJson(rsBody);
        List<Comments> comments = commentResponse.comments!;
        for (int i = 0; i < comments.length; i++) {
          // cmtList.add(comments[i].body.toString());
          // cmtUsername.add(comments[i].user!.username.toString());
          commentInfoList.add(CommentInfo(
            id: i,
            body: comments[i].body.toString(),
            username: comments[i].user!.username.toString(),
          ));
        }
        print(commentInfoList);
        print("length = ${commentInfoList.length}");
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getResponse();
    getComments();

    _scrollController.addListener(_loadMoreData);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreData() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // await Future.delayed(Duration(seconds: 1));
      setState(() {
        isLoading = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      addData();
    }
  }

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Social media feed",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return LikedPostPage(
                      savedPosts: savedPosts,
                      likedPosts: likedPosts,
                      listPosts: listPosts,
                      onUpdateList: (updatedList) {
                        setState(() {
                          listPosts = updatedList;
                        });
                      },
                    );
                  },
                ));
              },
              icon: const Icon(
                Icons.favorite_outline,
                color: Colors.white,
              )),
          IconButton(
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) {
                    return SavePost(
                      likedPosts: likedPosts,
                      listPosts: listPosts,
                      savedPosts: savedPosts,
                      onUpdateList: (updatedList) {
                        setState(() {
                          listPosts = updatedList;
                        });
                      },
                    );
                  },
                ));
              },
              icon: const Icon(
                Icons.bookmark_border,
                color: Colors.white,
              )),
        ],
        backgroundColor: Colors.blue,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                  controller: _scrollController,
                  itemCount: listPosts.length,
                  itemBuilder: (context, index) {
                    if (index < listPosts.length) {
                      Post item = listPosts[index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8)),
                                child: item.avatar,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                item.name,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.more_vert)),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Image.network(
                            item.img,
                            width: MediaQuery.of(context).size.width,
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          // Image.network(
                          //     "https://images.unsplash.com/photo-1530389361604-f5fb2936a855?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dGVtcHxlbnwwfHwwfHx8MA%3D%3D"),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  likedPosts.add(item);

                                  setState(() {
                                    item.like = !item.like;
                                  });
                                  // print(item.id);
                                  // print(item.name);
                                },
                                icon: Icon(
                                  item.like == false
                                      ? Icons.favorite_outline
                                      : Icons.favorite_sharp,
                                  color: item.like == false
                                      ? Colors.black
                                      : Colors.red,
                                  size: 35,
                                ),
                              ),
                              IconButton(
                                onPressed: openCommentsPanel,
                                icon: const Icon(
                                  Icons.comment_outlined,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.send_sharp,
                                  size: 30,
                                  color: Colors.black,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  savedPosts.add(item);

                                  // listPosts.removeAt(index);
                                  setState(() {
                                    item.save = !item.save;
                                    // listPosts.removeAt(index);
                                  });
                                  // print(item.id);
                                  // print(item.name);
                                },
                                icon: Icon(
                                  item.save == false
                                      ? Icons.bookmark_border_outlined
                                      : Icons.bookmark,
                                  color: Colors.black,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "999434 likes",
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(item.name,
                                    textAlign: TextAlign.left,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    )),
                                Text(
                                  isExpanded
                                      ? "Amidst the golden hues of a vibrant sunset, I found solace in the company of nature's beauty. Standing tall, embracing the warm glow, a silhouette against the mesmerizing canvas of the sky. The whispers of the gentle breeze weave tales of forgotten dreams, while the distant mountains echo the silent conversations of the soul. In this fleeting moment, caught between the realms of reality and reverie, I am but a wanderer in the cosmic symphony, a seeker of stories untold. Each step forward is a dance with destiny, and every glance backward is a reflection on the infinite possibilities that lie ahead. 🌅✨ #CapturedByFate #ChasingSunsets #WanderlustHeart #EphemeralDreams #SoulfulJourney"
                                      : 'Amidst the golden hues of a...',
                                  maxLines: isExpanded ? 5 : 9,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (!isExpanded)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        isExpanded = true;
                                      });
                                    },
                                    child: const Text('More'),
                                  ),
                              ],
                            ),
                          ),

                          TextButton(
                            clipBehavior: Clip.antiAlias,
                            onPressed: () {
                              openCommentsPanel();
                            },
                            child: const Text(
                              "View all 300 comments",
                              textAlign: TextAlign.left,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ],
                      );
                    } else {
                      addData();
                      setState(() {});
                    }
                    return null;
                  }),
            ),
    );
  }

  void openCommentsPanel() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: 500, // Set your desired height here
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Comments",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: commentInfoList.length,
                  itemBuilder: (context, index) {
                    // ... (remaining code for comment list item)

                    String username = commentInfoList[index].username;
                    String comment = commentInfoList[index].body;

                    return ListTile(
                      leading: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        child: RandomAvatar(DateTime.now().second.toString(),
                            height: 40, width: 40),
                      ),
                      title: Text(username),
                      subtitle: Text(comment),
                      trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              commentInfoList.removeAt(index);
                              Navigator.pop(context);
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.grey,
                          )),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                          hintText: 'Add a comment...',
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                commentInfoList.insert(
                                    0,
                                    CommentInfo(
                                        id: id,
                                        body: commentController.text,
                                        username: randomNames.name()));
                                Navigator.pop(context);
                              });
                              commentController.clear();
                            },
                            icon: const Icon(Icons.send),
                          ),
                          suffixIconColor: Colors.blue),
                    ),
                    const SizedBox(height: 8.0),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
