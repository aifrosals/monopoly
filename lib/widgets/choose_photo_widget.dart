import 'dart:io';

import 'package:flutter/material.dart';
import 'package:monopoly/providers/image_provider.dart';
import 'package:monopoly/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChoosePhoto extends StatefulWidget {
  final bool profileImage;

  const ChoosePhoto({
    Key? key,
    required this.profileImage,
  }) : super(key: key);

  @override
  State<ChoosePhoto> createState() => _ChoosePhotoState();
}

class _ChoosePhotoState extends State<ChoosePhoto> {
  @override
  Widget build(BuildContext context) {
    final imagesProvider = Provider.of<ImagesProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(child: Consumer<ImagesProvider>(
              builder: (context, dailyReportProvider, child) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose Photo",
                  style: Theme.of(context).textTheme.headline4,
                ),
                const SizedBox(
                  height: 6,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25))),
                        onPressed: () async {
                          if (widget.profileImage) {
                            await imagesProvider
                                .chooseGalleryProfile(userProvider.user);
                          } else {
                            await imagesProvider
                                .chooseGallery(userProvider.user);
                          }
                        },
                        child: const Text(
                          "Gallery",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    // Expanded(
                    //   child: MaterialButton(
                    //     onPressed: () {
                    //       imagesProvider.chooseCamera();
                    //     },
                    //     color: Colors.blue,
                    //     child: const Text(
                    //       "Camera,",
                    //       style: TextStyle(color: Colors.white),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ],
            );
          })),
          // const SizedBox(
          //   height: 15,
          // ),
          Consumer<ImagesProvider>(builder: (context, imageProvider, child) {
            if (imageProvider.imageUploading) {
              return const CircularProgressIndicator();
            } else {
              return const SizedBox();
            }
            // if (dailyReportProvider.images.isEmpty) {
            //   return const SizedBox();
            // } else {
            //   return SizedBox(
            //     //decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
            //     width: double.infinity,
            //     height: 120,
            //     child: ListView.builder(
            //         scrollDirection: Axis.horizontal,
            //         shrinkWrap: true,
            //         itemCount: dailyReportProvider.images.length,
            //         itemBuilder: (context, index) {
            //           return Padding(
            //             padding: const EdgeInsets.all(5.0),
            //             child: Stack(children: [
            //               Padding(
            //                 padding: const EdgeInsets.all(7.0),
            //                 child: Image.file(
            //                   File(dailyReportProvider.images[index]!.path),
            //                   errorBuilder: (context, e, st) {
            //                     return const Text('Error');
            //                   },
            //                 ),
            //               ),
            //               Positioned(
            //                   child: InkWell(
            //                 onTap: () {
            //                   dailyReportProvider.removePhoto(index);
            //                   //dailyReportProvider.removePhoto(dailyReportProvider.images![index]);
            //                 },
            //                 child: const Icon(
            //                   Icons.cancel,
            //                   color: Colors.red,
            //                   size: 30,
            //                 ),
            //               )),
            //             ]),
            //           );
            //         }),
            //   );
            // }
          })
        ],
      ),
    );
  }
}
