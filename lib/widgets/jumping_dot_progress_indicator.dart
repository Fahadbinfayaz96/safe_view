import 'package:flutter/material.dart';

import '../untilities/app_colors.dart';

class JumpingDots extends StatefulWidget {
  final int numberOfDots;
  final Color color;
  final Duration duration;

  const JumpingDots({
    super.key,
    this.numberOfDots = 3,
    this.color = AppColors.black,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<JumpingDots> createState() => _JumpingDotsState();
}

class _JumpingDotsState extends State<JumpingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration * widget.numberOfDots,
      vsync: this,
    )..repeat();

    _animations = List.generate(widget.numberOfDots, (index) {
      final start = index / widget.numberOfDots;
      final end = (index + 1) / widget.numberOfDots;
      return Tween<double>(begin: 0, end: -10).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.easeInOut),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.numberOfDots, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Dot(color: widget.color),
              ),
            );
          },
        );
      }),
    );
  }
}

class Dot extends StatelessWidget {
  final Color color;
  const Dot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
