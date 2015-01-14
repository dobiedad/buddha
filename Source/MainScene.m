#import "MainScene.h"
#import "Hero.h"

static const CGFloat scrollSpeed = 80.f;
static const CGFloat firstFlyPosition = 280.f;
static const CGFloat distanceBetweenFlies = 160.f;
@implementation MainScene {
    Hero *_hero;
    CCSprite *_fly;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    NSMutableArray *_flies;
    

}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _hero.physicsBody.collisionType = @"hero";
    _fly.physicsBody.collisionType = @"fly";
//    [self spawnNewFly];
//    [self spawnNewFly];
//    [self spawnNewFly];
    [self spawnRandomSprite:1];


}
//- (void)spawnNewFly {
//    CCNode *previousFly = [_flies lastObject];
//    CGFloat previousFlyXPosition = previousFly.position.x;
//    if (!previousFly) {
//        // this is the first obstacle
//        previousFlyXPosition = firstFlyPosition;
//    }
//    CCNode *fly = [CCBReader load:@"fly"];
//    fly.position = ccp(previousFlyXPosition + distanceBetweenFlies, 0);
//    [_physicsNode addChild:fly];
//    [_flies addObject:fly];
//}

- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
    
    
    
    
}
-(void)loopFlies{
    NSMutableArray *offScreenFlies = nil;
    for (CCNode *fly in _flies) {
        CGPoint flyWorldPosition = [_physicsNode convertToWorldSpace:fly.position];
        CGPoint flyScreenPosition = [self convertToNodeSpace:flyWorldPosition];
        if (flyScreenPosition.x < -fly.contentSize.width) {
            if (!offScreenFlies) {
                offScreenFlies = [NSMutableArray array];
            }
            [offScreenFlies addObject:fly];
        }
    }
    for (CCNode *flyToRemove in offScreenFlies) {
        [flyToRemove removeFromParent];
        [_flies removeObject:flyToRemove];
        // for each removed obstacle, add a new one
//        [self spawnNewFly];
    }
}
-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)collidingHero fly:(CCNode *)fly {
    NSLog(@"Game Over");
    return TRUE;
}

-(void)spawnRandomSprite:(CCTime)dt

{

        int numSprite = arc4random() % 1; //generates random number up to 4... or is it 0-3, i forget..
    
        CCSprite *fly = [CCSprite spriteWithImageNamed:@"laddin.png"];
    
        int x = 10;
    
        int y = 1 + (arc4random() % 200); //random number between 100 and 300
    
        fly.position = ccp(x,y);
    
        [self addChild:fly];
    
    
    
        //move it to the right 550 points
    
        float duration = 3.0;
    
        id moveRight = [CCActionMoveBy actionWithDuration:duration position:ccp(50,0)];
    
        [fly runAction:moveRight];
    
    
    
        id delay = [CCActionDelay actionWithDuration:duration];
    
        CCActionCallBlock *removeFly = [CCActionCallBlock actionWithBlock:^{
            [self removeChild:fly cleanup:TRUE];
        }];
    
        id seq = [CCActionSequence actions:delay, removeFly, nil];
    
        [self runAction :seq];
    
}




@end