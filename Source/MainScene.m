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
    CCNode *_healthBar;
    NSMutableArray *_flies;
}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    [self spawnFly];
}

- (void)update:(CCTime)delta {
    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
}

- (void)scaleHeartAnimation {
    CCAction *action = [CCActionSequence actions:
                        [CCActionScaleTo actionWithDuration:0.1F scale:0.55],[CCActionScaleTo actionWithDuration:0.2F scale:0.4],nil];

    [_heart runAction: action];
}
-(void)gameOver {
    CCScene *scene = [CCBReader loadAsScene:@"GameOverScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionDown duration:0.35f]];
}

-(BOOL)ccPhysicsCollisionBegin:(CCPhysicsCollisionPair *)pair hero:(CCNode *)collidingHero fly:(Fly *)fly {
    
    if (fly.hasCollidedWithBuddha == false) {
        NSLog(@"buddha & fly collided");
        
        fly.hasCollidedWithBuddha = true;
        
        float Health =_healthBar.scaleY;
        
        _healthBar.scaleY = Health - 0.02;
        [self scaleHeartAnimation];
        
        if (_healthBar.scaleY <= 0) {
            _heart.visible=false;
            [self gameOver];
        }
    }
    
    return TRUE;
}


-(void)spawnFly
{
    int numSprite = arc4random() % 3;
    NSString *flyFile =[NSString stringWithFormat:@"fly%d", numSprite];
    Fly *fly =  (Fly *)[CCBReader load:flyFile];
    fly.spriteDiedDelegate = self;
    [_physicsNode addChild:fly];
}

-(void)spriteDied: (CCSprite *)sprite
{
    [_physicsNode removeChild:sprite cleanup:NO];
    
    int newFlyCount = (arc4random() % 5) + 1;
    for (int i = 0; i < newFlyCount; i++) {
        [self spawnFly];
    }
}


@end