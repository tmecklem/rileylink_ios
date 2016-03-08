//
//  PumpOpsSynchronous.h
//  RileyLink
//
//  Created by Pete Schwamb on 1/29/16.
//  Copyright © 2016 Pete Schwamb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PumpState.h"
#import "RileyLinkBLEDevice.h"

@interface PumpOpsSynchronous : NSObject

- (nonnull instancetype)initWithPump:(nonnull PumpState *)pump andSession:(nonnull RileyLinkCmdSession *)session NS_DESIGNATED_INITIALIZER;

@property (readonly, strong, nonatomic, nonnull) PumpState *pump;
@property (readonly, strong, nonatomic, nonnull) RileyLinkCmdSession *session;

- (BOOL) wakeup:(uint8_t)duration;
- (void) pressButton;
@property (NS_NONATOMIC_IOSONLY, getter=getPumpModel, readonly, copy) NSString * _Nullable pumpModel;
@property (NS_NONATOMIC_IOSONLY, getter=getBatteryVoltage, readonly, copy) NSDictionary * _Nonnull batteryVoltage;
- (NSDictionary* _Nonnull) getHistoryPage:(uint8_t)pageNum;
@property (NS_NONATOMIC_IOSONLY, readonly, copy) NSDictionary * _Nonnull scanForPump;

/**
 Send some data and wait for a response, with a default timeout.

 @param data         The data to send
 @param retryCount   The number of retries
 @param responseType The response type to expect

 @return The response data
 */
- (nullable NSData *) sendData:(nonnull NSData *)data retryCount:(NSUInteger)retryCount andListenForResponseType:(uint8_t)responseType;

/**
 Send some data and wait for a response, with a default timeout and repeat interval.

 @param data         The data to send
 @param responseType The response type to expect

 @return The response data
 */
- (nullable NSData *) sendData:(nonnull NSData *)data andListenForResponseType:(uint8_t)responseType;

@end
