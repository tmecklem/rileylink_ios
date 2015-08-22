//
//  MinimedPump.h
//  RileyLink
//
//  Created by Pete Schwamb on 8/21/15.
//  Copyright (c) 2015 Pete Schwamb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RileyLinkBLEDevice.h"

@interface MinimedPump : NSObject

@property (nonatomic, strong) NSString *pumpID;
@property (nonatomic, strong) RileyLinkBLEDevice *device;

- (void) setTempBasalRate:(float)rate withDuration:(int)minutes completion:(void(^)(void))callback;

- (void) enableRF:(void(^)(void))callback;

@end
