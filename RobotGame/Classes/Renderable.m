//
//  Renderable.m
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-23.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import "Renderable.h"

@implementation Renderable

@synthesize sprite = _sprite;
@synthesize duration = _duration;

- (id)initWithImageFile:(NSString *)imageFile
               duration:(CCTime)duration
          numberOfCells:(int)numCells
{
    self = [super init];
    if (!self) return(nil);
    
    _time = 0.0f;
    _duration = duration;
    _numCells = numCells;
    _tex = [CCTexture textureWithFile:imageFile];
    _cellWidth = _tex.contentSize.width/_numCells;
    _cellHeight = _tex.contentSize.height;
    _sprite = [CCSprite spriteWithTexture:_tex rect:CGRectMake(0, 0, _cellWidth, _cellHeight)];
    _sprite.scale = 1.0f;
    
	return self;
}

- (void)rewind:(float)progress
{
    NSAssert((progress >= 0.0f) && (progress <= 1.0f), @"Invalid rewind parameter!");
    _time = progress * _duration;
}

- (void)animate:(CCTime)dt
{
    // Non-animatable
    if (_numCells < 2)
    {
        return;
    }
    // update time position
    _time += dt;
    // see if we've reached or passed the end
    if (_time >= _duration)
    {
        // wrap around
        _time = 0.0f;
    }
    // figure out which frame we're on
    int frameNo;
    if (_time < _duration)
    {
        // select a frame based on time position
        float progress = _time/_duration;
        frameNo = (int)(_numCells * progress);
    }
    // The next frame might be the same depending on progress
    CGRect nextFrame = CGRectMake(frameNo*_cellWidth, 0, _cellWidth, _cellHeight);
    [_sprite setTextureRect:nextFrame];
}

@end
