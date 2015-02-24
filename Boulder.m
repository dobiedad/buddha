//
//  Boulder.m
//  budha
//
//  Created by Leo on 24/02/2015.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

#import "Boulder.h"

@implementation Boulder{

CCNode *_boulder1;
CCNode *_boulder2;


}
#define ARC4RANDOM_MAX      0x100000000
// visibility on a 3,5-inch iPhone ends a 88 points and we want some meat
static const CGFloat minimumYPositionTopPipe = 128.f;
// visibility ends at 480 and we want some meat
static const CGFloat maximumYPositionBottomPipe = 440.f;
// distance between top and bottom pipe
static const CGFloat pipeDistance = 142.f;
// calculate the end of the range of top pipe
static const CGFloat maximumYPositionTopPipe = maximumYPositionBottomPipe - pipeDistance;



- (void)setupRandomPosition {
    // value between 0.f and 1.f
    CGFloat random = ((double)arc4random() / ARC4RANDOM_MAX);
    CGFloat range = maximumYPositionTopPipe - minimumYPositionTopPipe;
    _boulder1.position = ccp( minimumYPositionTopPipe + (random * range),_boulder1.position.x);
    _boulder2.position = ccp( _boulder1.position.y + pipeDistance,_boulder2.position.x);
    


}
@end
