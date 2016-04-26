//
//  DeviceManager.h
//  Cat
//
//  Created by Macbook on 19.12.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum Device
{
    Ipad,
    IpadRetina,
    Iphone,
    IphoneRetina
} Device;

@interface DeviceManager : CCNode {
}

@property(assign) Device device;

-(void) returnCurrentDeviceToDeviceManager;

@end
