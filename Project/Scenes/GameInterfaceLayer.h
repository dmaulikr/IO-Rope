//
//  GameInterfaceLayer.h
//  Project
//
//  Created by Igor on 18.02.13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ZJoystick.h"
#import "Box2D.h"

@interface GameInterfaceLayer : CCLayer <ZJoystickDelegate> {
    ZJoystick *rightJoystick;
    ZJoystick *leftJoystick;
}
@end
