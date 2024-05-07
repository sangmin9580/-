import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/users/viewmodel/user_vm.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_info_vm.dart';
import 'package:project/feature/mypage/widgets/avatar.dart';
import 'package:project/feature/mypage/widgets/dogbreedpicker.dart';
import 'package:project/feature/mypage/widgets/fixbutton.dart';

class AllinfoEditScreen extends ConsumerStatefulWidget {
  const AllinfoEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AllinfoEditScreenState();
}

void _onScaffoldTap(BuildContext context) {
  FocusScope.of(context).unfocus();
}

class _AllinfoEditScreenState extends ConsumerState<AllinfoEditScreen> {
  late final TextEditingController _nameEditingController;
  late final TextEditingController _breedEditingController;
  late final TextEditingController _birthDateController;
  late final TextEditingController _genderController;
  late final TextEditingController _neuteredController;
  late final TextEditingController _weightController;

  late final petInfoNotifier = ref.watch(addPetViewModelProvider.notifier);
  late final petInfo = ref.read(addPetViewModelProvider);
  late final petprofileForm = ref.read(petCreateForm);

  @override
  void initState() {
    DateTime? birthDate =
        DateTime.tryParse(petprofileForm["birthDate"]?.toString() ?? '');
    birthDate ??= DateTime.now();

    super.initState();
    _nameEditingController =
        TextEditingController(text: petprofileForm["name"]);
    _breedEditingController =
        TextEditingController(text: petprofileForm["breed"]);
    _birthDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(birthDate),
    );

    _genderController = TextEditingController(text: petprofileForm["gender"]);
    _neuteredController = TextEditingController(
      text: petprofileForm["isNetured"] != null
          ? (petprofileForm["isNetured"]! ? '예' : '아니오')
          : '중성화 여부 선택',
    );

    _weightController =
        TextEditingController(text: "${petprofileForm["weight"]}");
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 초기 선택 날짜를 현재 날짜로 설정
      firstDate: DateTime(2000), // 선택 가능한 가장 이른 날짜
      lastDate: DateTime.now(), // 선택 가능한 가장 늦은 날짜
    );
    if (pickedDate != null) {
      // 사용자가 날짜를 선택한 경우
      _birthDateController.text = DateFormat('yyyy-MM-dd')
          .format(pickedDate); // 날짜 포맷을 'yyyy-MM-dd' 형태로 지정하여 텍스트 필드 업데이트

      final state = ref.read(petCreateForm.notifier).state;
      ref.read(petCreateForm.notifier).state = {
        ...state,
        "birthDate": pickedDate
      };
    }
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('성별 선택'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 성별 '남'을 선택했을 때의 처리
                _genderController.text = '남'; // TextField의 텍스트 업데이트
                final state = ref.read(petCreateForm.notifier).state;
                ref.read(petCreateForm.notifier).state = {
                  ...state,
                  "gender": '남',
                };
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('남'),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 성별 '여'를 선택했을 때의 처리
                _genderController.text = '여'; // TextField의 텍스트 업데이트
                final state = ref.read(petCreateForm.notifier).state;
                ref.read(petCreateForm.notifier).state = {
                  ...state,
                  "gender": '여',
                };
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('여'),
            ),
          ],
        );
      },
    );
  }

  void _showNeuteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('중성화 여부'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                // 중성화 '예'를 선택했을 때의 처리
                _neuteredController.text = '예'; // TextField의 텍스트 업데이트
                final state = ref.read(petCreateForm.notifier).state;
                ref.read(petCreateForm.notifier).state = {
                  ...state,
                  "isNeutered": true,
                }; // ViewModel의 상태 업데이트
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('예'),
            ),
            SimpleDialogOption(
              onPressed: () {
                // 중성화 '아니오'를 선택했을 때의 처리
                _neuteredController.text = '아니오'; // TextField의 텍스트 업데이트
                final state = ref.read(petCreateForm.notifier).state;
                ref.read(petCreateForm.notifier).state = {
                  ...state,
                  "isNeutered": false,
                }; // ViewModel의 상태 업데이트
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );
  }

  void onFixButtonTap() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameEditingController.dispose();
    _breedEditingController.dispose();
    _birthDateController.dispose();
    _genderController.dispose();
    _neuteredController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.read(usersProvider).value;
    return GestureDetector(
      onTap: () => _onScaffoldTap(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "강아지 정보 수정",
            style: appbarTitleStyle,
          ),
          centerTitle: true,
          actions: const [
            FaIcon(
              FontAwesomeIcons.house,
              size: Sizes.size20,
            ),
            Gaps.h10,
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: horizontalPadding,
              right: horizontalPadding,
              top: verticalPadding,
              bottom: Sizes.size96,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Avatar(
                      hasAvatar: userProfile!.hasAvatar, uid: userProfile.uid),
                ),
                Gaps.v32,
                const Text("이름"),
                Gaps.v10,
                TextField(
                  controller: _nameEditingController,
                  onChanged: (value) {
                    final state = ref.read(petCreateForm.notifier).state;
                    ref.read(petCreateForm.notifier).state = {
                      ...state,
                      "name": value,
                    };
                  },
                ),
                Gaps.v32,
                const Text("견종"),
                Gaps.v10,
                TextField(
                  controller: _breedEditingController,
                  decoration: const InputDecoration(
                    hintText: "견종을 선택하세요",
                  ),
                  readOnly: true, // 견종 선택기를 사용하기 때문에 읽기 전용으로 설정합니다.
                  onTap: () async {
                    // 견종 선택기를 표시하고, 사용자가 선택한 견종으로 상태를 업데이트합니다.
                    final String? pickedBreed =
                        await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) => const DogBreedPicker(),
                    );
                    if (pickedBreed != null) {
                      _breedEditingController.text = pickedBreed;
                      final state = ref.read(petCreateForm.notifier).state;
                      ref.read(petCreateForm.notifier).state = {
                        ...state,
                        "breed": pickedBreed,
                      };
                    }
                  },
                ),
                Gaps.v32,
                const Text("생년월일"),
                Gaps.v10,
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                ),
                Gaps.v32,
                const Text("성별"),
                Gaps.v10,
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    _showGenderDialog();
                  },
                ),
                Gaps.v32,
                const Text("중성화 수술 여부"),
                Gaps.v10,
                TextField(
                  controller: _neuteredController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    _showNeuteredDialog();
                  },
                ),
                Gaps.v32,
                const Text("몸무게"),
                Gaps.v10,
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '(kg)',
                  ),
                  onChanged: (value) {
                    final double? weight = double.tryParse(value);
                    if (weight != null) {
                      final state = ref.read(petCreateForm.notifier).state;
                      ref.read(petCreateForm.notifier).state = {
                        ...state,
                        "weight": weight,
                      };
                    }
                  },
                ),
                Gaps.v20,
                GestureDetector(
                    onTap: () => onFixButtonTap(),
                    child: const FixButton(disabled: false)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
