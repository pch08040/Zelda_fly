import 'package:flutter/material.dart';

class AnimationState extends StatefulWidget {
  const AnimationState({super.key, required this.builder});
  final Widget Function(bool) builder;
  @override
  State<AnimationState> createState() => _AnimationStateState();
}

class _AnimationStateState extends State<AnimationState> {
  bool state = false;
  bool isRun = true;
  
  @override
  void initState() {
    super.initState();
    event();
  }

  void event() async {
    // 특정 조건이 true인 동안 비동기 작업을 반복
    // await Future.doWhile() = 이 동작이 마무리 되어야 다음 코드 진행
    await Future.doWhile(() async {
      // await Future.delayed는 1초 동안 대기
      await Future.delayed(const Duration(milliseconds: 1000));
      // mounted는 State 객체가 현재 위젯 트리에 포함되어 있는지 여부를 나타내는 bool 타입의 속성
      if (mounted) {
        // print('mounted TRUE');
        setState(() {
          // 토글장치
          state = !state;
        });
      }
      // print('mounted FALSE');
      // print('isRun : ' + isRun.toString());
      // isRun은 아래 상황 아니면 계속 true임 그러므로 isRun이 true면 계속 동작함
      // AnimatedOpacitySample이 포함된 화면에서 다른 화면으로 이동하는 경우
      // AnimatedOpacitySample의 부모 위젯이 재구성되어 트리에서 제거되는 경우
      // 특정 상태 변화나 이벤트에 의해 AnimatedOpacitySample이 동적으로 트리에서 제거되는 경우
      return isRun;
    });
  }

  @override
  void dispose() {
    isRun = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(state);
  }
}
