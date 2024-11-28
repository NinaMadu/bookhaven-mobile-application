import 'package:flutter/material.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(252, 252, 252, 252),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 0, 0, 0),
        title: const Text("Edit Profile"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            // Profile picture with upload option
            ProfilePic(
              image: 'assets/icons/images/profile.png',
              isShowPhotoUpload: true,
              imageUploadBtnPress: () {
                // Handle profile picture update logic
              },
            ),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Name",
                    child: TextFormField(
                      initialValue: "Annette Black",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 128, 220, 234)
                            .withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Email",
                    child: TextFormField(
                      initialValue: "annette@gmail.com",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 128, 220, 234)
                            .withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Phone",
                    child: TextFormField(
                      initialValue: "(316) 555-0116",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 128, 220, 234)
                            .withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Address",
                    child: TextFormField(
                      initialValue: "New York, NVC",
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color.fromARGB(255, 128, 220, 234)
                            .withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cancel and go back
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[900],
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      // Save updates logic
                    },
                    child: const Text("Save Update"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    required this.image,
    this.isShowPhotoUpload = false,
    this.imageUploadBtnPress,
  });

  final String image;
  final bool isShowPhotoUpload;
  final VoidCallback? imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(image),
          ),
          if (isShowPhotoUpload)
            InkWell(
              onTap: imageUploadBtnPress,
              child: CircleAvatar(
                radius: 15,
                backgroundColor: const Color.fromARGB(255, 24, 64, 113),
                child: const Icon(
                  Icons.add_a_photo,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}
