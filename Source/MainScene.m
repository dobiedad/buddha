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
    hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    _physicsNode.position = ccp(_physicsNode.position.x - (scrollSpeed *delta), _physicsNode.position.y);
    // loop the ground
    for (CCNode *background in _backgrounds) {
        // get the world position of the ground
        CGPoint backgroundWorldPosition = [_physicsNode convertToWorldSpace:background.position];
        // get the screen position of the ground
        CGPoint backgroundScreenPosition = [self convertToNodeSpace:backgroundWorldPosition];
        // if the left corner is one complete width off the screen, move it to the right
        if (backgroundScreenPosition.x <= (-1 * background.contentSize.width)) {
            background.position = ccp(background.position.x + 2 * background.contentSize.width, background.position.y);
        }
    }
}
@end