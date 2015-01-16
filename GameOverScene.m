#import "GameOverScene.h"

@implementation GameOverScene{
    CCButton *_restartButton;
}

-(void)restartButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.25f]];
}

@end
