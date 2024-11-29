import 'package:flutter/material.dart';

class BookLoadingIndicator extends StatefulWidget {
  const BookLoadingIndicator({Key? key}) : super(key: key);

  @override
  _BookLoadingIndicatorState createState() => _BookLoadingIndicatorState();
}

class _BookLoadingIndicatorState extends State<BookLoadingIndicator>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _flipAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _flipAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 100,
        height: 100,
        child: AnimatedBuilder(
          animation: _flipAnimation,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.rotationY(_flipAnimation.value * 3.14),
              alignment: Alignment.center,
              child: child,
            );
          },
          child: Image.network(
            'https://static.vecteezy.com/system/resources/previews/003/731/077/non_2x/open-book-bookmark-free-vector.jpg', // Add a book image here
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
