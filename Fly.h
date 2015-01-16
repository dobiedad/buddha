#import "CCSprite.h"
#import "SpriteDiedDelegate.h"

@interface Fly : CCSprite {
    
}

@property (nonatomic, assign) id spriteDiedDelegate;
@property (nonatomic, assign) BOOL hasCollidedWithBuddha;

@end

