import 'package:flutter/material.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class PetInformationBox extends StatelessWidget {
  const PetInformationBox({
    super.key,
    required this.name,
    required this.age,
    required this.kind,
    required this.bio,
    required this.weight,
  });

  final String name;
  final int age;
  final String kind;
  final String bio;
  final String weight;

  @override
  Widget build(BuildContext context) {
    final verticalDivider = VerticalDivider(
      width: 10,
      thickness: 2,
      color: Colors.grey.shade400,
      indent: 3,
      endIndent: 3,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: Sizes.size72,
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey.shade500,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            left: verticalPadding,
          ),
          child: Row(
            children: [
              const CircleAvatar(),
              Gaps.h10,
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name),
                  SizedBox(
                    height: 20,
                    child: DefaultTextStyle(
                      style: TextStyle(
                        fontSize: Sizes.size12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade500,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(kind),
                          verticalDivider,
                          Text("$age살"),
                          verticalDivider,
                          Text(bio),
                          verticalDivider,
                          Text("$weight kg"),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
