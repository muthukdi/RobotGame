//
//  Renderable.h
//  RobotGame
//
//  Created by Dilip Muthukrishnan on 2014-04-23.
//  Copyright (c) 2014 Dilip Muthukrishnan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Renderable : NSObject
{
    CCTexture *_tex;
    int _numCells;
    int _cellWidth;
    int _cellHeight;
    float _time;
    float _duration;
}

@property (nonatomic, readonly) CCSprite *sprite;

- (id)initWithImageFile:(NSString *)imageFile duration:(float)duration numberOfCells:(int)numCells;
- (void)rewind;
- (void)animate:(CCTime)dt;


@end
