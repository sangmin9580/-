import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/views/addpet_confirm_screen.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_info_vm.dart';
import 'package:project/feature/mypage/widgets/nextbutton.dart';

class AddPetInfoScreen extends ConsumerStatefulWidget {
  const AddPetInfoScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPetKindScreenState();
}

class _AddPetKindScreenState extends ConsumerState<AddPetInfoScreen> {
  late final TextEditingController _birthDateController;
  late final TextEditingController _genderController;
  late final TextEditingController _neuteredController;
  late final TextEditingController _weightController;

  final List<String> genders = ['남', '여'];
  final List<String> neuteredOptions = ['예', '아니오'];

  late final viewModel = ref.read(addPetViewModelProvider.notifier);
  late final model = ref.watch(addPetViewModelProvider);

  @override
  void initState() {
    super.initState();

    final currentValue = ref.read(petCreateForm.notifier).state;

// urrentValue['birthDate']를 그냥 넣었더니 null이 될수도 있다고 해서 기본값을 설정해줌
    DateTime birthDate;
    if (currentValue['birthDate'] is DateTime) {
      birthDate = currentValue['birthDate'];
    } else {
      birthDate = DateTime.now(); // 잘못된 값이거나 누락된 경우 기본값으로 현재 날짜 사용
    }

    // 각 컨트롤러의 초기값을 모델의 현재 상태에 기반하여 설정합니다.
    _birthDateController = TextEditingController(
      text: DateFormat('yyyy-MM-dd').format(
        birthDate,
      ),
    );

    _genderController = TextEditingController(
        text: currentValue['gender']?.isNotEmpty == true
            ? currentValue['gender']
            : '성별 선택');

    _neuteredController = TextEditingController(
      text: currentValue['isNeutered'] != null
          ? (currentValue['isNeutered']! ? '예' : '아니오')
          : '중성화 여부 선택',
    );

    _weightController = TextEditingController(
        text: ((currentValue['weight'] as num?) ?? 0) > 0
            ? currentValue['weight'].toString()
            : '');
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
                  "gender": _genderController.text,
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
                  "gender": _genderController.text,
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
                  "isNeutered": _neuteredController.text,
                };

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
                  "isNeutered": _neuteredController.text,
                };
                Navigator.pop(context); // 다이얼로그 닫기
              },
              child: const Text('아니오'),
            ),
          ],
        );
      },
    );
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
        "birthDate": _birthDateController.text,
      };
    }
  }

  void _onNextTap() {
    print(isFormValid(ref));
    print(ref.read(petCreateForm).values);

    if (isFormValid(ref)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddPetConfirmScreen(),
        ),
      );
    } else {
      return;
    }
  }

  void _onScaffoldTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _birthDateController.dispose();
    _genderController.dispose();
    _neuteredController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onScaffoldTap,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "강아지 추가",
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
              bottom: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "기본적인 정보를 알려주세요",
                  style: TextStyle(
                    fontSize: Sizes.size20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "최대한 정확하게 작성부탁드립니다",
                  style: TextStyle(
                    fontSize: Sizes.size14,
                    color: Colors.grey.shade500,
                  ),
                ),
                Gaps.v32,
                Gaps.v10,
                TextField(
                  controller: _birthDateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '생년월일',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  onTap: () => _selectDate(context),
                ),
                Gaps.v32,
                TextField(
                  controller: _genderController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '성별',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    _showGenderDialog();
                  },
                ),
                Gaps.v32,
                TextField(
                  controller: _neuteredController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '중성화 여부',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: () {
                    _showNeuteredDialog();
                  },
                ),
                Gaps.v32,
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: '무게 (kg)',
                  ),
                  onChanged: (value) {
                    final double? weight = double.tryParse(value);
                    if (weight != null) {
                      final state = ref.read(petCreateForm.notifier).state;
                      ref.read(petCreateForm.notifier).state = {
                        ...state,
                        "weight": _weightController.text,
                      };
                      setState(() {});
                    }
                  },
                ),
                Gaps.v96,
                Gaps.v60,
                GestureDetector(
                  onTap: _onNextTap,
                  child: NextButton(
                    disabled: !isFormValid(ref),
                    text: "다음",
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
