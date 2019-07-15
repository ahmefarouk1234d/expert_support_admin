import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:cached_network_image/cached_network_image.dart';

class OrderImages extends StatelessWidget {
  final List<String> imageUrls;
  OrderImages({@required this.imageUrls});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
        ),
        body: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, crossAxisSpacing: 16),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: Hero(
                tag: 'imageHero $index',
                child: CachedNetworkImage(
                  imageUrl: imageUrls[index],
                  placeholder: (context, url) => Center(child: Container(width: 32, height: 32,child: new CircularProgressIndicator())),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    barrierDismissible: true,
                    barrierColor: Colors.black,
                    pageBuilder: (context, _, __) => ViewImage(imageUrls[index])));
              },
            );
          },
        ));
  }
}

class ViewImage extends StatelessWidget {
  final String image;
  ViewImage(this.image);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Hero(
            tag: 'imageHero',
            child: CachedNetworkImage(
              imageUrl: image,
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
                opacity: animation,
                child: child,
              ),
        );
}
