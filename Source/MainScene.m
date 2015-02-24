#import "MainScene.h"
#import "Hero.h"
#import "Fly.h"
#import "Boulder.h"
#import "CCActionInterval.h"
#import <CoreMotion/CoreMotion.h>

static const CGFloat scrollSpeed = 80.f;
static const CGFloat heroSpeed = 30.f;

static const CGFloat firstObstaclePosition = 280.f;
static const CGFloat distanceBetweenBoulders = 160.f;

typedef NS_ENUM(NSInteger, DrawingOrder) {
    DrawingOrderBoulders,
    DrawingOrderHero
};

#define kHeroMoveTag 123

@implementation MainScene {
    Hero *_hero;
    Fly *_fly;
    CCPhysicsNode *_physicsNode;
    CCNode *_background1;
    CCNode *_background2;
    CCNode *_heart;
    CCNode *_healthBar;
    CCNode *_heroStatsNode;
    NSMutableArray *_flies;
    int _points;
    CCLabelTTF *_scoreLabel;
    int _highScore;
    CCLabelTTF *_highScoreLabel;
    NSArray *_backgrounds;
    CMMotionManager *_motionManager;
    NSMutableArray *touchQueue;
    NSMutableArray *_boulderArray;
  


}



- (void)didLoadFromCCB {
    _physicsNode.collisionDelegate = self;
    [self loadSavedState];
    [self spawnFly];
    _backgrounds = @[_background1, _background2];
    _motionManager = [[CMMotionManager alloc] init];
    _boulderArray = [[NSMutableArray alloc]init];
   
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    CGRect worldBoundary =CGRectMake(_background1.position.x,0,_background1.contentSize.width -     _background1.position.x ,  winSize.height );
    
    CCAction *followHero = [CCActionFollow actionWithTarget:_physicsNode worldBoundary:worldBoundary];
    [self runAction:followHero];
    self.userInteractionEnabled = YES;
    
    for (CCNode *boulder in _boulderArray) {
        boulder.zOrder = DrawingOrderBoulders;
    }
    _hero.zOrder = DrawingOrderHero;
}

- (void)spawnNewObstacle {
    CCNode *previousObstacle = [_boulderArray lastObject];
    CGFloat previousBoulderXPosition = previousObstacle.position.x;
    if (!previousObstacle) {
        // this is the first obstacle
        previousBoulderXPosition = firstObstaclePosition;
    }
    CCNode *boulder = [CCBReader load:@"Boulder"];
    
    boulder.position = ccp(previousBoulderXPosition + distanceBetweenBoulders, 0);
    NSLog(@"boulder  PoSX >>> %f", boulder.position.x);
    NSLog(@"boulder PoSY >>> %f", boulder.position.y);
    [_physicsNode addChild:boulder];
    [_boulderArray addObject:boulder];
}
- (void)offScreenBoulders{
    NSMutableArray *offScreenBoulders = nil;
    
    for (CCNode *boulder in _boulderArray) {
        CGPoint boulderWorldPosition = [_physicsNode convertToWorldSpace:boulder.position];
        CGPoint boulderScreenPosition = [self convertToNodeSpace:boulderWorldPosition];
        
  
        if (boulderScreenPosition.x < -boulder.contentSize.width) {
            if (!offScreenBoulders) {
                offScreenBoulders = [NSMutableArray array];
            }
            [offScreenBoulders addObject:boulder];
        }
    }
    for (CCNode *boulderToRemove in offScreenBoulders) {
        [boulderToRemove removeFromParent];
        [_boulderArray removeObject:boulderToRemove];
        // for each removed obstacle, add a new one
        [self spawnNewObstacle];
    }
}

- (void)onEnter
{
    [super onEnter];
    
   
    [_motionManager startAccelerometerUpdates];
}
- (void)update:(CCTime)delta {
    [self loopBackgrounds:delta];
    [self heroPositionAndAccelerometer:delta];
    _heroStatsNode.positionInPoints=CGPointMake(-150.f, -20.f);
//    [self addBoulderToRoad];
    [self spawnNewObstacle];

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
    
    newXPosition = clampf(newXPosition,  _background1.position.x *.4 , _background1.position.x + ((_background1.contentSize.width - _hero.contentSize.width)* .75 ) );
    
    _physicsNode.position = CGPointMake(newXPosition, _physicsNode.position.y);
    _hero.position = CGPointMake(winSize.width/100, _hero.position.y);
    
//    
//    NSLog(@"Background WIDTH >>> %f",_background1.contentSize.width);
//
//    NSLog(@"Background POS >>> %f",_background1.position.x);
//    NSLog(@"HERO POS >>> %f",_hero.position.x);
//    NSLog(@"Physics POS >>> %f",_physicsNode.position.x);

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
//        NSLog(@"buddha & fly collided");
        
        
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
- (NSInteger)randomNumberBetweenZeroAnd: (u_int32_t) n {
    return arc4random_uniform(n + 1);
}

-(void) populateRandomBoulder
{
    for(int i=1;i<=4;i++)
    {
        int randomNumber = [self randomNumberBetweenZeroAnd: 10];
        
        if(randomNumber == 0)
        {
            Boulder *boulder = (Boulder *)[CCBReader load:@"boulder"];
            [_boulderArray addObject:boulder];

        }
    }
    
}
-(void) addBoulderToRoad
{
    // clean the array
    [_boulderArray removeAllObjects];
    _boulderArray= nil;
    
    _boulderArray = [[NSMutableArray alloc] init];
    CGSize winSize = [CCDirector sharedDirector].viewSize;

    [self populateRandomBoulder];
    long y = 200;
    long x = 0;
    
    for(long i=0;i<[_boulderArray count]; i++)
    {
        x  = [self randomNumberBetweenZeroAnd: winSize.width/2];
        
        Boulder *boulder = [_boulderArray objectAtIndex:i];
        
        [self addChild:boulder z:0];
        
        y += 200;
    }
    
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