import 'package:daum_postcode_search/daum_postcode_search.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';
import 'package:project/feature/mypage/users/viewmodel/user_vm.dart';

class ProfileEditScreen extends ConsumerStatefulWidget {
  const ProfileEditScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ProfileEditScreenState();
}

class _ProfileEditScreenState extends ConsumerState<ProfileEditScreen> {
  late final TextEditingController _nickNameEditingController;
  late final TextEditingController _addressController;

  late final TextEditingController _detailAddressController;

  DataModel? dataModel;

  @override
  void initState() {
    super.initState();
    _detailAddressController = TextEditingController();
    _detailAddressController.text =
        ref.read(usersProvider).value?.detailAddress ?? " ";
    _addressController = TextEditingController();
    _addressController.text = ref.read(usersProvider).value?.address ?? " ";
    _nickNameEditingController = TextEditingController();
    _nickNameEditingController.text =
        ref.read(usersProvider).value?.nickName ?? "";
  }

  void _onBodyTap() {
    FocusScope.of(context).unfocus();
  }

  void _openAddressSearch() async {
    final DataModel addressData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SafeArea(child: DaumPostcodeSearch()),
      ),
    );

    // addressData 객체에서 필요한 주소 정보를 텍스트 필드에 설정

    //ref.read(usersProvider.notifier).updateAddressFromSearch(addressData);
    _addressController.text = addressData.address;
    _detailAddressController.clear();
  }

  Future<void> _onEditComplete() async {
    final address = _addressController.text;
    final detailAddress = _detailAddressController.text;
    final nickName = _nickNameEditingController.text;

    // 확인 다이얼로그 표시
    final shouldUpdate = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('프로필을 수정하시겠습니까?'),
        content: const Text('변경사항을 저장하려면 "예"를 선택하세요.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('아니오'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('예'),
          ),
        ],
      ),
    );

    // 사용자가 '예'를 선택한 경우, 주소 업데이트
    if (shouldUpdate ?? false) {
      await ref.read(usersProvider.notifier).updateCompleteProfile(
            address,
            detailAddress,
            nickName,
          );

      _addressController.text = address;
      _detailAddressController.text = detailAddress;
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onBodyTap,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "내 정보 수정",
            style: TextStyle(
              fontSize: Sizes.size20,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => _onEditComplete(),
              child: const Text(
                "완료",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(
                    0xFFC78D20,
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
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gaps.v32,
                const Align(
                  alignment: Alignment.center,
                  child: Text("아바타"),
                ),
                Gaps.v32,
                const Text(
                  "닉네임",
                  style: TextStyle(
                    fontSize: Sizes.size16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Gaps.v20,
                TextField(
                  textAlign: TextAlign.center,
                  controller: _nickNameEditingController,
                  decoration: const InputDecoration(
                    hintText: "예 : 멍제자",
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size5,
                      ),
                      title: const Text(
                        "이름",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        "윤상민",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size5,
                      ),
                      title: const Text(
                        "생년월일",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        "1995-03-13",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size5,
                      ),
                      title: const Text(
                        "핸드폰 번호",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: Text(
                        "010-3001-9580",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: Sizes.size5,
                      ),
                      title: const Text(
                        "주소",
                        style: TextStyle(
                          fontSize: Sizes.size16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      trailing: GestureDetector(
                        onTap: _openAddressSearch,
                        child: const Text(
                          "주소 변경 >",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: Sizes.size12,
                            color: Color(0xFFC78D20),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            40,
                          ),
                        ),
                        enabled: false,
                        labelText: "주소",
                      ),
                    ),
                    Gaps.v10,
                    TextField(
                      controller: _detailAddressController,
                      decoration: const InputDecoration(
                        labelText: "상세주소",
                        hintText: "예: 아파트 동/호수",
                        border: OutlineInputBorder(),
                      ),
                      enabled: true, // 사용자가 입력할 수 있습니다.
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
