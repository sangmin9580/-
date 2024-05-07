import 'package:flutter/material.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';

class DogBreedPicker extends StatefulWidget {
  const DogBreedPicker({Key? key}) : super(key: key);

  @override
  _DogBreedPickerState createState() => _DogBreedPickerState();
}

class _DogBreedPickerState extends State<DogBreedPicker> {
  final List<String> _allBreeds = [
    '비글',
    '보더 콜리',
    '시베리안 허스키',
    '골든 리트리버',
    '래브라도 리트리버'
  ]; // 예시 강아지 종류
  List<String> _filteredBreeds = [];
  String _searchText = "";

  @override
  void initState() {
    super.initState();
    _filteredBreeds = _allBreeds;
  }

  void _filterBreeds(String text) {
    setState(
      () {
        _searchText = text;
        if (_searchText.isEmpty) {
          _filteredBreeds = _allBreeds;
        } else {
          _filteredBreeds = _allBreeds
              .where((breed) =>
                  breed.toLowerCase().contains(_searchText.toLowerCase()))
              .toList();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.75,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "견종을 검색해주세요",
            style: appbarTitleStyle,
          ),
          centerTitle: true,
          actions: [
            CloseButton(
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Gaps.h10,
          ],
        ),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              child: TextField(
                onChanged: _filterBreeds,
                decoration: const InputDecoration(
                  labelText: '검색',
                  suffixIcon: Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredBreeds.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_filteredBreeds[index]),
                    onTap: () {
                      // 여기서 선택된 항목 처리
                      Navigator.of(context).pop(_filteredBreeds[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
