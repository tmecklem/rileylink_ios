//
//  MinimedPump.m
//  RileyLink
//
//  Created by Pete Schwamb on 8/21/15.
//  Copyright (c) 2015 Pete Schwamb. All rights reserved.
//

#import "MinimedPacket.h"
#import "MinimedPump.h"
#import "NSData+Conversion.h"

@interface MinimedPump () {
  BOOL rfPowerOn;
}

@property (strong, nonatomic) CBCentralManager *centralManager;
@property (strong, nonatomic) NSMutableData *data;

@end


@implementation MinimedPump

- (void) setTempBasalRate:(float)rate withDuration:(int)minutes completion:(void(^)(void))callback {
  NSString *packetStr = [@"a7" stringByAppendingFormat:@"%@%02x00", self.pumpID, MESSAGE_TYPE_GET_BATTERY];
  NSData *data = [NSData dataWithHexadecimalString:packetStr];
  [_device sendPacketData:[MinimedPacket encodeData:data]];
}

- (void) enableRF:(void(^)(void))callback {
  NSString *packetStr = [@"a7" stringByAppendingFormat:@"%@5D00", self.pumpID];
  NSData *data = [NSData dataWithHexadecimalString:packetStr];
  [_device sendPacketData:[MinimedPacket encodeData:data] withCount:100 andTimeBetweenPackets:0.078];
}


@end
