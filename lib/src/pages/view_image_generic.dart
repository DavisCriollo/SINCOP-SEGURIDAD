import 'package:flutter/material.dart';
import 'package:nseguridad/src/theme/themes_app.dart';
import 'package:nseguridad/src/utils/responsive.dart';
import 'package:provider/provider.dart';

class ImageViewGeneric extends StatelessWidget {
  final String title;
  final String image;

  const ImageViewGeneric({
    super.key,
    required this.title,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final Responsive size = Responsive.of(context);
    final ctrlTheme = context.read<ThemeApp>();

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                ctrlTheme.primaryColor,
                ctrlTheme.secondaryColor,
              ],
            ),
          ),
        ),
        title: Text(
          title,
          // style: Theme.of(context).textTheme.headline2,
        ),
      ),
      body: InteractiveViewer(
        child: Hero(
          tag: image.toString(),
          child: SizedBox(
            width: size.wScreen(100.0),
            height: size.hScreen(100.0),
            child: FadeInImage(
              placeholder: const AssetImage('assets/imgs/loader.gif'),
              image: NetworkImage(image),
            ),
            // Image.network(image)
          ),
        ),
      ),
    );
  }
}
