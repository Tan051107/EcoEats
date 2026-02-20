import 'package:flutter/material.dart';
import 'package:frontend/data/constants.dart';

class RadioCardSelector extends StatefulWidget {
  const RadioCardSelector(
    {
      super.key,
      required this.label,
      required this.subtitle,
      required this.activeCard,
    }
  );

  final String label;
  final String subtitle;
  final String activeCard;

  @override
  State<RadioCardSelector> createState() => _RadioCardSelectorState();
}

class _RadioCardSelectorState extends State<RadioCardSelector> {
  @override
  Widget build(BuildContext context) {
    bool isActive = widget.activeCard == widget.label;
    return Container(
        width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: lightGreen,
            border: Border.all(
              color: isActive ? normalGreen : Colors.transparent,
              width: 2.0
            )
          ),
          child: Padding(
            padding: EdgeInsets.all(18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: headingThreeText,
                    ),
                    Text(
                      widget.subtitle,
                      style: smallText,
                    )
                  ],
                ),
                Container(
                  width: 25.0,
                  height: 25.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isActive ? normalGreen : Colors.transparent,
                    border: Border.all(
                      color:isActive ? normalGreen : gray,
                      width: 3.0
                    )
                  ),
                )
              ],
            ),
          ),
        );
  }
}