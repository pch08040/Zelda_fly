import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:zeldafly/game/assets.dart';
import 'package:zeldafly/game/configuration.dart';
import 'package:zeldafly/game/flappy_bird_game.dart';
import 'package:zeldafly/game/pipe_positon.dart';

class Pipe extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Pipe({
    required this.pipePositon,
    required this.height,
    // 함수 호출 시기에 값이 포함되어야 한다
    // '파이프그룹'에 들어가서 '프러피버드게임'에서 호출될때 값이 없으면 컴파일 에러남
  });

  @override
  final double height;
  final PipePositon pipePositon;

  @override
  Future<void> onLoad() async {
    final pipe = await Flame.images.load(Assets.pipe2);
    final pipeRotated = await Flame.images.load(Assets.pipeRotated2);
    size = Vector2(50, height);
    // print(size);

    switch (pipePositon) {
      case PipePositon.top:
        // 0이면 파이가 위로 붙음
        position.y = 0;
        // 위에 정의해준 이미지 사용해라~~
        sprite = Sprite(pipeRotated);
        break;

      case PipePositon.bottom:
        position.y = gameRef.size.y - size.y - Config.groundHeight;
        // 이건 그 반대값 계산한거
        sprite = Sprite(pipe);
        // print(sprite?.image);
        break;
    }

    // 파이프에 네모 hitbox 만듬
    add(RectangleHitbox());
  }
}
