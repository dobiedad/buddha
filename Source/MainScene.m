#import "MainScene.h"
#import "Hero.h"
#import "Fly.h"
#import "CCActionInterval.h"

static const int kScrollSpeed = 3;

@implementation MainScene {
    Hero *_hero;
    Fly *_fly;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    CCNode *_heart;
    CCNode *_healthBar;
    NSMutableArray *_flies;
    int _points;
    CCLabelTTF *_scoreLabel;
    int _highScore;
    CCLabelTTF *_highScoreLabel;


}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    [self loadSavedState];
    [self spawnFly];
}

- (void)update:(CCTime)delta {
//    //hero.position = ccp(hero.position.x + delta * scrollSpeed, hero.position.y);
//    //_physicsNode.position = ccp(_physicsNode.position.x, _physicsNode.position.y  - (scrollSpeed *delta));
//    
//    CGPoint bg1Pos = _background1.position;
//    CGPoint bg2Pos = _background2.position;
//    bg1Pos.y += kScrollSpeed;
//    bg2Pos.y -= kScrollSpeed;
//    
//    // move scrolling background back by one screen width to achieve "endless" scrolling
//    if (bg1Pos.y < -(_background1.contentSize.width))
//    {
//        bg1Pos.y += _background1.contentSize.width;
//        bg2Pos.y -= _background2.contentSize.width;
//    }
//    
//    // remove any inaccuracies by assigning only int values
//    // (prevents floating point rounding errors accumulating over time)
//    bg1Pos.y = (int)bg1Pos.y;
//    bg2Pos.y = (int)bg2Pos.y;
//    _background1.position = bg1Pos;
//    _background2.position = bg2Pos;
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
        
        
        float Health =_healthBar.scaleY;
        fly.hasCollidedWithBuddha = true;

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
    int numSprite = arc4random() % 1;
    NSString *flyFile =[NSString stringWithFormat:@"fly%d", numSprite];
    Fly *fly =  (Fly *)[CCBReader load:flyFile];
    fly.spriteDiedDelegate = self;
    [_physicsNode addChild:fly];
}

- (void)scoreAndHighScore
{
    _points += 1;
    _scoreLabel.string = [NSString stringWithFormat:@"%ld", (long) _points];
    NSLog(@"%ld",_highScore);

    if (_points > _highScore) {
        _highScore = _points;
    }
    [self saveState];
    [self loadSavedState];
}

-(void)spriteDied:(CCSprite *)sprite
{
    [_physicsNode removeChild:sprite cleanup:NO];
    [self createSomeNewFlies];
    [self scoreAndHighScore];
}

-(void)spriteDissapeared:(CCSprite *)sprite
{
    [_physicsNode removeChild:sprite cleanup:NO];
    [self createSomeNewFlies];
}

-(void)createSomeNewFlies {
    int newFlyCount = (arc4random() % 2) + 1;
    for (int i = 0; i < newFlyCount; i++) {
        [self spawnFly];
    }
}

- (void)saveState {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setInteger:_highScore forKey:@"highScore"];
    [prefs synchronize];
}

- (void)loadSavedState {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _highScore = [prefs integerForKey:@"highScore"];
    _highScoreLabel.string = [NSString stringWithFormat:@"* %ld",(long)_highScore];
}




@end