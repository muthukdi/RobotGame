//
//  Crawler.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-26.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Renderable.h"
#import "AppDelegate.h"

#define WALKING_SPEED 60.0f

typedef enum CrawlerStateTypes
{
    CRAWLER_IDLE, CRAWLER_WALK, CRAWLER_DYING, CRAWLER_DEAD
    
} CrawlerState;

@interface Crawler : NSObject
{
    id<GameDelegate> _view;         // the scene that owns this crawler
    Renderable *_renderableIdle;
    Renderable *_renderableWalk;
    Renderable *_renderableDie;
    float _walkingSpeedScale;
    CCTime _nextThinkTime;          // time to run next round of AI "thinking"
    CCTime _timeToDeath;
}

@property (nonatomic, strong) Renderable *renderable;
@property (nonatomic, assign) CrawlerState state;
@property (nonatomic, assign) BOOL direction;  // YES for left and NO for right
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) CCSprite *collider;
@property (nonatomic, assign) CGFloat scale;

- (id)initWithPosition:(CGPoint)position view:(id)scene
             direction:(BOOL)direction
            speedScale:(float)speedScale;

- (void)update:(CCTime)dt;

@end
