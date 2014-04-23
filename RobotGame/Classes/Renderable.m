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

- (id)initWithImageFile:(NSString *)imageFile numberOfCells:(int)numCells
{
    self = [super init];
    if (!self) return(nil);
    
    _numCells = numCells;
    _tex = [CCTexture textureWithFile:imageFile];
    _cellWidth = _tex.contentSize.width/_numCells;
    _cellHeight = _tex.contentSize.height;
    _sprite = [CCSprite spriteWithTexture:_tex rect:CGRectMake(0, 0, _cellWidth, _cellHeight)];
    _sprite.scale = 2.0;
    _frameIndex = 0;
    
	return self;
}

- (void)rewind
{
    _frameIndex = 0;
}

- (void)animate:(CCTime)dt
{
    // Non-animatable
    if (_numCells < 2)
    {
        return;
    }
    CGRect nextFrame = CGRectMake(_frameIndex*_cellWidth, 0, _cellWidth, _cellHeight);
    [_sprite setTextureRect:nextFrame];
    _frameIndex = (_frameIndex < _numCells - 1) ? _frameIndex + 1 : 0;
}

@end
