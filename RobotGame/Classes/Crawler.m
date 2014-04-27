//
//  Crawler.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-26.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import "Crawler.h"

@implementation Crawler

@synthesize renderable = _renderable;
@synthesize state = _state;
@synthesize direction = _direction;

- (id)initWithPosition:(CGPoint)position view:(id)scene direction:(BOOL)direction speedScale:(float)speedScale
{
    self = [super init];
    if (!self) return(nil);
    
    _view = scene;
    _renderableIdle = [[Renderable alloc] initWithImageFile:@"crawler_idle.png"
                                                   duration:0.5f
                                              numberOfCells:8];
    _renderableWalk = [[Renderable alloc] initWithImageFile:@"crawler_walk.png"
                                                  duration:0.5f
                                             numberOfCells:8];
    _renderableDie = [[Renderable alloc] initWithImageFile:@"crawler_die.png"
                                                   duration:1.0f
                                              numberOfCells:7];
    [_view addChild:_renderableIdle.sprite];
    [_view addChild:_renderableWalk.sprite];
    [_view addChild:_renderableDie.sprite];
    
    // Configure the initial state (either idle or walking)
    if ((BOOL)(arc4random() % 2))
    {
        _state = CRAWLER_WALK;
        _renderableWalk.sprite.position = position;
        _renderableIdle.sprite.visible = NO;
        _renderable = _renderableWalk;
    }
    else
    {
        _state = CRAWLER_IDLE;
        _renderableIdle.sprite.position = position;
        _renderableWalk.sprite.visible = NO;
        _renderable = _renderableIdle;
    }
    _direction = direction;
    _renderableIdle.sprite.flipX = !direction;
    _renderableWalk.sprite.flipX = !direction;
    _renderableDie.sprite.flipX = !direction;
    _walkingSpeedScale = speedScale;
    _width = _renderable.sprite.boundingBox.size.width;
    
    return self;
}

- (void)setRenderable:(Renderable *)renderable
{
    // Update the new renderable's sprite position
    renderable.sprite.position = _renderable.sprite.position;
    // Make sure that only the new renderable's sprite is visible
    _renderable.sprite.visible = NO;
    renderable.sprite.visible = YES;
    // Switch the renderable
	_renderable = renderable;
}

- (void)setState:(CrawlerState)newState
{
	if (newState == _state)
    {
		return;
	}
	switch (newState)
    {
        case CRAWLER_IDLE:
        {
            [_renderableIdle rewind];
            self.renderable = _renderableIdle;
            int numCycles = arc4random() % 4 + 2;
            _nextThinkTime = [_view getTimeElapsed] + numCycles * _renderableIdle.duration;
            break;
        }
        case CRAWLER_WALK:
        {
            [_renderableWalk rewind];
            self.renderable = _renderableWalk;
            _walkingSpeedScale = (float)(arc4random() % 16 + 5)/10.0f;
            int numCycles = arc4random() % 6 + 5;
            _nextThinkTime = [_view getTimeElapsed] + numCycles * _renderableWalk.duration;
            break;
        }
        case CRAWLER_DIE:
        {
            [_renderableDie rewind];
            self.renderable = _renderableDie;
            break;
        }
        default:
            // shouldn't happen
            return;
	}
	_state = newState;
}

- (void)setDirection:(BOOL)direction
{
    _direction = direction;
    _renderableIdle.sprite.flipX = !direction;
    _renderableWalk.sprite.flipX = !direction;
    _renderableDie.sprite.flipX = !direction;
}

- (void)update:(CCTime)dt
{
    switch (_state)
    {
        case CRAWLER_IDLE:
        {
            if ([_view getTimeElapsed] >= _nextThinkTime)
            {
                self.state = CRAWLER_WALK;
            }
            else
            {
                [_renderable animate:dt];
            }
            break;
        }
        case CRAWLER_WALK:
        {
            if ([_view getTimeElapsed] >= _nextThinkTime)
            {
                self.state = CRAWLER_IDLE;
            }
            else
            {
                CGFloat x = _renderable.sprite.position.x;
                CGFloat y = _renderable.sprite.position.y;
                // Move in the current direction
                if (self.direction)
                {
                    _renderable.sprite.position = ccp(x - (dt * _walkingSpeedScale * WALKING_SPEED), y);
                    x = _renderable.sprite.position.x;
                }
                else
                {
                    _renderable.sprite.position = ccp(x + (dt * _walkingSpeedScale * WALKING_SPEED), y);
                    x = _renderable.sprite.position.x;
                }
                // Collisions with the edge of the screen
                if (x < _width/2)
                {
                    self.direction = NO;
                    _renderable.sprite.position =  ccp(_width/2, y);
                    x = _renderable.sprite.position.x;
                }
                if (x > [_view getScreenWidth] - _width/2)
                {
                    self.direction = YES;
                    _renderable.sprite.position =  ccp([_view getScreenWidth] - _width/2, y);
                    x = _renderable.sprite.position.x;
                }
                [_renderable animate:dt * _walkingSpeedScale];
            }
            break;
        }
        case CRAWLER_DIE:
        {
            [_renderable animate:dt];
            break;
        }
        default:
            // Shouldn't happen
            break;
    }
}

@end
