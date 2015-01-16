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
    int x = -10 + (arc4random() % 100);
    
    int y = 100 + (arc4random() % 500); //random number between 100 and 300
    int random = 1 + (arc4random() % 500); //random number between 100 and 300

    
    
    self.position = ccp(x,y);
    
    //move it to the right 550 points
    
    float duration = 3.0;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    // CGFloat screenHeight = screenRect.size.height;
    
    id moveRight = [CCActionMoveBy actionWithDuration:duration position:ccp(screenWidth+random,-random)];
    
    [self runAction:moveRight];
    
    id delay = [CCActionDelay actionWithDuration:duration];
    
    CCActionCallBlock *removeFly = [CCActionCallBlock actionWithBlock:^{
        [self.spriteDiedDelegate spriteDied: self];
    }];
    
    id seq = [CCActionSequence actions:delay, removeFly, nil];
    
    [self runAction :seq];
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
    CCLOG(@"Fly touched");
    [self addParticles];
    [self.spriteDiedDelegate spriteDied: self];
}

@end
