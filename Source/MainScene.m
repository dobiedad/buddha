#import "MainScene.h"
#import "Hero.h"

static const CGFloat scrollSpeed = 80.f;
@implementation MainScene {
    Hero *_hero;
    CCSprite *_fly;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    NSArray *_backgrounds;
    

}

- (void)didLoadFromCCB {
    _backgrounds = @[_background1, _background2];
    _physicsNode.collisionDelegate = self;
    _hero.physicsBody.collisionType = @"hero";
    _fly.physicsBody.collisionType = @"fly";


}


- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)collidingHero fly:(CCNode *)fly {
    NSLog(@"Game Over");
    return TRUE;
}
@end