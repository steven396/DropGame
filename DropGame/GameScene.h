//
//  GameScene.h
//  DropGame
//
//  Created by steven wang on 20/01/2016.
//  Copyright 2016 home. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameScene : CCLayer {
    CCSprite * alien;
    CGPoint alienVelocity;
    
    CCArray * spiders;
    float spiderDropInterval;
    int numOfMovedSpiders;
    
    ccTime totalTime;
    int score;
    CCLabelBMFont * scoreLabel;
}

+(id)scene;
@end
