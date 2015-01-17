#import "GameOverScene.h"

@implementation GameOverScene{
    CCButton *_restartButton;
    int _highScore;
    CCLabelTTF *_highScoreLabel;
}
- (void)didLoadFromCCB {
    [self loadHighScore];

}
-(void)restartButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.25f]];
}
- (void)loadHighScore {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _highScore = [prefs integerForKey:@"highScore"];
    _highScoreLabel.string = [NSString stringWithFormat:@"High Score: %ld",(long)_highScore];
}
@end
