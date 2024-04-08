import 'package:flutter/material.dart';
import 'package:project/constants/sizes.dart';

const verticalPadding = Sizes.size20;
const horizontalPadding = Sizes.size18;

final defaultVericalDivider = Divider(
  height: 1, // Divider의 너비를 지정합니다. 실제로는 구분선의 좌우 패딩을 포함한 전체 너비입니다.
  thickness: 0.4, // 구분선의 두께를 지정합니다.
  color: Colors.grey.shade400,
  // 구분선의 색상을 지정합니다.
);

const appbarTitleStyle = TextStyle(
  fontSize: Sizes.size20,
  fontWeight: FontWeight.w600,
);

final appbarActionStyle = TextStyle(
  fontWeight: FontWeight.w500,
  fontSize: Sizes.size14,
  color: Colors.grey.shade500,
);

class Utils {
  static onScaffoldTap(BuildContext context) {
    FocusScope.of(context).unfocus();
  }
}
