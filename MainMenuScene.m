//
//  MainMenuScene.m
//  budha
//
//  Created by Leo on 17/01/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "MainMenuScene.h"

@implementation MainMenuScene{
    int _highScore;
    CCLabelTTF *_highScoreLabel;
}
- (void)didLoadFromCCB {
    [self loadHighScore];
    
}

-(void)playButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.35f]];
}
- (void)loadHighScore {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    _highScore = [prefs integerForKey:@"highScore"];
    _highScoreLabel.string = [NSString stringWithFormat:@"High Score: %ld",(long)_highScore];
}
@end
