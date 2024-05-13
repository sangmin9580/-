import 'package:flutter/material.dart';
import 'package:project/constants/default.dart';
import 'package:project/constants/gaps.dart';
import 'package:project/constants/sizes.dart';

class PetInformationBox extends StatelessWidget {
  const PetInformationBox({
    super.key,
    required this.name,
    required this.age,
    required this.breed,
    required this.bio,
    required this.weight,
  });

  final String name;
  final String age;
  final String breed;
  final String bio;
  final double weight;

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
      padding: const EdgeInsets.only(
        top: Sizes.size5,
        bottom: Sizes.size5,
        left: horizontalPadding,
        right: horizontalPadding,
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
              Expanded(
                child: Column(
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
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                breed,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            verticalDivider,
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                age,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            verticalDivider,
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                bio,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            verticalDivider,
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                "$weight kg",
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
