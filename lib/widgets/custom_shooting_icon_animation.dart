import 'package:fit_pro_client/utils/constants.dart';
import 'package:flutter/cupertino.dart';

class ShootingIconsAnimation extends StatefulWidget {
  const ShootingIconsAnimation({super.key});

  @override
  ShootingIconsAnimationState createState() => ShootingIconsAnimationState();
}

class ShootingIconsAnimationState extends State<ShootingIconsAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  final int _iconCount = 6; // Number of shooting icons
  bool _isMainIconVisible = true; // Controls visibility of the icons

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Start the animation
    _controller.forward();

    // Add a listener to hide the icons when the animation completes
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() {
          _isMainIconVisible = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            if (_isMainIconVisible)
              for (int i = 0; i < _iconCount; i++)
                Transform.translate(
                  offset: Offset(
                    0, // Keep the x-axis constant
                    (_animation.value * (50 + i * 30)),
                  ),
                  child: Opacity(
                    opacity: _animation.value,
                    child: const Icon(
                      CupertinoIcons.chevron_down,
                      size: 24,
                      color: AppColors.tomatoRed,
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}