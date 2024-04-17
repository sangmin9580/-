import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/mypage/view/all_info_edit_screen.dart';
import 'package:project/mypage/viewmodel/pet_info_vm.dart';
import 'package:project/mypage/widgets/petinformationbox.dart';

class AddPetConfirmScreen extends ConsumerStatefulWidget {
  const AddPetConfirmScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddPetKindScreenState();
}

class _AddPetKindScreenState extends ConsumerState<AddPetConfirmScreen> {
  void _onNextTap() {}

  @override
  Widget build(BuildContext context) {
    final petInfo = ref.watch(addPetViewModelProvider);

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
              name: petInfo.name,
              age: ref.read(addPetViewModelProvider.notifier).getAge(
                    petInfo.birthDate,
                  ),
              breed: petInfo.breed,
              bio: petInfo.gender,
              weight: petInfo.weight,
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
              ],
            )
          ],
        ),
      ),
    );
  }
}
