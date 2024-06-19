import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/bird_movement.dart';
import 'package:zeldafly/game/configuration.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:flutter/widgets.dart';

class Bird extends SpriteGroupComponent<BirdMovement>
    with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird(); // 기본생성자

  int score = 0;

  @override
  Future<void> onLoad() async {
    // gameRef.loadSprite 란?

    // 이미지 로딩 및 변환: 주어진 경로의 이미지를 로드하고 이를 Sprite 객체로 변환합니다.
    // 비동기 처리: 이미지 로딩이 비동기적으로 수행됩니다.
    // 편의성: Sprite 객체로 변환된 이미지를 바로 사용할 수 있어 편리합니다.
    // gameRef.loadSprite는 이미지를 로드하고 이를 Sprite로 변환하여 게임에서 바로 사용할 수 있게 합니다.

    // Sprite 객체의 제공기능

    // 1. 이미지 렌더링
    // Sprite 객체는 이미지를 화면에 렌더링하는 기능을 제공합니다.
    // 이는 게임의 시각적 요소를 화면에 표시하는 데 필수적입니다.

    // 2. 위치 및 크기 조정
    // Sprite 객체는 위치와 크기를 조정할 수 있습니다.
    // 게임 내에서 스프라이트의 위치를 설정하거나 크기를 변경할 수 있습니다.
    // 예를 들어, SpriteComponent는 size와 position 속성을 통해 스프라이트의 크기와 위치를 조정합니다.

    // 3. 회전 및 스케일링
    // Sprite 객체는 회전 및 스케일링 기능을 제공하여 스프라이트를 회전시키거나 크기를 조정할 수 있습니다.
    // 이는 다양한 애니메이션 효과와 변형을 구현하는 데 유용합니다.

    // 4. 클리핑
    // Sprite 객체는 이미지의 특정 부분만을 사용하도록 클리핑할 수 있습니다.
    // 이를 통해 하나의 이미지에서 여러 스프라이트를 추출하여 사용할 수 있습니다.

    final birdMidFlap = await gameRef.loadSprite(Assets.linkMidFlap);
    final birdUpFlap = await gameRef.loadSprite(Assets.linkUpFlap);
    final birdDownFlap = await gameRef.loadSprite(Assets.linkDownFlap);

    // bird사이즈
    size = Vector2(70, 50);
    // 초기 bird의 위치
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    // 초기 bird의 현재모습
    current = BirdMovement.middle;
    // 각 동작별 스프라이트 저장
    sprites = {
      BirdMovement.middle: birdMidFlap,
      BirdMovement.up: birdUpFlap,
      BirdMovement.down: birdDownFlap,
    };

    // bird 이미지를 감싸는 hitbox를 만듬
    add(CircleHitbox());
  }

  // 놀랍게도 flame같은 2d 그래픽 라이브러리는 보통
  // x값이 증가할수록 오른쪽으로 이동
  // x값이 감소할수록 왼쪽으로 이동
  // y값이 증가할수록 아래로 이동
  // y값이 감소할수록 위로 이동
  // 이런 좌표 체계를 사용한다.
  void fly() {
    add(
      MoveByEffect(
        // 저 말대로하면 -100씩 뛰어오름
        Vector2(0, Config.gravity),
        // 0.2초 동안 빠르게가다가 천천히 모션으로
        EffectController(duration: 0.2, curve: Curves.decelerate),
        // 해당 함수 완료시 현재 상태 down으로 업데이트
        onComplete: () => current = BirdMovement.down,
      ),
    );
    // fly함수가 실행되면 MoveByEffect보다 이게 먼저 실행됨
    current = BirdMovement.up;
    FlameAudio.play(Assets.flying);
  }

  @override
  void onCollisionStart(
    Set<Vector2> intersectionPoints,
    // 두 컴포넌트가 충돌한 지점들의 좌표를 포함하는 집합, 충돌한 지점을 알고리즘적으로 처리하거나 시각적으로 표시하는 데 사용
    PositionComponent other,
    // 충돌한 다른 컴포넌트를 나타내는 객체입니다. 이를 통해 충돌한 대상이 무엇인지 확인
  ) {
    super.onCollisionStart(intersectionPoints, other);
    // 충돌한 지점들의 좌표와 충돌한 다른 컴포넌트를 매개변수로 받는다
    // 부모 클래스의 onCollisionStart 메서드를 호출하여 기본 충돌 처리를 수행
    // gameOver() 메서드를 호출하여 게임 오버 상태를 처리
    // print(other);
    gameOver();
  }

  void reset() {
    position = Vector2(50, gameRef.size.y / 2 - size.y / 2);
    score = 0;
  }

  void gameOver() {
    FlameAudio.play(Assets.collision);
    // true로 되면서 파이프그룹의 초기화
    gameRef.isHit = true;
    // gameOver화면 송출
    gameRef.overlays.add('gameOver');
    // 렌더링 일시중지
    gameRef.pauseEngine();
  }

  // 계속 떨어지게 하고
  @override
  void update(double dt) {
    super.update(dt);
    position.y = position.y + Config.birdVelocity * dt;

    if (position.y < 1) {
      gameOver();
    }
  }
}
