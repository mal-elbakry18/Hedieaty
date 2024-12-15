/*import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Define the color animation (from button color to white)
    _colorAnimation = ColorTween(
      begin: widget.color,
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(), // Start the animation
      onTapUp: (_) {
        _controller.reverse(); // Reverse the animation
        widget.onPressed(); // Trigger the button action
      },
      onTapCancel: () => _controller.reverse(), // Reverse animation if tap is canceled
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _colorAnimation.value, // Animate the background color
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: _colorAnimation.value == Colors.white
                    ? widget.color // Text color becomes the button color when pressed
                    : Colors.white, // Default text color
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }
}
*/

import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    required this.label,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  _AppButtonState createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    // Define color animation (button color to white)
    _colorAnimation = ColorTween(
      begin: widget.color,
      end: Colors.white,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool isHovering) {
    setState(() {
      _isHovering = isHovering;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(), // Start animation on press
        onTapUp: (_) {
          _controller.reverse(); // Reverse animation on release
          widget.onPressed(); // Trigger the button's action
        },
        onTapCancel: () => _controller.reverse(), // Reverse if tap is canceled
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 15),
              width: double.infinity,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _isHovering
                    ? widget.color.withOpacity(0.8) // Hover effect
                    : _colorAnimation.value, // Animate press effect
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.label,
                style: TextStyle(
                  color: _colorAnimation.value == Colors.white
                      ? widget.color // Text color becomes button color when pressed
                      : Colors.white, // Default text color
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
