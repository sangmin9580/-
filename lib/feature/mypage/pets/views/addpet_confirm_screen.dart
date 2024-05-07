import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/common/viewmodel/main_navigation_vm.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_navigation_vm.dart';
import 'package:project/feature/mypage/pets/views/all_info_edit_screen.dart';
import 'package:project/feature/mypage/pets/viewmodel/pet_info_vm.dart';
import 'package:project/feature/mypage/pets/views/pet_navigation_screen.dart';
import 'package:project/feature/mypage/widgets/petinformationbox.dart';

class AddPetConfirmScreen extends ConsumerStatefulWidget {
  const AddPetConfirmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPetKindScreenState();
}

class _AddPetKindScreenState extends ConsumerState<AddPetConfirmScreen> {
  void _createPetProfile() {
    print("click confirmContainer");
    ref.read(addPetViewModelProvider.notifier).processPetCreation(
          ref.read(petCreateForm.notifier).state,
        );

    ref.read(mainNavigationViewModelProvider.notifier).goToMyPage();
    Navigator.of(context).popUntil((route) => route.isFirst);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PetNavigationScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final petInfo = ref.watch(addPetViewModelProvider);
    final petprofileForm = ref.read(petCreateForm);

    DateTime? birthDate =
        DateTime.tryParse(petprofileForm["birthDate"]?.toString() ?? '');
    birthDate ??= DateTime.now();

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
              "정보를 확인해주세요",
              style: TextStyle(
                fontSize: Sizes.size20,
                fontWeight: FontWeight.w600,
              ),
            ),
            Gaps.v32,

            PetInformationBox(
              name: petprofileForm["name"],
              age: ref.read(addPetViewModelProvider.notifier).getAge(
                    birthDate,
                  ),
              // getAge가 DateTime을 받는데 null일 수도 있다고 에러가 나서, 위에서 한번 처리해주고 변수를 작성함
              breed: petprofileForm["breed"],
              bio: petprofileForm["gender"] ?? "no gender provided",
              weight:
                  double.tryParse(petprofileForm["weight"]?.toString() ?? '') ??
                      0,
            ),

            const Spacer(), // 나머지 공간을 모두 차지하여 버튼을 밀어내립니다.
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllinfoEditScreen(),
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: Sizes.size60,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color(0xFFC78D20),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: const Text(
                      "잘못 입력했어요",
                      style: TextStyle(
                        fontSize: Sizes.size16,
                        fontWeight: FontWeight.w600,
                        color: Color(
                          0xFFC78D20,
                        ),
                      ),
                    ),
                  ),
                ),
                Gaps.h10,
                Expanded(
                  child: GestureDetector(
                    onTap: _createPetProfile,
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5,
                      height: Sizes.size60,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC78D20),
                        borderRadius: BorderRadius.circular(
                          10,
                        ),
                      ),
                      child: const Text(
                        "확인 했어요",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
