#import "MainScene.h"
static const CGFloat scrollSpeed = 80.f;
@implementation MainScene {
    CCSprite *hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    NSArray *_backgrounds;

}

- (void)didLoadFromCCB {
    _backgrounds = @[_background1, _background2];
}


- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
}


@end