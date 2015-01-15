#import "MainScene.h"
#import "Hero.h"
#import "Fly.h"

@implementation MainScene {
    Hero *_hero;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    CCNode *_gameOverMenu;
    CCSprite *_healthBar;
    CCButton *_restartButton;
    NSMutableArray *_flies;
}



- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    _gameOverMenu.visible=false;
    [self spawnRandomSprite:1];

}

- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)collidingHero fly:(CCSprite *)fly {
    NSLog(@"Game Over");
    _healthBar.scale = _healthBar.scaleX *.95;
    
  
    
    return TRUE;
}
-(void)restartButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.25f]];
    
}

-(void)spawnRandomSprite:(CCTime)dt

{

        int numSprite = arc4random() % 1; //generates random number up to 4... or is it 0-3, i forget..
    
        Fly *fly =  (Fly *)[CCBReader load:@"fly"];
    
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