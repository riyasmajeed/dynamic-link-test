import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'isolink.dart'; // Import for dynamic link and sharing logic

// Main HomePage class
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    TextPost(),
    VideoPost(),
    ImagePost(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    // Handle incoming Firebase Dynamic Links
    FirebaseDynamicLinks.instance.onLink.listen((PendingDynamicLinkData? dynamicLinkData) async {
      final Uri? deepLink = dynamicLinkData?.link;

      if (deepLink != null) {
        String postId = deepLink.queryParameters['id'] ?? '';
        navigateToPost(postId);
      }
    }).onError((error) {
      print('Link Failed: ${error.toString()}');
    });

    // Check for initial dynamic link if the app was opened by one
    FirebaseDynamicLinks.instance.getInitialLink().then((dynamicLinkData) {
      final Uri? deepLink = dynamicLinkData?.link;
      if (deepLink != null) {
        String postId = deepLink.queryParameters['id'] ?? '';
        navigateToPost(postId);
      }
    }).catchError((error) {
      print('Error handling initial link: ${error.toString()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GuideUs Posts'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.text_fields), label: 'Text'),
          BottomNavigationBarItem(icon: Icon(Icons.video_library), label: 'Video'),
          BottomNavigationBarItem(icon: Icon(Icons.image), label: 'Image'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Function to handle navigation based on postId
  void navigateToPost(String postId) {
    if (postId == 'text_post_id') {
      setState(() {
        _selectedIndex = 0;
      });
    } else if (postId == 'video_post_id') {
      setState(() {
        _selectedIndex = 1;
      });
    } else if (postId == 'image_post_id') {
      setState(() {
        _selectedIndex = 2;
      });
    } else {
      print('Unknown Post ID');
    }
  }
}

// Text Post
class TextPost extends StatelessWidget {
  const TextPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is a Text Post'),
        ElevatedButton(
          onPressed: () => sharePost('text_post_id'),
          child: const Text('Share Text Post'),
        ),
      ],
    );
  }
}

// Video Post
class VideoPost extends StatelessWidget {
  const VideoPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is a Video Post (replace with video player)'),
        ElevatedButton(
          onPressed: () => sharePost('video_post_id'),
          child: const Text('Share Video Post'),
        ),
      ],
    );
  }
}

// Image Post
class ImagePost extends StatelessWidget {
  const ImagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('This is an Image Post (replace with image display)'),
        ElevatedButton(
          onPressed: () => sharePost('image_post_id'),
          child: const Text('Share Image Post'),
        ),
      ],
    );
  }
}
