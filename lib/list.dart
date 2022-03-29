import 'package:flutter/material.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The subtitle line, if any, to show in a list item.
  Widget buildIcon(BuildContext context);

  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

  /// The subtitle line, if any, to show in a list item.
  Widget buildSubtitle(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  @override
  Widget buildIcon(BuildContext context) {
    return const Icon(Icons.map);
  }

  @override
  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }

  @override
  Widget buildSubtitle(BuildContext context) => const SizedBox.shrink();
}

/// A ListItem that contains data to display a message.
class NormalItem implements ListItem {
  final String title;
  final String subtitle;

  NormalItem(this.title, this.subtitle);

  @override
  Widget buildIcon(BuildContext context) {
    return const Icon(Icons.photo_album);
  }

  @override
  Widget buildTitle(BuildContext context) => Text(title);

  @override
  Widget buildSubtitle(BuildContext context) => Text(subtitle);
}