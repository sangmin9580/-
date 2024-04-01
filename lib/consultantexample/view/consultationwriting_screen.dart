import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:project/common/widgets/main_navigation_screen.dart';
import 'package:project/common/widgets/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class ConsultationWritingScreen extends ConsumerStatefulWidget {
  const ConsultationWritingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsultationWritingScreenState();
}

class _ConsultationWritingScreenState
    extends ConsumerState<ConsultationWritingScreen> {
  late final TextEditingController _titleEditingController =
      TextEditingController();

  late final TextEditingController _contentEditingController =
      TextEditingController();

  String _title = " ";
  String _content = "";
  bool _titleisWriting = false;
  bool _contentisWriting = false;

  // 위치 조정을 위한 key
  final GlobalKey _titleKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    _titleEditingController.addListener(() {
      _title = _titleEditingController.text;
      setState(() {});
    });

    _contentEditingController.addListener(() {
      _content = _contentEditingController.text;
      setState(() {});
    });
  }

  void _scrollToGlobalKey(GlobalKey key) async {
    final context = key.currentContext;
    if (context != null) {
      await Scrollable.ensureVisible(context,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _onSignUpTap() {
    context.go(
      MainNavigationScreen.routeURL,
    );
  }

  void _onBackbuttonTap() {
    final state = ref.read(mainNavigationViewModelProvider.notifier);
    state.setNavigationBarSelectedIndex(0);
  }

  void _ontitleStartWriting(GlobalKey key) {
    _scrollToGlobalKey(_titleKey);

    setState(() {
      _titleisWriting = true;
      _contentisWriting = false;
    });
  }

  void _oncontentStartWriting() {
    setState(() {
      _contentisWriting = true;
      _titleisWriting = false;
    });
  }

  bool _canSignup() {
    if (_title.length > 5 && _content.length > 5) {
      return true;
    }
    return false;
  }

  void _onbodyTap() {
    FocusScope.of(context).unfocus();
    setState(() {
      _titleisWriting = false;
      _contentisWriting = false;
    });
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onbodyTap,
      child: Scaffold(
        appBar: AppBar(
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
              const Text(
                "상담글 작성",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: _onSignUpTap,
              child: SizedBox(
                width: Sizes.size64,
                child: Text(
                  "등록하기",
                  style: TextStyle(
                    fontWeight:
                        _canSignup() ? FontWeight.bold : FontWeight.w500,
                    fontSize: Theme.of(context).textTheme.titleMedium!.fontSize,
                    color: _canSignup()
                        ? const Color(0xFFC78D20)
                        : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
            Gaps.h20,
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: verticalPadding,
              horizontal: horizontalPadding,
            ),
            child: Column(
              children: [
                // 제목(10자 이상*)과 textfield
                Row(
                  key: _titleKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "제목",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gaps.h5,
                        Text(
                          "(10자 이상",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            color: Color(
                              0xFFC78D20,
                            ),
                          ),
                        ),
                        Text(
                          ")",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    if (_titleisWriting)
                      RichText(
                        text: TextSpan(
                          text: "${_title.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(
                              0xFFC78D20,
                            ),
                          ),
                          children: const [
                            TextSpan(
                              text: "/50자",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
                Gaps.v10,
                // 내용(200자 이상*)과 textfield
                TextField(
                  onTap: () => _ontitleStartWriting(_titleKey),
                  controller: _titleEditingController,
                  decoration:
                      const InputDecoration(hintText: "1개의 질문을 구체적으로 해주세요."),
                ),
                Gaps.v32,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "내용",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Gaps.h5,
                        Text(
                          "(200자 이상",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                        const Text(
                          "*",
                          style: TextStyle(
                            fontSize: Sizes.size20,
                            color: Color(
                              0xFFC78D20,
                            ),
                          ),
                        ),
                        Text(
                          ")",
                          style: TextStyle(
                            fontSize: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .fontSize,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                    if (_contentisWriting)
                      RichText(
                        text: TextSpan(
                          text: "${_content.length}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(
                              0xFFC78D20,
                            ),
                          ),
                          children: const [
                            TextSpan(
                                text: "/200자",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                      ),
                  ],
                ),
                Gaps.v10,
                TextField(
                  onTap: _oncontentStartWriting,
                  controller: _contentEditingController,
                  maxLines: null,
                  minLines: 8,
                  decoration: const InputDecoration(hintText: "구체적으로 작성부탁드려요."),
                ),
                Gaps.v56,
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                    color: const Color(
                      0xFFBCBCA8,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.width * 0.85,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: verticalPadding,
                      horizontal: horizontalPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "상담글 등록 전 필수 안내사항",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size16,
                          ),
                        ),
                        Gaps.v14,
                        DefaultTextStyle(
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "1. 상담글 제목은 답변을 받기에 적합한 내용으로 일부 변경될 수 있습니다.",
                              ),
                              Gaps.v14,
                              Text(
                                "2. 상담글에 전문가 답변 등록시 글 삭제가 불가합니다.",
                              ),
                              Gaps.v14,
                              Text(
                                "3. 등록된 글은 네이버 지식인, 포털 사이트, 멍선생 사이트에 내용이 공개됩니다.",
                              ),
                              Gaps.v14,
                              Text(
                                "4. 아래 사항에 해당할 경우, 서비스 이용이 제한될 수 있습니다.",
                              ),
                            ],
                          ),
                        ),
                        Gaps.v14,
                        Padding(
                          padding: EdgeInsets.only(
                            left: Sizes.size12,
                          ),
                          child: Text(
                            "개인정보(개인 실명, 전화번호, 주민번호, 주소, 아이디 등) 및 외부 링크 포함",
                            style: TextStyle(
                              color: Colors.black38,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
