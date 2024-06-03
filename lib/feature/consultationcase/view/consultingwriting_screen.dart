import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/common/viewmodel/navigation_history_state_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/consultationcase/model/consultation_writing_model.dart';
import 'package:project/feature/consultationcase/view/pet_edit_screen.dart';
import 'package:project/feature/consultationcase/viewmodel/consultation_writing_vm.dart';
import 'package:project/feature/consultationcase/widgets/%08consultant_requirement_text.dart';
import 'package:project/feature/mypage/pets/model/pet_model.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_select_vm.dart';
import 'package:project/feature/mypage/widgets/petinformationbox.dart';
import 'package:uuid/uuid.dart';

class ConsultationWritingScreen extends ConsumerStatefulWidget {
  const ConsultationWritingScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsultationWritingScreenState();
}

class _ConsultationWritingScreenState
    extends ConsumerState<ConsultationWritingScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleEditingController =
      TextEditingController();
  late final TextEditingController _descriptionEditingController =
      TextEditingController();
  final TextEditingController _expertTypeController = TextEditingController();
  final TextEditingController _consultationTopicController =
      TextEditingController();

  String _titleText = "";
  String _descriptionText = "";
  final List<File> _images = [];
  bool _titleisWriting = false;
  bool _contentisWriting = false;
  bool hasNavigated = false;

  Map<String, String> formData = {};

  File? _image;
  final ImagePicker _picker = ImagePicker();

  // 위치 조정을 위한 key
  // final GlobalKey _titleKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _expertTypeController.text = "";
    _consultationTopicController.text = "";
    _titleEditingController.addListener(() {
      _titleText = _titleEditingController.text;
      print(" is title not empty? :  ${_titleText.isNotEmpty}");
      setState(() {});
    });
    _descriptionEditingController.addListener(() {
      _descriptionText = _descriptionEditingController.text;
      setState(() {});
    });
  }

  Future<void> _pickImage() async {
    if (_images.length >= 5) {
      // 이미지가 5장을 초과하면 추가하지 않음
      // SnackBar를 사용하여 사용자에게 알림
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('이미지는 최대 5개까지 추가할 수 있습니다.'),
          duration: const Duration(seconds: 2), // 표시 시간 조정
          action: SnackBarAction(
            label: '확인', // 사용자가 SnackBar를 즉시 닫을 수 있는 옵션 제공
            onPressed: () {
              // 필요한 경우 추가 작업 수행
            },
          ),
        ),
      );
      return;
    }
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(File(pickedFile.path));
      });
    }
  }

  void handlePopScope() {
    print("handlePopScpoe Callback in consultingwritingScreen");
    final MainNavigationViewModel =
        ref.read(mainNavigationViewModelProvider.notifier);
    final navHistory = ref.read(navigationHistoryProvider.notifier);
    final navHistoryState = ref.read(navigationHistoryProvider);

    if (navHistoryState.length > 1) {
      // 최소 두 개의 항목이 있을 때만 pop 실행
      final navHistoryNewState = navHistoryState.sublist(
          0, ref.read(navigationHistoryProvider).length - 1);
      navHistory.setState(navHistoryNewState);

      // 새로운 현재 상태
      final lastIndexs = navHistoryNewState.last;

      MainNavigationViewModel.setTabBarSelectedIndexFromPop(
          lastIndexs.tabIndex);
      MainNavigationViewModel.setNavigationBarSelectedIndex(
          lastIndexs.navBarIndex,
          isFromPop: true);
    }

    FocusScope.of(context).unfocus();
  }

  void _removeImage(int index) {
    setState(() {
      _images.removeAt(index);
    });
  }

  Future<void> _onSignUpTap() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        FocusScope.of(context).unfocus(); // 여기서 포커스 해제

        await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("글 등록 확인"),
              content: const Text("입력하신 내용으로 상담글을 등록하시겠습니까?"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _formKey.currentState!.save();

                    ConsultationWritingModel model = ConsultationWritingModel(
                      consultationId: const Uuid().v4(), // 임의의 ID 생성
                      userId: "user_id", // 실제 사용자 ID로 대체 필요
                      petId: formData['petId'] ?? "",
                      expertType: formData['expertType'] ?? "",
                      consultationTopic: formData['consultationTopic'] ?? "",
                      title: formData['title'] ?? "",
                      description: formData['description'] ?? "",
                      photos: [], // 초기에는 비어 있는 상태
                      timestamp: DateTime.now(),
                    );

                    ref
                        .read(consultationProvider.notifier)
                        .submitConsultationWithImages(
                            _images, model, context); // 폼 제출 함수 호출
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );

        // Dialog 닫힌 후 포커스 해제
        WidgetsBinding.instance.addPostFrameCallback((_) {
          FocusScope.of(context).unfocus();
        });

        await _showSuccessDialog();
      }
    }
  }

  void resetStateAndClearFields() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).unfocus(); // 상태 초기화 이전에 포커스 해제
    });

    ref.read(petSelectionStateProvider.notifier).state = false;
    ref.read(isPopNavigationMainProvider.notifier).state = false;
    _titleEditingController.clear();
    _descriptionEditingController.clear();
    _expertTypeController.clear();
    _consultationTopicController.clear();
    _images.clear();
    setState(() {
      _titleText = "";
      _descriptionText = "";
    });
  }

  Future<void> _showSuccessDialog() async {
    await showDialog(
      context: context,
      useRootNavigator: false,
      builder: (_) => AlertDialog(
        title: const Text('성공'),
        content: const Text('상담글이 성공적으로 등록되었습니다.'),
        actions: [
          TextButton(
            onPressed: () async {
              Navigator.of(context, rootNavigator: true).pop(); // 다이얼로그 닫기 명시
              await Future.delayed(const Duration(milliseconds: 100)); // 딜레이 추가
              resetStateAndClearFields();
              ref
                  .read(mainNavigationViewModelProvider.notifier)
                  .setNavigationBarSelectedIndex(
                    0,
                    isFromPop: true,
                  );
              FocusScope.of(context).unfocus();
            },
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showBackDialog() {
    final state = ref.read(mainNavigationViewModelProvider.notifier);
    // 모든 조건을 체크하여 어느 하나라도 데이터가 있으면 경고 다이얼로그를 띄웁니다.
    bool shouldShowDialog = _titleText.isNotEmpty ||
        _descriptionText.isNotEmpty ||
        _expertTypeController.text.isNotEmpty ||
        _consultationTopicController.text.isNotEmpty ||
        _images.isNotEmpty ||
        ref.read(petSelectionStateProvider.notifier).state != false;

    if (shouldShowDialog) {
      showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('변경사항을 포기하시겠습니까?'),
            content: const Text('입력한 내용이 저장되지 않고 사라집니다.'),
            actions: <Widget>[
              TextButton(
                child: const Text('취소'),
                onPressed: () {
                  Navigator.pop(context); // 다이얼로그를 닫습니다.
                },
              ),
              TextButton(
                child: const Text('확인'),
                onPressed: () {
                  // 모든 데이터를 초기화하고, 다이얼로그 및 화면을 닫습니다.
                  handlePopScope();
                  // pet을 다시 선택하게 하기 위한 조건
                  resetStateAndClearFields();
                  Navigator.pop(context); // 다이얼로그를 닫습니다.
                  state.setNavigationBarSelectedIndex(
                    0,
                    isFromPop: true,
                  ); // 메인 화면으로 돌아갑니다.
                },
              ),
            ],
          );
        },
      );
      ref.read(isPopNavigationMainProvider.notifier).state = false;
    } else {
      // 변경사항이 없으면 바로 뒤로 갑니다.
      // 무조건 0이 될 수밖에 없음
      state.setNavigationBarSelectedIndex(
        0,
        isFromPop: true,
      );
      ref.read(isPopNavigationMainProvider.notifier).state = false;
    }
  }

  void _ontitleStartWriting() {
    //_scrollToGlobalKey(_titleKey);

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
    if (_titleText.length > 5 && _descriptionText.length > 5) {
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
                    _expertTypeController.text = '수의사';
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
                    _expertTypeController.text = '훈련사';
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
                _consultationTopicController.text = topics[index];
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
    _descriptionEditingController.dispose();
    _expertTypeController.dispose();
    _consultationTopicController.dispose();
    _titleEditingController.clear();
    _descriptionEditingController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex =
        ref.watch(mainNavigationViewModelProvider).navigationBarSelectedIndex;

    final selectedPetIndex = ref.watch(petEditViewModelProvider);
    final petList = ref.watch(petNavigationProvider);

    PetModel? selectedPet;

    if (currentIndex != 2) {
      hasNavigated = false; // 인덱스가 2가 아닐 때 hasNavigated를 false로 리셋
    } else if (!hasNavigated) {
      Future.microtask(
        () {
          FocusScope.of(context).unfocus();

          _navigateToPetEditScreen(context);
          hasNavigated = true;
        },
      );
    }

    return petList.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
      data: (data) {
        if (selectedPetIndex >= 0 && selectedPetIndex < data.length) {
          selectedPet = data[selectedPetIndex];
          if (selectedPet != null) {
            formData['petId'] =
                selectedPet!.petId; // 예를 들어 pet 모델에 id 필드가 있다고 가정합니다.
          }
        }

        // initState에서 설정했던 로직을 여기서 처리

        return GestureDetector(
          onTap: _onbodyTap,
          child: PopScope(
            canPop: false,
            onPopInvoked: (didPop) {
              if (!didPop &&
                  ref.read(currentScreenProvider.notifier).state == 2) {
                _showBackDialog();
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Row(
                  children: [
                    GestureDetector(
                      onTap: _showBackDialog,
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
                  child: Form(
                    key: _formKey,
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
                              child: TextFormField(
                                controller: _expertTypeController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: '전문가 상담',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onPressed: () =>
                                        _showExpertSelectionModal(context),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '전문가를 선택해주세요.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null) {
                                    formData['expertType'] = value;
                                  }
                                },
                              ),
                            ),
                            Gaps.h16, // 상담 주제 선택 필드
                            Expanded(
                              child: TextFormField(
                                controller: _consultationTopicController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: '상담 주제',
                                  suffixIcon: IconButton(
                                    icon: const Icon(Icons.arrow_drop_down),
                                    onPressed: () =>
                                        _showConsultationTopicSelectionModal(
                                      context,
                                      _expertTypeController.text,
                                    ),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return '상담주제를 선택해주세요.';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  if (value != null) {
                                    formData['consultationTopic'] = value;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Gaps.v20,
                        // 제목(10자 이상*)과 textfield
                        Row(
                          // key: _titleKey,
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
                                  text: "${_titleText.length}",
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

                        TextFormField(
                          onTap: () => _ontitleStartWriting(),
                          controller: _titleEditingController,
                          decoration: const InputDecoration(
                              hintText: "1개의 질문을 구체적으로 해주세요."),
                          validator: (value) {
                            if (value == null || value.length < 10) {
                              return '질문을 10자 이상 입력해주세요.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              formData['title'] = value;
                            }
                          },
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
                                  characterCount: 5,
                                ),
                              ],
                            ),
                            if (_contentisWriting)
                              RichText(
                                text: TextSpan(
                                  text: "${_descriptionText.length}",
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
                        TextFormField(
                          onTap: _oncontentStartWriting,
                          controller: _descriptionEditingController,
                          maxLines: null,
                          minLines: 8,
                          decoration:
                              const InputDecoration(hintText: "구체적으로 작성부탁드려요."),
                          validator: (value) {
                            if (value == null || value.length < 5) {
                              return '내용을 200자 이상 입력해주세요.'; // 필요에 따라 적절한 검증 로직을 추가
                            }
                            return null;
                          },
                          onSaved: (value) {
                            if (value != null) {
                              formData['description'] = value;
                            }
                          },
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
            ),
          ),
        );
      },
    );
  }
}



// 일단 글로벌키 이건 빼자. 사용자 경험을 중시해야함. 내 수준에서는 일단 에러가 먹을 확률이 생김
// void _scrollToGlobalKey(GlobalKey key) async {
//     final context = key.currentContext;
//     if (context != null) {
//       await Scrollable.ensureVisible(context,
//           duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//     }
//   }
/**
 * 
 * 
ref.watch()와 ref.listen()은 서로 다른 목적과 사용 시나리오를 가지고 있습니다. 둘 다 Riverpod의 상태 관리 기능을 활용하지만, 그 작동 방식과 적용 분야에서 차이가 있습니다.

ref.watch()
ref.watch()는 호출된 컨텍스트의 Widget이 주어진 Provider의 상태에 종속됨을 선언합니다.
이는 상태가 변경될 때마다 해당 Widget이 리빌드되어야 함을 의미합니다.
주로 상태의 최신 값에 따라 UI를 동적으로 변경하고자 할 때 사용됩니다.
ref.listen()
ref.listen()은 Provider의 상태 변화를 감지하고, 변화가 있을 때마다 특정 작업을 수행하도록 설정합니다.
이 메서드는 상태 변화에 따라 UI를 업데이트하는 대신, 로직을 실행하거나 사용자에게 알림을 주는 등의 부수적인 효과(side effects)를 처리하는 데 유용합니다.
상태 변화에 따라 다이얼로그를 표시하거나, 로깅, 데이터 전송 등의 작업을 수행할 때 사용됩니다.
예제 상황에서의 차이
ref.watch().when(...)을 사용하는 경우, when() 메서드가 포함된 Widget 자체가 상태 변경에 따라 재구성됩니다. 즉, 상태 변경이 UI의 재구성을 직접적으로 유발합니다.
ref.listen()을 사용하는 경우, 상태의 변경을 감지하고 해당 변경에 대응하여 독립적인 액션을 수행할 수 있습니다. 예를 들어, 데이터 로딩 상태에서 에러가 발생했을 때 다이얼로그를 표시하는 것과 같은 작업이 이에 해당합니다. UI 자체의 재구성을 유발하지 않고, 필요한 부수적인 반응만을 처리할 수 있습니다.
각각의 메서드는 상황에 따라 선택하여 사용하며, 특히 UI 업데이트와 부수적인 효과를 분리할 필요가 있을 때 ref.listen()의 사용이 더 적합할 수 있습니다.
 */