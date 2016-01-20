//
//  GameScene.m
//  DropGame
//
//  Created by steven wang on 20/01/2016.
//  Copyright 2016 home. All rights reserved.
//

#import "GameScene.h"


@implementation GameScene

+(id)scene{
    CCScene *scene = [CCScene node];
	CCLayer* layer = [GameScene node];
	[scene addChild:layer];
	return scene;
}

-(id)init{
    if (self = [super init]) {
        self.accelerometerEnabled = YES;
        
        CGSize screenSize = [[CCDirector sharedDirector]winSize];
        alien = [CCSprite spriteWithFile:@"alien.png"];
        float alienHeight = [alien texture].contentSize.height;
        alien.position = CGPointMake(screenSize.width * 0.5, alienHeight * 0.5);
        [self addChild:alien z:0 tag:1];
        
        [self scheduleUpdate];
        
    }
    return self;
}

-(void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
    float deceleration = 0.4f;
    float sensitivity = 8.0f;
    float maxV = 100;
    
    alienVelocity.x = alienVelocity.x * deceleration + acceleration.x * sensitivity;
    if (alienVelocity.x > maxV) {
        alienVelocity.x = maxV;
    }else if (alienVelocity.x < -1 * maxV){
        alienVelocity.x = -1 * maxV;
    }
}

-(void)update:(ccTime)delta{
    CGPoint pos = alien.position;
    pos.x += alienVelocity.x;
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    float alienWidth = [alien texture].contentSize.width;
    float leftLimit = alienWidth * 0.5;
    float rightLimit = screenSize.width - alienWidth * 0.5;
    if (pos.x < leftLimit) {
        pos.x = leftLimit;
        alienVelocity = CGPointZero;
    }else if (pos.x > rightLimit){
        pos.x = rightLimit;
        alienVelocity = CGPointZero;
    }
    alien.position = pos;
}

@end
