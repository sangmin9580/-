import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/common/view/main_navigation_screen.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/consultationcase/view/pet_edit_screen.dart';
import 'package:project/feature/consultationcase/viewmodel/consultingexample_vm.dart';
import 'package:project/feature/consultationcase/widgets/%08consultant_requirement_text.dart';
import 'package:project/feature/mypage/pets/model/pet_model.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_select_vm.dart';
import 'package:project/feature/mypage/widgets/petinformationbox.dart';

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

  final TextEditingController _expertTypeController = TextEditingController();
  final TextEditingController _consultationTopicController =
      TextEditingController();

  String _title = " ";
  String _content = "";
  bool _titleisWriting = false;
  bool _contentisWriting = false;
  File? _image;
  bool hasNavigated = false;
  final ImagePicker _picker = ImagePicker();
  final List<File> _images = [];

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

  Future<void> _pickImage() async {
    if (_images.length >= 5) {
      // 이미지가 5장을 초과하면 추가하지 않음
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
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

  void _onBackbuttonTap() async {
    final expertType = ref.read(expertTypeProvider);
    final consultationTopic = ref.read(consultationTopicProvider);
    // 제목이나 내용에 글자가 있는지 확인
    bool hasContent = _title.trim().isNotEmpty || _content.trim().isNotEmpty;

    ///아래 3개는 등록하기를 할떄도 마찬가지로 똑같이 써야함.
    ref.read(consultationProcessStartedProvider.notifier).state = false;
    expertType == null;
    consultationTopic == null;
    // 내용이 있다면 모달 창을 띄우고, 사용자의 선택을 기다림
    if (hasContent) {
      bool? result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("작성을 그만하시겠어요?"),
            content: const Text("작성하신 내용은 저장되지 않습니다."),
            actions: <Widget>[
              TextButton(
                child: const Text("취소"),
                onPressed: () =>
                    Navigator.of(context).pop(false), // 취소: false 반환
              ),
              TextButton(
                child: const Text("확인"),
                onPressed: () => Navigator.of(context).pop(true), // 확인: true 반환
              ),
            ],
          );
        },
      );

      // 사용자가 '확인'을 눌러 모달 창을 닫았다면, 이전 화면으로 돌아감
      if (result == true) {
        final state = ref.read(mainNavigationViewModelProvider.notifier);
        state.setNavigationBarSelectedIndex(0);
      }
    } else {
      return;
    }
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

// 상담글 작성 처음 들어오면 나오는 모달창(수의사 훈련사 탭)
  void _showExpertSelectionModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        // 여기에 모달의 내용을 구성합니다.
        return SizedBox(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.only(
              top: Sizes.size20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "상담을 원하시는 전문가를",
                  style: appbarTitleStyle,
                ),
                const Text(
                  "선택해주세요.",
                  style: appbarTitleStyle,
                ),
                Gaps.v20,
                ListTile(
                  title: const Center(
                    child: Text(
                      '수의사',
                      style: TextStyle(
                        color: Color(0xFFC78D20),
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ),
                  onTap: () {
                    // 수의사 선택 로직 처리
                    ref.read(expertTypeProvider.notifier).state = '수의사';
                    Navigator.pop(context); // 현재 모달 닫기
                    _showConsultationTopicSelectionModal(
                        context, '수의사'); // 새로운 모달 띄우기
                  },
                ),
                ListTile(
                  title: const Center(
                    child: Text(
                      '훈련사',
                      style: TextStyle(
                        color: Color(0xFFC78D20),
                        fontWeight: FontWeight.w600,
                        fontSize: Sizes.size20,
                      ),
                    ),
                  ),
                  onTap: () {
                    // 훈련사 선택 로직 처리
                    ref.read(expertTypeProvider.notifier).state = '훈련사';
                    Navigator.pop(context); // 현재 모달 닫기
                    _showConsultationTopicSelectionModal(
                        context, '훈련사'); // 새로운 모달 띄우기
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

// 수의사나 전문가 탭하면 나오는 모달창
  void _showConsultationTopicSelectionModal(
      BuildContext context, String expertType) {
    List<String> topics = expertType == "수의사"
        ? [
            "예방접종",
            "건강관리 상담",
            "알러지",
            "피부질환",
            "내분비질환",
            "노령견의 건강관리",
            "영양",
            "일상생활의 편의제공",
            "응급상황",
            "사고예방",
            "출산관련 상담 및 건강관리",
            "기타"
          ]
        : ["순종훈련", "문제행동 교정", "고급 훈련", "사회화 훈련", "분리불안해소", "이동 및 여행 훈련", "기타"];

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: topics.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(topics[index]),
              onTap: () {
                ref.read(consultationTopicProvider.notifier).state =
                    topics[index];
                Navigator.pop(context); // 모달창 닫기
              },
            );
          },
        );
      },
    );
  }

  void _navigateToPetEditScreen(BuildContext context) {
    // 선택된 반려동물 인덱스 확인
    final petSelect = ref.read(petSelectionStateProvider.notifier).state;
    // 반려동물이 선택되었는지 확인
    final isPetSelected = petSelect == true;

    print("isPetSelected :  $isPetSelected");

    // 선택된 반려동물이 있으면 정보 표시 및 다음 단계 로직 진행

    // PetEditScreen으로 이동. 반려동물 선택 완료 후, 전문가 선택 모달창을 표시하도록 구현 예정

    if (isPetSelected) {
      // 선택된 반려동물 정보를 사용하여 로직 진행
      // 예: 전문가 선택 모달창 표시
      _showExpertSelectionModal(context);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PetEditScreen()),
      ).then((_) {
        // PetEditScreen에서 돌아온 후의 로직. 예: 전문가 선택 모달창 표시
        if (ref.read(consultationProcessStartedProvider)) {
          _showExpertSelectionModal(context);
        }
      });
    }
  }

  void _onPetBoxTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetEditScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _contentEditingController.dispose();
    _expertTypeController.dispose();
    _consultationTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        ref.watch(mainNavigationViewModelProvider).navigationBarSelectedIndex;
    final selectedPetIndex = ref.watch(petEditViewModelProvider);
    final petList = ref.watch(petNavigationProvider);
    final expertType = ref.watch(expertTypeProvider);
    final consultationTopic = ref.watch(consultationTopicProvider);

    PetModel? selectedPet;

    if (currentIndex != 2) {
      hasNavigated = false; // 인덱스가 2가 아닐 때 hasNavigated를 false로 리셋
    } else if (!hasNavigated) {
      Future.microtask(
        () {
          _navigateToPetEditScreen(context);
          hasNavigated = true;
          print("hasNavigated : $hasNavigated");
        },
      );
    }

    return petList.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (data) {
        if (selectedPetIndex >= 0 && selectedPetIndex < data.length) {
          selectedPet = data[selectedPetIndex];
        }

        // initState에서 설정했던 로직을 여기서 처리
        _expertTypeController.text = expertType ?? '';
        _consultationTopicController.text = consultationTopic ?? '';

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
                        fontSize:
                            Theme.of(context).textTheme.titleMedium!.fontSize,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "전문가 상담",
                      style: TextStyle(
                        fontSize: Sizes.size18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Gaps.v10,
                    if (selectedPet != null)
                      GestureDetector(
                        onTap: _onPetBoxTap,
                        child: PetInformationBox(
                          name: selectedPet!.name,
                          age: selectedPet!.getAge(),
                          breed: selectedPet!.breed,
                          bio: selectedPet!.gender,
                          weight: selectedPet!.weight,
                        ),
                      ),

                    Gaps.v10,
                    const Text("전문가와 상담주제를 선택해주세요"),
                    Gaps.v20,
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _expertTypeController,
                            readOnly: true, // 사용자 입력을 막고 탭하여 모달창을 표시하도록 합니다.
                            decoration: InputDecoration(
                              labelText: '전문가 유형',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  _showExpertSelectionModal(context);
                                },
                              ),
                            ),
                          ),
                        ),
                        Gaps.h16, // 상담 주제 선택 필드
                        Expanded(
                          child: TextField(
                            controller: _consultationTopicController,
                            readOnly: true, // 사용자 입력을 막고 탭하여 모달창을 표시하도록 합니다.
                            decoration: InputDecoration(
                              labelText: '상담 주제',
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.arrow_drop_down),
                                onPressed: () {
                                  // 전문가 유형이 선택되었는지 확인하고, 선택된 유형에 따라 주제 선택 모달을 표시합니다.
                                  final expertType =
                                      ref.read(expertTypeProvider);
                                  if (expertType != null) {
                                    _showConsultationTopicSelectionModal(
                                        context, expertType);
                                  } else {
                                    // 사용자에게 먼저 전문가 유형을 선택하도록 안내합니다.
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('먼저 전문가 유형을 선택해주세요.'),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Gaps.v20,
                    // 제목(10자 이상*)과 textfield
                    Row(
                      key: _titleKey,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "제목",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gaps.h5,
                            CharacterRequirementText(
                              characterCount: 10,
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

                    TextField(
                      onTap: () => _ontitleStartWriting(_titleKey),
                      controller: _titleEditingController,
                      decoration: const InputDecoration(
                          hintText: "1개의 질문을 구체적으로 해주세요."),
                    ),
                    Gaps.v32,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Text(
                              "내용",
                              style: TextStyle(
                                fontSize: Sizes.size18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Gaps.h5,
                            CharacterRequirementText(
                              characterCount: 200,
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
                    if (_image != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(_image!),
                      ),
                    Wrap(
                      children: _images.asMap().entries.map(
                        (entry) {
                          int index = entry.key;
                          File image = entry.value;
                          return Stack(
                            alignment: Alignment.topRight,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.file(
                                  image,
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => _removeImage(index),
                              ),
                            ],
                          );
                        },
                      ).toList(),
                    ),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text('이미지 추가 (${_images.length}/5)'),
                    ),
                    // 내용(200자 이상*)과 textfield
                    Gaps.v10,
                    TextField(
                      onTap: _oncontentStartWriting,
                      controller: _contentEditingController,
                      maxLines: null,
                      minLines: 8,
                      decoration:
                          const InputDecoration(hintText: "구체적으로 작성부탁드려요."),
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
      },
    );
  }
}
