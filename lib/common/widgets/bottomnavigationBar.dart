import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/sizes.dart';

class CustomBottomNavigationBar extends ConsumerWidget {
  const CustomBottomNavigationBar({
    super.key,
    required this.onItemSelected,
    required this.selectedIndex,
  });
  final int selectedIndex;
  final Function(int) onItemSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: selectedIndex,
      onTap: (index) {
        onItemSelected(index);
      },
      iconSize: Sizes.size20,
      selectedFontSize: Sizes.size10,
      unselectedFontSize: Sizes.size8,
      items: const [
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.house,
          ),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.magnifyingGlass,
          ),
          label: "검색",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.circlePlus,
          ),
          label: "상담글 작성",
        ),
        BottomNavigationBarItem(
          icon: FaIcon(
            FontAwesomeIcons.user,
          ),
          label: "마이페이지",
        ),
      ],
    );
  }
}
