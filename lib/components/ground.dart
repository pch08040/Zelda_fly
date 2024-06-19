import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/parallax.dart';
import 'package:flame/flame.dart';

import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/configuration.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';

// ParallaxComponent 클래스의 주요 기능

// 1. 레이어 관리: 여러 레이어를 설정할 수 있으며, 각 레이어는 서로 다른 이미지를 가집니다
// 2. 스크롤 속도 조절: 각 레이어의 스크롤 속도를 개별적으로 조절할 수 있어, 더 먼 배경일수록 느리게 움직이는 파랄럭스 효과를 구현할 수 있습니다
// 3. 반복되는 배경: 레이어의 이미지를 반복해서 배경이 끊기지 않고 연속적으로 보이도록 할 수 있습니다

class Ground extends ParallaxComponent<FlappyBirdGame> with HasGameRef<FlappyBirdGame>{
  Ground(); // 기본생성자

  @override
  Future<void> onLoad() async {
    // Flame.images.load 란?

    // 이미지 로딩: 주어진 경로의 이미지를 로드하여 Image 객체를 반환합니다.
    // 비동기 처리: 이미지 로딩이 비동기적으로 수행됩니다.
    // Flame.images.load는 단순히 이미지를 로드하는 데 사용됩니다.

    final ground = await Flame.images.load(Assets.ground2);

    parallax = Parallax([
      ParallaxLayer(
        ParallaxImage(ground, fill: LayerFill.none),
        // fill: LayerFill.none는 이미지를 어떻게 채울지에 대한 설정으로, none은 이미지를 변형하지 않음을 나타냄
      ),
    ]);

    add(
      // 지면을 RectangleHitbox로 감싸는거임
      RectangleHitbox(
        position: Vector2(0, gameRef.size.y - Config.groundHeight),
        size:Vector2(gameRef.size.x, Config.groundHeight),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    parallax?.baseVelocity.x = Config.groundSpeed;
  }
}
