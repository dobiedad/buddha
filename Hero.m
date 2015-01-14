//
//  Hero.m
//  budha
//
//  Created by Leo on 12/01/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Hero.h"

@implementation Hero{
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
    CCLOG(@"fly a touch");
}






@end
