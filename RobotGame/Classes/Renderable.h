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
}

@property (nonatomic, readonly) CCSprite *sprite;
@property (nonatomic, readonly) CCTime duration;

- (id)initWithImageFile:(NSString *)imageFile
               duration:(CCTime)duration
          numberOfCells:(int)numCells;

- (void)rewind:(float)progress;  // Between 0.0 and 1.0 (0.0 = begin and 1.0 = end)
- (void)animate:(CCTime)dt;


@end
