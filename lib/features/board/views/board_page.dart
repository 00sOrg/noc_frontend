import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:sos/features/board/viewmodels/board_viewmodel.dart';
import 'package:sos/features/board/views/widgets/board_carousel_widget.dart';
import 'package:sos/features/board/views/widgets/board_search_bar.dart';
import 'package:sos/shared/styles/global_styles.dart';

class BoardPage extends ConsumerStatefulWidget {
  const BoardPage({super.key});

  @override
  ConsumerState<BoardPage> createState() => _BoardPageState();
}

class _BoardPageState extends ConsumerState<BoardPage> {
  // final ScrollController _scrollController = ScrollController();
  Timer? _hideDescTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(boardViewModelProvider.notifier).refreshBoard();
    });

    _hideDescTimer = Timer(const Duration(seconds: 5), () {});
  }

  @override
  void dispose() {
    _hideDescTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final boardItems = ref.watch(boardViewModelProvider);
    return SafeArea(
      bottom: false,
      child: KeyboardDismisser(
        child: Scaffold(
          body: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: BoardSearchBar(),
              ),
              const Divider(
                color: AppColors.finalGray,
                height: 1,
                thickness: 1,
              ),
              const Spacer(),
              const BoardCarouselWidget(),
              //const SizedBox(height: 33),
            ],
          ),
        ),
      ),
    );
  }
}
