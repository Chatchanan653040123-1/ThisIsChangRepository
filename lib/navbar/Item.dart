import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

Widget item() {
  final user = FirebaseAuth.instance.currentUser;
  final auth = FirebaseAuth.instance;
  Widget userImage;
  try {
    userImage = CircleAvatar(
      backgroundImage: NetworkImage(auth.currentUser!.photoURL!),
    );
    print(auth.currentUser!.photoURL!);
  } catch (e) {
    userImage = const Icon(
      Icons.person,
      size: 50,
      color: Color.fromARGB(255, 117, 117, 117),
    );
  }
  return Drawer(
    child: ListView(
      // Remove padding
      padding: EdgeInsets.zero,
      children: [
        UserAccountsDrawerHeader(
          accountName: Text("KKU PARK INFO"),
          accountEmail: Text((user?.email!).toString()),
          currentAccountPicture: CircleAvatar(
            child: ClipOval(
              child: userImage,
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.blue,
            image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(
                    'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),
          ),
        ),
        ListTile(
          leading: Icon(Icons.favorite),
          title: Text('Favorites'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Friends'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.share),
          title: Text('Share'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Request'),
        ),
        Divider(),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          onTap: () => null,
        ),
        ListTile(
          leading: Icon(Icons.description),
          title: Text('Policies'),
          onTap: () => null,
        ),
        Divider(),
        ListTile(
          title: Text('Sign out'),
          leading: Icon(Icons.exit_to_app),
          onTap: () => FirebaseAuth.instance.signOut(),
        ),
      ],
    ),
  );
}
