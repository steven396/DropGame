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

@end
