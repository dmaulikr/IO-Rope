//
//  Star.h
//  Project
//
//  Created by Igor on 27.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Bonus.h"

@interface Star : Bonus {
    
}

+(id) initStar:(CGPoint)position world:(b2World *)world layer:(GamePlayLayer *)layer;

@end
