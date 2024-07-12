import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photogenerator/main.dart';
import 'package:photogenerator/models/bloc_data/gallery_bloc_data.dart';

class GalleryBuilder extends StatelessWidget {
  final Widget Function(List<File>) builder;
  final Widget? placeHolder;

  GalleryBuilder(this.builder, {this.placeHolder});

  Widget get _placeHolder => placeHolder ?? Container();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GalleryBlocData>(
      stream: blocManager.galleryBloc.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return _placeHolder;
        return builder(snapshot.data!.sortedFiles);
      },
    );
  }
}
