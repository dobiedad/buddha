#import "Fly.h"

@implementation Fly{
}

@synthesize spriteDiedDelegate;
@synthesize hasCollidedWithBuddha;

- (void)didLoadFromCCB {
    self.userInteractionEnabled = TRUE;
    
    [self randomFlyPosition];
    
}


- (void)randomFlyPosition {
    int x = -100 + (arc4random() % 500);
    
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



- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Fly touched");
    [self.spriteDiedDelegate spriteDied: self];
}

@end
