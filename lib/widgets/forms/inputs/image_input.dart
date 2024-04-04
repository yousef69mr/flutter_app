import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  final String? defaultValue;
  final bool enabled;
  final Function(XFile?)? onImageChanged;

  const ImageField({
    super.key,
    required this.enabled,
    this.defaultValue,
    this.onImageChanged,
  });

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  XFile? _imageFile;

  final _picker = ImagePicker();

  Future<void> takePhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(
          source: source, preferredCameraDevice: CameraDevice.front);
      setState(() {
        _imageFile = pickedFile;
        // Call the callback function to notify parent about image change
        if (widget.onImageChanged != null) {
          widget.onImageChanged!(pickedFile);
        }
      });
    } catch (e) {
      Fluttertoast.showToast(
        msg: '$e',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
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

  //
  // @override
  // void initState() {
  //   // _imageFile = widget.defaultValue as XFile?;
  //
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        radius: 80,
        onTap: widget.enabled
            ? () {
                showModalBottomSheet(
                    context: context, builder: ((builder) => bottomSheet()));
              }
            : null,
        child: Stack(
          children: <Widget>[
            widget.defaultValue != null && _imageFile == null
                ? CircleAvatar(
                    backgroundImage:
                        NetworkImage(widget.defaultValue.toString()),
                    radius: 80,
                  )
                : _imageFile != null
                    ? CircleAvatar(
                        backgroundImage: FileImage(File(_imageFile!.path)),
                        radius: 80,
                      )
                    : const CircleAvatar(
                        backgroundImage: AssetImage(
                          "assets/images/profile-default.jpg",
                        ),
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
