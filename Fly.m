#import "Fly.h"

@implementation Fly{
    
}

@synthesize spriteDiedDelegate;
@synthesize hasCollidedWithBuddha;

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    self.physicsBody.collisionType=@"fly";
    [self randomFlyPosition];
    
    
}


- (void)randomFlyPosition {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width * 3;
    CGFloat middleX = (screenWidth / 2);
    int plusMinusRandom = [self randomNumberBetweenZeroAnd: 1] == 0 ? 1 : -1;
    
//    NSLog(@"plusMinusRandom = %d", plusMinusRandom);
    
    CGFloat xDistanceFromMiddle = (middleX + 100) * plusMinusRandom;
    
    int startX = middleX + xDistanceFromMiddle;
    int endX = middleX - xDistanceFromMiddle;
    
//    NSLog(@"%d -> %d", startX, endX);
    
    int endY = 100 + ([self randomNumberBetweenZeroAnd: 900])*plusMinusRandom + ([self randomNumberBetweenZeroAnd: 100]);
    int startY = 100 + ([self randomNumberBetweenZeroAnd: 600]);

    self.position = ccp(startX, startY);
    
    if (endX < startX) {
        self.scaleX *= -1.f;
    }
    
    float duration = 3.0 + ([self randomNumberBetweenZeroAnd: 2] - 1);
    
    id move = [CCActionMoveTo actionWithDuration:duration position:ccp(endX, endY)];
    
    [self runAction:move];
    
    id delay = [CCActionDelay actionWithDuration:duration];
    
    CCActionCallBlock *removeFly = [CCActionCallBlock actionWithBlock:^{
        [self.spriteDiedDelegate spriteDissapeared: self];
    }];
    
    id seq = [CCActionSequence actions:delay, removeFly, nil];
    
    [self runAction :seq];
}

- (NSInteger)randomNumberBetweenZeroAnd: (u_int32_t) n {
    return arc4random_uniform(n + 1);
}

- (void)addParticles
{
    CCParticleSystem *smoke = (CCParticleSystem *)[CCBReader load:@"smoke"];
    smoke.position = self.position;
    [self.parent addChild:smoke];
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.8f position:ccp(-1,20)];
    CCActionInterval *reverseMovement = [moveBy reverse];
    CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
    smoke.autoRemoveOnFinish = TRUE;

    [self runAction:bounce];
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
//    CCLOG(@"Fly touched");
    [self addParticles];
    [self.spriteDiedDelegate spriteDied: self];

}

@end
