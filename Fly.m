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
    [self removeFromParentAndCleanup:NO];

    
}


@end
