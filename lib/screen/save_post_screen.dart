// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:social_media_feed_task/model/post.dart';

class SavePost extends StatefulWidget {
  List<Post> savedPosts;
  List<Post> likedPosts;
  List<Post> listPosts;
  final Function(List<Post>) onUpdateList;
  SavePost(
      {super.key,
      required this.savedPosts,
      required this.likedPosts,
      required this.listPosts,
      required this.onUpdateList});

  @override
  State<SavePost> createState() => _SavePostState();
}

class _SavePostState extends State<SavePost> {
  bool isExpanded = false;
  final TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              _handleLikedPagePop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          "Saved Posts",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: widget.savedPosts.length,
          itemBuilder: (context, index) {
            Post item = widget.savedPosts[index];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: item.avatar,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      item.name,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const Spacer(),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.more_vert)),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.network(item.img),
                // Image.network(
                //     "https://images.unsplash.com/photo-1530389361604-f5fb2936a855?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MXx8dGVtcHxlbnwwfHwwfHx8MA%3D%3D"),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        widget.likedPosts.add(item);

                        setState(() {
                          item.like = !item.like;
                        });

                        // print(widget.listPosts[2].name);
                      },
                      icon: Icon(
                        item.like == false
                            ? Icons.favorite_outline
                            : Icons.favorite_sharp,
                        color: item.like == false ? Colors.black : Colors.red,
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return SlidingUpPanel(
                              backdropTapClosesPanel: true,
                              defaultPanelState: PanelState.OPEN,
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(24),
                              ),
                              maxHeight: MediaQuery.of(context).size.height,
                              panelBuilder: (scrollController) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Text(
                                      "Comments",
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        controller: scrollController,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: TextField(
                                                controller: commentController,
                                                decoration:
                                                    const InputDecoration(
                                                  hintText: 'Add a comment...',
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                commentController.clear();
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Post Comment'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
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
                        setState(() {
                          widget.savedPosts.removeAt(index);
                          widget.listPosts.insert(0, item);
                          item.save = false;
                        });
                        // print(widget.savedPosts[2].name);
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
                    onPressed: () {},
                    child: const Text(
                      "View all 300 comments",
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.grey),
                    )),
              ],
            );
          },
        ),
      ),
    );
  }

  void _handleLikedPagePop() {
    // Call the callback function with the updated liked posts
    widget.onUpdateList(widget.listPosts);
    Navigator.pop(context);
  }
}
