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
        [self initSpiders];
        
        scoreLabel = [CCLabelBMFont labelWithString:@"0" fntFile:@"bitmapfont.fnt"];
		scoreLabel.position = CGPointMake(screenSize.width / 2, screenSize.height);
		
		scoreLabel.anchorPoint = CGPointMake(0.5f, 1.0f);
		[self addChild:scoreLabel z:-1];
        
        
    }
    return self;
}

-(void)initSpiders{
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    CCSprite * tempSpider = [CCSprite spriteWithFile:@"spider.png"];
    float spiderWidth = [tempSpider texture].contentSize.width;
    int numOfSpiders = screenSize.width / spiderWidth;
    spiders = [[CCArray alloc]initWithCapacity:numOfSpiders];
    for (int i = 0; i < numOfSpiders; i++) {
        CCSprite * spider = [CCSprite spriteWithFile:@"spider.png"];
        [spiders addObject:spider];
        [self addChild:spider z:0 tag:2];
    }
    [self resetSpiders];
}

-(void)resetSpiders{
    numOfMovedSpiders = 0;
    spiderDropInterval = 6.0f;
    
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    CCSprite * tempSpider = [CCSprite spriteWithFile:@"spider.png"];
    float spiderWidth = [tempSpider texture].contentSize.width;
    float spiderHeight = [tempSpider texture].contentSize.height;
    int numOfSpiders = [spiders count];
    for (int i = 0; i < numOfSpiders; i++) {
        CCSprite * spider = [spiders objectAtIndex:i];
        spider.position = CGPointMake(spiderWidth * 0.5 + i * spiderWidth, screenSize.height + spiderHeight * 0.5);
        [spider stopAllActions];
    }
    [self unschedule:@selector(spiderUpdate:)];
    [self schedule:@selector(spiderUpdate:) interval:1.1f];
    
    totalTime = 0;
    score = 0;
    [scoreLabel setString:@"0"];
}

-(void)spiderUpdate:(ccTime)delta{
    for (int i = 0; i < 25; i++) {//如果所有蜘蛛都在动，则程序会死循环，此处设置个尝试的最大值，尝试25次后跳过此次更新
        int randNum = CCRANDOM_0_1() * [spiders count];
        CCSprite * spider = [spiders objectAtIndex:randNum];
        if ([spider numberOfRunningActions] == 0) {
            [self makeThisSpiderMove:spider];
            break;
        }
    }
}

-(void)makeThisSpiderMove:(CCSprite *)spider{
    numOfMovedSpiders++;
    if (numOfMovedSpiders % 5 == 0 && spiderDropInterval > 3.0f) {
        spiderDropInterval -= 0.3f;
    }
    CGPoint endPoint = CGPointMake(spider.position.x, -1 * [spider texture].contentSize.height * 0.5);
    CCMoveTo * move = [CCMoveTo actionWithDuration:spiderDropInterval position:endPoint];
    CCEaseBackInOut * ease = [CCEaseBackInOut actionWithAction:move];
    CCCallFuncN * func = [CCCallFuncN actionWithTarget:self selector:@selector(spiderArrivedEndPoint:)];
    CCSequence * sequence = [CCSequence actions:ease, func, nil];
    [spider runAction:sequence];
}

-(void)spiderArrivedEndPoint:(id)sender{
    CCSprite * spider = (CCSprite *)sender;
    CGPoint pos = spider.position;
    CGSize screenSize = [[CCDirector sharedDirector]winSize];
    pos.y = screenSize.height + [spider texture].contentSize.height * 0.5;
    spider.position = pos;
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
    [self checkDistance];
    
    totalTime += delta;
    int currenTime = (int)totalTime;
    if (score < currenTime) {
        score = currenTime;
        [scoreLabel setString:[NSString stringWithFormat:@"%d",score]];
    }
}

-(void)checkDistance{
    float alienWidth = [alien texture].contentSize.width;
    float spiderWidth = [[spiders lastObject]texture].contentSize.width;
    float maxDistance = alienWidth * 0.4f + spiderWidth * 0.4f;
    int numOfSpiders = [spiders count];
    for (int i = 0; i < numOfSpiders; i++) {
        CCSprite * spider = [spiders objectAtIndex:i];
        if ([spider numberOfRunningActions] == 0) {
            continue;
        }
        float currentDistance = ccpDistance(alien.position, spider.position);
        if (currentDistance < maxDistance) {
            [self resetSpiders];
        }
    }
}

-(void)dealloc{
    [spiders release];
    [super dealloc];
}

@end
