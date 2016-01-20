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
    }
    return self;
}

@end
