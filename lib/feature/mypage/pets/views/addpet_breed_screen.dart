import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/views/addpet_info_screen.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_info_vm.dart';
import 'package:project/feature/mypage/widgets/dogbreedpicker.dart';
import 'package:project/feature/mypage/widgets/nextbutton.dart';

class AddPetKindScreen extends ConsumerStatefulWidget {
  const AddPetKindScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPetKindScreenState();
}

class _AddPetKindScreenState extends ConsumerState<AddPetKindScreen> {
  late final TextEditingController _breedController;

  String? _breedText = "";

  @override
  void initState() {
    super.initState();
    _breedController = TextEditingController();

    _breedController.addListener(() {
      _breedText = _breedController.text;
      setState(() {});
    });
  }

  void _onNextTap() {
    final disabled = _breedText == null || _breedText!.isEmpty;

    if (!disabled) {
      //ref.read(addPetViewModelProvider.notifier).updateBreed(_breedText!); 일단 없애두자.
      final state = ref.read(petCreateForm.notifier).state;
      ref.read(petCreateForm.notifier).state = {
        ...state,
        'breed': _breedText,
      };

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddPetInfoScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _breedController.dispose();
    super.dispose();
  }

  void _showDogBreedPicker(BuildContext context) async {
    final String? pickedBreed = await showModalBottomSheet<String>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return const DogBreedPicker();
      },
    );
    if (pickedBreed != null) {
      setState(() {
        _breedController.text = pickedBreed;
        _breedController.text = pickedBreed; // 선택된 종류를 TextField에 설정
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "강아지 추가",
          style: appbarTitleStyle,
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: () => ref
                .read(addPetViewModelProvider.notifier)
                .onTapHomeIcon(context),
            child: const FaIcon(
              FontAwesomeIcons.house,
              size: Sizes.size20,
            ),
          ),
          Gaps.h10,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "우리 댕댕이의",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              "견종은 무엇인가요?",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v32,
            TextField(
              controller: _breedController,
              decoration: const InputDecoration(hintText: "선택하세요"),
              readOnly: true, // TextField를 읽기 전용으로 설정
              onTap: () => _showDogBreedPicker(context),
            ),
            const Spacer(), // 나머지 공간을 모두 차지하여 버튼을 밀어내립니다.
            GestureDetector(
              onTap: _onNextTap,
              child: NextButton(
                disabled: _breedText == null || _breedText!.isEmpty,
                text: "다음",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
