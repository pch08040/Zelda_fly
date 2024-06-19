import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zeldafly/components/pipe.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/configuration.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:zeldafly/game/pipe_positon.dart';

class PipeGroup extends PositionComponent with HasGameRef<FlappyBirdGame> {
  PipeGroup();
  final _random = Random();
  var gameSpeed = 0;

  @override
  Future<void> onLoad() async {
    // 파이프 그룹의 초기 x위치를 화면 오른쪽 끝으로 설정합니다.
    position.x = gameRef.size.x;

    // 지면의 높이를 제외한 배경의 높이
    final heightMinusGround = gameRef.size.y - Config.groundHeight;
    // 파이프간의 랜덤한 간격 / nextDouble()함수는 0과 1사이의 난수를 랜덤하게 만들어줌
    // 100을 더한 이유는 최소간격 보장 때문
    final spacing = 120 + _random.nextDouble() * (heightMinusGround / 4);
    // centerY의 위치값
    // 간격 + 랜덤값 * (남은배경 - 간격)
    final centerY =
        spacing + _random.nextDouble() * (heightMinusGround - spacing);

    // 랜덤높이가 10보다 낮으면 result에 다시 값을 넣어라 만약 아니면

    addAll([
      Pipe(pipePositon: PipePositon.top, height: centerY - spacing / 2),
      Pipe(
          pipePositon: PipePositon.bottom,
          height: heightMinusGround - (centerY + spacing / 2)),
    ]);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // dt를 찍어보니 0.16667 or 0.16666인걸 보아하니 초당 60프레임으로 동작하는군
    // dt는 각 프레임 사이의 시간간격임
    // update 메서드의 내용물 보니깐 forEach문으로 돌아가는듯?
    position.x = position.x - Config.groundSpeed * dt;

    if (position.x < -50) {
      // 현재 컴포넌트를 부모 컴포넌트에서 제거하는 함수
      removeFromParent();
      // 새가 파이프를 통과해서 파이프가 제거되면 점수가 up됨
      updateScore();
      // print('Removed');
    }

    if (gameRef.isHit) {
      removeFromParent();
      gameRef.isHit = false;
      // print(gameRef.isHit);
    }
  }

  void updateScore() {
    gameRef.bird.score += 1;
    FlameAudio.play(Assets.point);
  }
}
