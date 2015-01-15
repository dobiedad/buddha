#import "MainScene.h"
#import "Hero.h"
#import "Fly.h"
#import "CCActionInterval.h"

@implementation MainScene {
    Hero *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    CCNode *_heart;

    CCSprite *_healthBar;
    CCSprite *_fish0;
    CCSprite *_fish1;

    NSMutableArray *_flies;
}



- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    [self spawnRandomSprite:1];

}

- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
}

- (void)scaleHeartAnimation {
    CCAction *action = [CCActionSequence actions:
                        [CCActionScaleTo actionWithDuration:0.1F scale:0.5],[CCActionScaleTo actionWithDuration:0.1F scale:0.6],[CCActionScaleTo actionWithDuration:0.1F scale:0.6],nil];
    
    [_heart runAction: action];
}
-(void)gameOver {
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.15f]];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)collidingHero fly:(CCSprite *)fly {
    NSLog(@"buddha & fly collided");
    float Health =_healthBar.scaleX;
    
    _healthBar.scaleX = Health - 0.20;
    [self scaleHeartAnimation];

    if (_healthBar.scaleX <= 0) {
        _heart.visible=false;
        [self gameOver];

    }
    return TRUE;
}


-(void)spawnRandomSprite:(CCTime)dt

{

        int numSprite = arc4random() % 3; //generates random number up to 4... or is it 0-3, i forget..
        NSString *flyFile =[NSString stringWithFormat:@"fly%d", numSprite];
    
        Fly *fly =  (Fly *)[CCBReader load:flyFile];
    
        int x = -100;
    
        int y = 100 + (arc4random() % 200); //random number between 100 and 300
    
        fly.position = ccp(x,y);
    
        [_physicsNode addChild:fly];
    
    
    
        //move it to the right 550 points
    
        float duration = 3.0;
    
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
    
        id moveRight = [CCActionMoveBy actionWithDuration:duration position:ccp(screenWidth+300,0)];
    
        [fly runAction:moveRight];
    
    
    
        id delay = [CCActionDelay actionWithDuration:duration];
    
        CCActionCallBlock *removeFly = [CCActionCallBlock actionWithBlock:^{
            [_physicsNode removeChild:fly cleanup:TRUE];
            [self spawnRandomSprite:1];
        }];
    
        id seq = [CCActionSequence actions:delay, removeFly, nil];
    
        [self runAction :seq];
    
}




@end