import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/widgets/viewmodel/search_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  // TextEditingController 인스턴스를 생성합니다.
  final TextEditingController _textEditingController = TextEditingController();

  List<Widget> buildSearchRows(
      BuildContext context, List<String> searchTerms, WidgetRef ref) {
    List<Widget> rows = [];
    for (int i = 0; i < searchTerms.length; i += 2) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildSearchTermBox(context, searchTerms[i], ref),
            if (i + 1 < searchTerms.length)
              buildSearchTermBox(context, searchTerms[i + 1], ref),
          ],
        ),
      );
      if (i + 2 < searchTerms.length) {
        rows.add(Gaps.v40); // Adds vertical space between rows
      }
    }
    return rows;
  }

  Widget buildSearchTermBox(
      BuildContext context, String searchTerm, WidgetRef ref) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              searchTerm,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: Sizes.size16,
                color: Colors.grey.shade500,
              ),
            ),
          ),
          Gaps.h5,
          InkWell(
            onTap: () {
              // 검색어 삭제 로직을 ViewModel을 통해 구현
              ref
                  .read(searchViewModelProvider.notifier)
                  .removeSearchTerm(searchTerm);
            },
            child: FaIcon(
              FontAwesomeIcons.xmark,
              size: Sizes.size16,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // 위젯이 dispose될 때 컨트롤러도 dispose해야 합니다.
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchTerms = ref.watch(searchViewModelProvider).recentSearches;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CupertinoSearchTextField(
          controller: _textEditingController,
          placeholder: "검색어를 입력해주세요",
          onSubmitted: (String value) {
            if (value.isNotEmpty) {
              ref.read(searchViewModelProvider.notifier).addSearchTerm(value);
              _textEditingController.clear(); // 검색어 제출 후 텍스트 필드 초기화
            }
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: verticalPadding,
          horizontal: horizontalPadding,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "최근 검색어",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // 전체 삭제 로직을 ViewModel을 통해 구현
                    ref
                        .read(searchViewModelProvider.notifier)
                        .clearSearchTerms();
                  },
                  child: Text(
                    "전체삭제",
                    style: TextStyle(
                      color: Colors.grey.shade500,
                    ),
                  ),
                ),
              ],
            ),
            Gaps.v40,
            ...buildSearchRows(context, searchTerms, ref),
          ],
        ),
      ),
    );
  }
}
