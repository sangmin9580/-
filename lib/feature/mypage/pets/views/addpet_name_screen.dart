import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/views/addpet_breed_screen.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_info_vm.dart';

import 'package:project/feature/mypage/widgets/nextbutton.dart';

class AddPetNameScreen extends ConsumerStatefulWidget {
  const AddPetNameScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPetNameScreenState();
}

class _AddPetNameScreenState extends ConsumerState<AddPetNameScreen> {
  late final TextEditingController _textEditingController;
  String _name = "";
  String? _errorText = "";

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _textEditingController.addListener(() {
      _name = _textEditingController.text;

      setState(() {
        if (_name.isEmpty) {
          _errorText = "이름을 입력해주세요";
        } else if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(_name)) {
          _errorText = "이름에 특수문자를 쓸 수 없습니다.";
        } else if (_name.length > 10) {
          _errorText = "10글자 이하의 이름만 가능합니다.";
        } else {
          _errorText = null;
        }
      });
    });
  }

  void _onNextTap() {
    final disabled = _errorText != null;

    if (!disabled) {
      //ref.read(addPetViewModelProvider.notifier).updateName(_name); 일단 필요없는듯?
      ref.read(petCreateForm.notifier).state = {'name': _name};

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddPetKindScreen(),
        ),
      );
    }
  }

  void _onbodyTap() {
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onbodyTap,
      child: Scaffold(
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
                "사랑스러운 댕댕이의",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Text(
                "이름과 사진을 등록해주세요",
                style: TextStyle(
                  fontSize: Sizes.size20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Gaps.v32,
              const Align(
                alignment: Alignment.center,
                child: Text("아바타"),
              ),
              Gaps.v32,
              TextField(
                controller: _textEditingController,
                decoration: InputDecoration(
                  hintText: "초코",
                  errorText: _errorText,
                ),
              ),
              const Spacer(), // 나머지 공간을 모두 차지하여 버튼을 밀어내립니다.
              GestureDetector(
                onTap: _onNextTap,
                child: NextButton(
                  disabled: _errorText != null,
                  text: "다음",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
