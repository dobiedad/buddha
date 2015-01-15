//
//  Fly.m
//  budha
//
//  Created by Leo on 14/01/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Fly.h"

@implementation Fly{
}

- (id)init
{
    if (self = [super init])
    {
        // activate touches on this scene
        self.userInteractionEnabled = TRUE;
        
    }
    return self;
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    CCLOG(@"Fly touched");
    CCParticleSystem *smokeParticle = (CCParticleSystem *)[CCBReader load:@"smoke"];
    smokeParticle.position = self.position;
    [self.parent addChild:smokeParticle];
    CCActionMoveBy *moveBy = [CCActionMoveBy actionWithDuration:0.8f position:ccp(-10,10)];
    CCActionInterval *reverseMovement = [moveBy reverse];
    CCActionSequence *shakeSequence = [CCActionSequence actionWithArray:@[moveBy, reverseMovement]];
    CCActionEaseBounce *bounce = [CCActionEaseBounce actionWithAction:shakeSequence];
    [self runAction:bounce];
    
    [self removeFromParentAndCleanup:true];

    
}


@end
