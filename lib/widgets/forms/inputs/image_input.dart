import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  final String? imageUrl;

  const ImageField({super.key, this.imageUrl});

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  XFile? _imageFile;
  final _picker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          const Text(
            'choose image',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: const Text('gallery'),
                icon: const Icon(Icons.image),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: const Text('camera'),
                icon: const Icon(Icons.camera),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        radius: 80,
        onTap: () {
          showModalBottomSheet(
              context: context, builder: ((builder) => bottomSheet()));
        },
        child: Stack(
          children: <Widget>[
            _imageFile != null
                ? CircleAvatar(
                    backgroundImage: NetworkImage(_imageFile.toString()),
                    radius: 80,
                  )
                : const CircleAvatar(
                    backgroundImage:
                        AssetImage("assets/images/profile-default.jpg"),
                    radius: 80,
                  ),
            const Positioned(
                bottom: 20,
                right: 16,
                child: Icon(
                  Icons.camera_alt,
                  size: 30,
                  color: Colors.amberAccent,
                ))
          ],
        ),
      ),
    );
  }
}
