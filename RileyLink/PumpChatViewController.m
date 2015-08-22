//
//  PumpChatViewController.m
//  RileyLink
//
//  Created by Pete Schwamb on 8/8/15.
//  Copyright (c) 2015 Pete Schwamb. All rights reserved.
//

#import "PumpChatViewController.h"
#import "MinimedPacket.h"
#import "NSData+Conversion.h"
#import "Config.h"
#import "RileyLinkBLEManager.h"

@interface PumpChatViewController () {
  IBOutlet UILabel *resultsLabel;
  IBOutlet UILabel *batteryVoltage;
  IBOutlet UILabel *pumpIdLabel;

  BOOL waitingForWakeup;
  BOOL waitingForTempBasalHeaderAck;
  BOOL waitingForTempBasalArgsAck;
}

@end

@implementation PumpChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(packetReceived:)
                                               name:RILEY_LINK_EVENT_PACKET_RECEIVED
                                             object:self.device];
  
  pumpIdLabel.text = [NSString stringWithFormat:@"PumpID: %@", [[Config sharedInstance] pumpID]];
}

- (void)dealloc
{
  [[NSNotificationCenter defaultCenter] removeObserver: self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)queryPumpButtonPressed:(id)sender {
  [self queryPumpForVersion];
}

- (void)queryPumpForVersion {
  resultsLabel.text = @"Sending wakeup packets...";
  
  NSString *pumpId = [[Config sharedInstance] pumpID];
  
  NSString *packetStr = [@"a7" stringByAppendingFormat:@"%@5D00", pumpId];
  NSData *data = [NSData dataWithHexadecimalString:packetStr];
  waitingForWakeup = YES;
  [_device sendPacketData:[MinimedPacket encodeData:data] withCount:100 andTimeBetweenPackets:0.078];
}

- (void)handlePacketFromPump:(MinimedPacket*)p {
  if (p.messageType == MESSAGE_TYPE_PUMP_STATUS_ACK) {
    if (waitingForWakeup) {
      waitingForWakeup = NO;
      resultsLabel.text = @"Pump acknowleged wakeup!";
      NSLog(@"Acked wakeup");
      // set temp basal header
      NSString *packetStr = [@"a7" stringByAppendingFormat:@"%@%02x00", [[Config sharedInstance] pumpID], MESSAGE_TYPE_TEMP_BASAL];
      NSData *pdata = [NSData dataWithHexadecimalString:packetStr];
      waitingForTempBasalHeaderAck = YES;
      [_device sendPacketData:[MinimedPacket encodeData:pdata]];
    }
    else if (waitingForTempBasalHeaderAck) {
      waitingForTempBasalHeaderAck = NO;
      resultsLabel.text = @"Pump acked basal header!";
      NSLog(@"Acked basal header");
      // set temp basal with args
      NSString *packetStr = [@"a7" stringByAppendingFormat:@"%@%02x0300010100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", [[Config sharedInstance] pumpID], MESSAGE_TYPE_TEMP_BASAL];
      NSData *pdata = [NSData dataWithHexadecimalString:packetStr];
      waitingForTempBasalArgsAck = YES;
      [_device sendPacketData:[MinimedPacket encodeData:pdata]];
    }
    else if (waitingForTempBasalHeaderAck) {
      waitingForTempBasalHeaderAck = NO;
      NSLog(@"Acked basal args");
      resultsLabel.text = @"Pump acked basal args!";
    }
  }
}

- (void)packetReceived:(NSNotification*)notification {
  if (notification.object == self.device) {
    MinimedPacket *packet = notification.userInfo[@"packet"];
    if (packet && [packet.address isEqualToString:[[Config sharedInstance] pumpID]]) {
      [self handlePacketFromPump:packet];
    }
  }
}





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
