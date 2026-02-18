import 'package:flutter/material.dart';

class ShrinkButton extends StatefulWidget {
  const ShrinkButton(
    {
      super.key,
      required this.onPressed,
      required this.child,
      this.shrinkFactor = 0.95,
      this.duration  = const Duration(microseconds: 150)
    }
  );

  final VoidCallback onPressed;
  final Widget child;
  final double shrinkFactor;
  final Duration duration;


  @override
  State<ShrinkButton> createState() => _ShrinkButtonState();
}

class _ShrinkButtonState extends State<ShrinkButton> {

  double scale = 1.0;

  void onTapDown(TapDownDetails _){
    setState(() {
      scale = widget.shrinkFactor; 
    });
  }

  void onTapUp(TapUpDetails _){
    setState(() {
      scale = 1.0;
      widget.onPressed();
    });
  }

  void onTapCancel(){
    setState(() {
      scale = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: onTapDown,
      onTapUp: onTapUp,
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        scale: scale, 
        duration: widget.duration,
        child: widget.child,
      ),
    );
  }
}