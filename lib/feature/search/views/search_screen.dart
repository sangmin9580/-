import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/search/viewmodel/search_vm.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _textEditingController = TextEditingController();
  late FocusNode _searchFocusNode;
  bool _shouldRequestFocus = true;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

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
        rows.add(Gaps.v40);
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

  void _onBackbuttonTap() {
    ref
        .read(mainNavigationViewModelProvider.notifier)
        .setNavigationBarSelectedIndex(0, isFromPop: true);
    FocusScope.of(context).unfocus();
  }

  void _onbodyTap() {
    _shouldRequestFocus = false;
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final searchViewModel = ref.watch(searchViewModelProvider.notifier);
    final searchTerms = searchViewModel.recentSearches;

    final currentIndex = ref.watch(currentScreenProvider);
    final isSearchScreenActive = currentIndex == 1;

    if (isSearchScreenActive && _shouldRequestFocus) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (mounted && _shouldRequestFocus) {
            _searchFocusNode.requestFocus();
          }
        },
      );
    }

    return GestureDetector(
      onTap: _onbodyTap,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Row(
            children: [
              GestureDetector(
                onTap: _onBackbuttonTap,
                child: const SizedBox(
                  width: Sizes.size32,
                  child: FaIcon(
                    FontAwesomeIcons.chevronLeft,
                    size: Sizes.size20,
                  ),
                ),
              ),
              Expanded(
                child: CupertinoSearchTextField(
                  focusNode: _searchFocusNode,
                  controller: _textEditingController,
                  placeholder: "검색어를 입력해주세요",
                  onSubmitted: (String value) {
                    if (value.isNotEmpty) {
                      searchViewModel.addSearchTerm(value);
                      searchViewModel.searchConsultations(value);
                      ref
                          .read(mainNavigationViewModelProvider.notifier)
                          .setNavigationBarSelectedIndex(0);
                      ref
                          .read(mainNavigationViewModelProvider.notifier)
                          .setTabBarSelectedIndex(1);
                      _textEditingController.clear();
                    }
                  },
                ),
              ),
            ],
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
                      searchViewModel.clearSearchTerms();
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
      ),
    );
  }
}
