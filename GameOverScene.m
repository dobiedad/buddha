#import "GameOverScene.h"
#import <CoreMotion/CoreMotion.h>
@implementation GameOverScene{
    CCButton *_restartButton;
    CMMotionManager *_motionManager;
    CCLabelTTF *_label;
}
- (id)init
{
    if (self = [super init])
    {
        _label= [CCLabelTTF labelWithString:@"X" fontName:@"Arial" fontSize:48];
        [self addChild:_label];
        _motionManager = [[CMMotionManager alloc] init];
    }
    return self;
}
-(void)restartButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.25f]];
}
- (void)onEnter
{
    [super onEnter];
    
 CGSize winSize = [CCDirector sharedDirector].viewSize;
 CGPoint midpoint = ccp(winSize.width/2, winSize.height/2);
    
    _label.position = midpoint;
    
    [_motionManager startAccelerometerUpdates];
}
- (void)onExit
{
    [super onExit];
    [_motionManager stopAccelerometerUpdates];
}

- (void)update:(CCTime)delta {
    CMAccelerometerData *accelerometerData = _motionManager.accelerometerData;
    CMAcceleration acceleration = accelerometerData.acceleration;
    
    CGSize winSize = [CCDirector sharedDirector].viewSize;
    
    CGFloat newXPosition = _label.position.x + acceleration.x * (1000 * delta);
    
    newXPosition = clampf(newXPosition, 0, winSize.width);
    
    _label.position = CGPointMake(newXPosition, _label.position.y);
}

@end