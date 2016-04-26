//
//  Thorns.h
//  Project
//
//  Created by Igor on 01.03.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "StaticEnemies.h"


@interface Thorns : StaticEnemies {
}


+(id) initThorns:(b2Body*)body layer:(GamePlayLayer *)layer;

@end
