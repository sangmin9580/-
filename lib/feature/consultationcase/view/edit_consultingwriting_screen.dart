import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
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

class ConsultationEditScreen extends ConsumerStatefulWidget {
  final ConsultationWritingModel consultation;
  const ConsultationEditScreen({Key? key, required this.consultation})
      : super(key: key);

  @override
  _ConsultationEditScreenState createState() => _ConsultationEditScreenState();
}

class _ConsultationEditScreenState
    extends ConsumerState<ConsultationEditScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _titleEditingController;
  late TextEditingController _descriptionEditingController;
  late TextEditingController _expertTypeController;
  late TextEditingController _consultationTopicController;
  String _titleText = "";
  String _descriptionText = "";
  List<File> _images = [];
  List<String> oldImageUrls = [];
  bool _titleisWriting = false;
  bool _contentisWriting = false;
  bool hasNavigated = false;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic> formData = {};

  File? _image;
  InheritedWidget? inheritedWidgetReference;
  @override
  void initState() {
    super.initState();
    _titleEditingController =
        TextEditingController(text: widget.consultation.title);
    _titleEditingController.addListener(() {
      _titleText = _titleEditingController.text;
      print(" is title not empty? :  ${_titleText.isNotEmpty}");
      setState(() {});
    });
    _descriptionEditingController =
        TextEditingController(text: widget.consultation.description);
    _descriptionEditingController.addListener(() {
      _descriptionText = _descriptionEditingController.text;
      setState(() {});
    });
    _expertTypeController =
        TextEditingController(text: widget.consultation.expertType);
    _consultationTopicController =
        TextEditingController(text: widget.consultation.consultationTopic);

    oldImageUrls = widget.consultation.photos; // 이미 저장된 이미지 URL 리스트

    // URL을 사용해 File 객체 리스트 초기화 (표시용)
    _images = oldImageUrls.map((url) => File(url)).toList();
    formData = {
      'consultationId': widget.consultation.consultationId,
      'userId': widget.consultation.userId,
      'petId': widget.consultation.petId,
      'expertType': widget.consultation.expertType,
      'consultationTopic': widget.consultation.consultationTopic,
      'photos': _images
          .map((file) => file.path)
          .toList(), // Assuming paths need to be stored
    };
  }

  Future<void> _pickImage() async {
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

  Future<void> _onEditTap() async {
    if (_formKey.currentState != null) {
      if (_formKey.currentState!.validate()) {
        bool shouldUpdate = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("글 수정 확인"),
              content:
                  const Text("입력하신 내용으로 상담글을 수정하시겠습니까? 전에 작성된 내용은 복구되지 않습니다."),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false); // 모달 창 닫기 및 취소 반환
                  },
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true); // 모달 창 닫기 및 확인 반환
                  },
                  child: const Text("확인"),
                ),
              ],
            );
          },
        );

        if (shouldUpdate == true) {
          _formKey.currentState!.save();

          // Extracting form data directly
          ConsultationWritingModel model = ConsultationWritingModel(
            consultationId: formData['consultationId'],
            userId: formData['userId'],
            petId: formData['petId'],
            expertType: formData['expertType'],
            consultationTopic: formData['consultationTopic'],
            title: _titleEditingController.text,
            description: _descriptionEditingController.text,
            photos: _images.map((file) => file.path).toList(),
            timestamp: DateTime
                .now(), // Consider whether to update or keep the original
          );

          print('Update consultation started');
          // ViewModel의 메소드 호출
          await ref.read(consultationProvider.notifier).updateConsultation(
                model: model,
                newImages: _images,
                oldImageUrls: oldImageUrls,
                context: context,
              );

          if (mounted) {
            Navigator.of(context).pop();
          }
        }
      }
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

  void _onbodyTap() {
    FocusScope.of(context).unfocus();
    setState(() {
      _titleisWriting = false;
      _contentisWriting = false;
    });
  }

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

  void _showBackDialog() {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('수정을 포기하시겠습니까?'),
          content: const Text('내용이 수정되지 않습니다..'),
          actions: <Widget>[
            TextButton(
              child: const Text('취소'),
              onPressed: () {
                Navigator.pop(context); // 다이얼로그를 닫습니다.
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('확인'),
              onPressed: () {
                Navigator.pop(context); // 다이얼로그를 닫습니다.
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  bool _canSignup() {
    if (_titleText.length > 5 && _descriptionText.length > 5) {
      return true;
    }
    return false;
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    inheritedWidgetReference =
        context.dependOnInheritedWidgetOfExactType<InheritedWidget>();
  }

  @override
  void dispose() {
    // `dispose` 메서드에서 `inheritedWidgetReference`를 사용
    // Note: 실제로 inheritedWidgetReference를 참조할 필요가 없는 경우 삭제 가능
    _titleEditingController.dispose();
    _descriptionEditingController.dispose();
    _expertTypeController.dispose();
    _consultationTopicController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedPetIndex = ref.watch(petEditViewModelProvider);
    final petList = ref.watch(petNavigationProvider);

    PetModel? selectedPet;

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
                automaticallyImplyLeading: false,
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
                      "상담글 수정",
                      style: TextStyle(
                        fontSize: Sizes.size20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                actions: [
                  GestureDetector(
                    onTap: _onEditTap,
                    child: SizedBox(
                      width: Sizes.size64,
                      child: Text(
                        "수정하기",
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
                        Gaps.v32,
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
                                  "상담글 수정 전 필수 안내사항",
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
                                        "1. 직전에 작성한 내용은 모두 삭제되며, 복구할 수 없습니다.",
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
