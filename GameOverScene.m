//
//  GameOverScene.m
//  budha
//
//  Created by Leo Lev on 15/01/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "GameOverScene.h"

@implementation GameOverScene{
    CCButton *_restartButton;

}
-(void)restartButtonClicked {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene withTransition:[CCTransition transitionPushWithDirection:CCTransitionDirectionLeft duration:0.25f]];
    
}

@end
