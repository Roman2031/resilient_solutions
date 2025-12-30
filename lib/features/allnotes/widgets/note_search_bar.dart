import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NoteSearchBar extends StatefulWidget {
  final ValueChanged<String> onSearchChanged;
  final String? initialValue;

  const NoteSearchBar({
    super.key,
    required this.onSearchChanged,
    this.initialValue,
  });

  @override
  State<NoteSearchBar> createState() => _NoteSearchBarState();
}

class _NoteSearchBarState extends State<NoteSearchBar> {
  late final TextEditingController _controller;
  Timer? _debounce;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    setState(() {
      _hasText = _controller.text.isNotEmpty;
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      widget.onSearchChanged(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onSearchChanged,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear, color: Color(0xff0082DF)),
                onPressed: () {
                  _controller.clear();
                  widget.onSearchChanged('');
                },
              )
            : const Icon(Icons.search, color: Color(0xff0082DF)),
        hintText: "Search notes...",
        hintStyle: const TextStyle(color: Color(0xffA6A6A6)),
        fillColor: const Color(0xffFFFFFF),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
