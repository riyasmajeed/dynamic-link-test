import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:share_plus/share_plus.dart';

// Function to generate a dynamic link
Future<String> createDynamicLink(bool short, String postId) async {
  final DynamicLinkParameters parameters = DynamicLinkParameters(
    uriPrefix: 'https://newideacanchage.page.link',  // Your provided dynamic link domain
    link: Uri.parse('https://yourapp.com/post?id=$postId'),  // Update with your app's deep link
    androidParameters: const AndroidParameters(
      packageName: 'com.yourapp',  // Update with your app's Android package name
      minimumVersion: 0,
    ),
    iosParameters: const IOSParameters(
      bundleId: 'com.yourapp.ios',  // Update with your app's iOS bundle ID
      minimumVersion: '1.0.1',
    ),
  );

  Uri url;
  if (short) {
    try {
      // Use FirebaseDynamicLinks.instance.buildShortLink() instead of parameters.buildShortLink()
      final ShortDynamicLink shortLink = await FirebaseDynamicLinks.instance.buildShortLink(parameters);
      url = shortLink.shortUrl;
    } catch (e) {
      print('Error creating short dynamic link: $e');
      return '';  // Return an empty string on failure
    }
  } else {
    try {
      // Use FirebaseDynamicLinks.instance.buildLink() instead of parameters.buildUrl()
      url = await FirebaseDynamicLinks.instance.buildLink(parameters);
    } catch (e) {
      print('Error creating long dynamic link: $e');
      return '';  // Return an empty string on failure
    }
  }

  return url.toString();
}

// Function to share the post
void sharePost(String postId) async {
  try {
    String link = await createDynamicLink(true, postId);  // Use short link
    if (link.isNotEmpty) {
      Share.share('Check out this post: $link');
    } else {
      print('Failed to create dynamic link');
    }
  } catch (e) {
    print('Error sharing post: $e');
  }
}
