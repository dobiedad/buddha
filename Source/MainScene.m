#import "MainScene.h"
#import "Hero.h"
#import "Fly.h"
#import "CCActionInterval.h"
#import <CoreMotion/CoreMotion.h>

static const CGFloat scrollSpeed = 80.f;

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
    NSArray *_backgrounds;
    CMMotionManager *_motionManager;


}

- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    [self loadSavedState];
    [self spawnFly];
    _backgrounds = @[_background1, _background2];
    _motionManager = [[CMMotionManager alloc] init];
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    CCAction *followHero = [CCActionFollow actionWithTarget:_hero worldBoundary:CGRectMake(_background1.position.x - _hero.contentSize.width,0,_background1.contentSize.width ,   winSize.height )];
    [self runAction:followHero];
    self.userInteractionEnabled = YES;

}
-(void) touchBegan:(CCTouch *)touch withEvent:(CCTouchEvent *)event
{
   
    CGPoint location = [touch locationInNode:self];
    location = [[CCDirector sharedDirector] convertToGL:location];
    _hero.position = location;
  
}

- (void)onEnter
{
    [super onEnter];
    
   
    [_motionManager startAccelerometerUpdates];
}
- (void)update:(CCTime)delta {
    
    [self loopBackgrounds:delta];
    
//    [self heroPositionAndAccelerometer:delta];
}


- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

- (void)loopBackgrounds:(CCTime)delta {
    for (CCNode *background in _backgrounds) {
        
        CGPoint backgroundWorldPosition = [_physicsNode convertToWorldSpace:background.position];
        CGPoint backgroundScreenPosition = [self convertToNodeSpace:backgroundWorldPosition];
        background.position = ccp(background.position.x, background.position.y + (scrollSpeed * delta));
        
        if (backgroundScreenPosition.y >= (background.contentSize.height)) {
            background.position = ccp(background.position.x, background.position.y - (2 * background.contentSize.height));
        }
    }
}

- (void)heroPositionAndAccelerometer:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    CGFloat newXPosition = _physicsNode.position.x + acceleration.x * (1000 * delta);
    
    newXPosition = clampf(newXPosition,  _background1.position.x , _background1.position.x + (_background1.contentSize.width * .85) );
    
    _physicsNode.position = CGPointMake(newXPosition, _physicsNode.position.y);
    _hero.position = CGPointMake(winSize.width/2, winSize.height/2);

//    _physicsNode.position = _hero.position;
    
    

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