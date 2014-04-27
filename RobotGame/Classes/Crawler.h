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
    CRAWLER_IDLE, CRAWLER_WALK, CRAWLER_DIE
    
} CrawlerState;

@interface Crawler : NSObject
{
    id<GameDelegate> _view;         // the scene that owns this crawler
    Renderable *_renderableIdle;
    Renderable *_renderableWalk;
    Renderable *_renderableDie;
    CGFloat _width;                 // crawler's width
    float _walkingSpeedScale;
    CCTime _nextThinkTime;          // time to run next round of AI "thinking"
}

@property (nonatomic, assign) Renderable *renderable;
@property (nonatomic, assign) CrawlerState state;
@property (nonatomic, assign) BOOL direction;  // YES for left and NO for right

- (id)initWithPosition:(CGPoint)position view:(id)scene
             direction:(BOOL)direction
            speedScale:(float)speedScale;

- (void)update:(CCTime)dt;

@end
