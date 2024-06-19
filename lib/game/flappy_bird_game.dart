import 'dart:async';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:zeldafly/components/background.dart';
import 'package:zeldafly/components/bird.dart';
import 'package:zeldafly/components/ground.dart';
import 'package:zeldafly/components/pipe_group.dart';
import 'package:zeldafly/game/configuration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

class FlappyBirdGame extends FlameGame with TapDetector, HasCollisionDetection {
  FlappyBirdGame(); // 기본생성자

  late Bird bird;
  late TextComponent score;
  late TextComponent scoreBackground;
  Timer interval = Timer(Config.pipeInterval, repeat: true);
  // late Timer interval;
  bool isHit = false;

  @override
  Future<void> onLoad() async {
    addAll([
      Background(),
      Ground(),
      bird = Bird(),
      score = buildScore(),
      scoreBackground = buildScoreBackground(),
    ]);
    // interval =
    //     Timer.periodic(Duration(seconds: Config.pipeInterval.toInt()), (dt) {
    //   add(PipeGroup());
    // });

    interval.onTick = () => add(PipeGroup());
  }

  TextComponent buildScore() {
    return TextComponent(
      // 밑에서 통째로 업데이트 시켜줌 개꿀^^
      text: 'SCORE: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game',
          color: Colors.white,
        ),
      ),
    )..priority = 1;
  }

  TextComponent buildScoreBackground() {
    return TextComponent(
      // 밑에서 통째로 업데이트 시켜줌 개꿀^^
      text: 'SCORE: 0',
      position: Vector2(size.x / 2, size.y / 2 * 0.2),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          fontFamily: 'Game',
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2
            ..color = Colors.black,
        ),
      ),
    )..priority = 1;
  }

  @override
  void onTap() {
    bird.fly();
  }

  // 그냥 dart에서 사용하는 기본 Timer가 있고 flame에서 사용하는 Timer가 있는데
  // 여기선 flame Timer를 사용하고 'interval.update(dt)' 호출은 Flame의 Timer 객체를 업데이트합니다.
  // dt는 이전 프레임과 현재 프레임 사이의 시간 차이를 나타내는 매개변수입니다. 이를 통해 타이머가 적절한 간격으로 이벤트를 발생시키도록 합니다.
  @override
  void update(double dt) {
    super.update(dt);
    interval.update(dt);

    final newScoreText = 'SCORE: ${bird.score}';
    score.text = newScoreText;
    scoreBackground.text = newScoreText;
  }
}
