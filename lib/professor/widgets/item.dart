import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../constants/default.dart';
import '../../constants/gaps.dart';
import '../../constants/sizes.dart';

class ProfessorItems extends StatelessWidget {
  const ProfessorItems({
    super.key,
    required this.headertitle,
    required this.items,
  });

  final String headertitle;
  final List<Item> items;

  @override
  Widget build(BuildContext context) {
    final searchFaicon = FaIcon(
      FontAwesomeIcons.magnifyingGlass,
      size: Theme.of(context).textTheme.titleMedium!.fontSize,
      color: Colors.grey.shade400,
    );

    final listileTextStyle = TextStyle(
      color: Colors.grey.shade500,
      fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
    );

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size12,
              horizontal: horizontalPadding,
            ),
            child: Text(
              headertitle,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Gaps.v5,
        ...items.map(
          (item) {
            return ListTile(
              title: Text(item.title),
              subtitle: Text(
                item.subtitle,
                style: listileTextStyle,
              ),
              trailing: searchFaicon,
            );
          },
        ),
        Gaps.v32,
      ],
    );
  }
}

class MapItems extends ConsumerWidget {
  const MapItems({
    super.key,
    required this.headertitle,
    required this.items,
  });

  final String headertitle;
  final List<Item> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchFaicon = FaIcon(
      FontAwesomeIcons.magnifyingGlass,
      size: Theme.of(context).textTheme.titleMedium!.fontSize,
      color: Colors.grey.shade400,
    );

    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          color: Colors.grey.shade300,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Sizes.size10,
              horizontal: horizontalPadding,
            ),
            child: Text(
              headertitle,
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Gaps.v5,
        ...items.map(
          (item) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: Sizes.size10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium!.fontSize,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      searchFaicon
                    ],
                  ),
                ),
                defaultVericalDivider,
              ],
            );
          },
        ),
      ],
    );
  }
}

class Item {
  // 전문가들 탭에 Listile개수에 따라 map함수를 쓰기위해서 만든 class
  final String title;
  final String subtitle;

  Item({
    required this.title,
    this.subtitle = '',
  });
}
