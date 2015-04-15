//
//  ViewController.m
//  PubNub_chat
//
//  Created by Pavel on 15.04.15.
//  Copyright (c) 2015 Zitech Mobile LLC. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // #1 Define client configuration
//    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
//                                                             publishKey:@"demo"
//                                                           subscribeKey:@"demo"
//                                                              secretKey:nil];
//    // #2 make the configuration active
//    [PubNub setConfiguration:myConfig];
//    
//    // #3 Connect to the PubNub
//    [PubNub connect];
//    
//    // #1 Define channel
//    PNChannel *my_channel = [PNChannel channelWithName:@"a"
//                                 shouldObservePresence:YES];
//    
//    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
//        if (connected)
//        {
//            NSLog(@"OBSERVER: Successful Connection!");
//            // #2 Subscribe if client connects successfully
//            [PubNub subscribeOnChannel:my_channel];
//        }
//        else if (!connected || connectionError)
//        {
//            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
//        }
//    }];
//    
//    // #3 Added Observer to look for subscribe events
//    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self withCallbackBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error){
//        switch (state) {
//            case PNSubscriptionProcessSubscribedState:
//                NSLog(@"OBSERVER: Subscribed to Channel: %@", channels[0]);
//                break;
//            case PNSubscriptionProcessNotSubscribedState:
//                NSLog(@"OBSERVER: Not subscribed to Channel: %@, Error: %@", channels[0], error);
//                break;
//            case PNSubscriptionProcessWillRestoreState:
//                NSLog(@"OBSERVER: Will re-subscribe to Channel: %@", channels[0]);
//                break;
//            case PNSubscriptionProcessRestoredState:
//                NSLog(@"OBSERVER: Re-subscribed to Channel: %@", channels[0]);
//                break;
//        }
//    }];
//    
//    // #4 Added Observer to look for message received events
//    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
//        
//        NSLog(@"OBSERVER: Channel: %@, Message: %@", message.channel.name, message.message);
//        if ( [[[NSString stringWithFormat:@"%@", message.message] substringWithRange:NSMakeRange(1,14)] isEqualToString: @"**************" ])
//        {
//            // Bonus #1 send a goodbye message
//            [PubNub sendMessage:[NSString stringWithFormat:@"Thank you, GOODBYE!" ] toChannel:my_channel withCompletionBlock:^(PNMessageState messageState, id data) {
//                // Bonus #2 unsubscribe only if message is sent
//                if (messageState == PNMessageSent) {
//                    NSLog(@"OBSERVER: Sent Goodbye Message!");
//                    [PubNub unsubscribeFromChannel:my_channel ];
//                }
//            }];
//        }
//    }];
//    
//    // #5 Added observer to catch an unsubscribe event
//    [[PNObservationCenter defaultCenter] addClientChannelUnsubscriptionObserver:self withCallbackBlock:^(NSArray *channel, PNError *error) {
//        if ( error == nil )
//        {
//            NSLog(@"OBSERVER: Unsubscribed from Channel: %@", channel[0]);
//            // #3 Subscribe to the channel after an unsubscribe
//            [PubNub subscribeOnChannel:my_channel];
//        }
//        else
//        {
//            NSLog(@"OBSERVER: Unsubscribed from Channel: %@, Error: %@", channel[0], error);
//        }
//    }];
    
    
    PNConfiguration *myConfig = [PNConfiguration configurationForOrigin:@"pubsub.pubnub.com"
                                                             publishKey:@"demo"
                                                           subscribeKey:@"demo"
                                                              secretKey:nil];
    // #1 define new channel name "demo"
    PNChannel *my_channel = [PNChannel channelWithName:@"demo"
                                 shouldObservePresence:YES];
    
    [PubNub setConfiguration:myConfig];
    [PubNub connect];
    
    [[PNObservationCenter defaultCenter] addClientConnectionStateObserver:self withCallbackBlock:^(NSString *origin, BOOL connected, PNError *connectionError){
        
        if (connected)
        {
            NSLog(@"OBSERVER: Successful Connection!");
            
            // Subscribe on the channel
            [PubNub subscribeOnChannel:my_channel];
        }
        else if (!connected || connectionError)
        {
            NSLog(@"OBSERVER: Error %@, Connection Failed!", connectionError.localizedDescription);
        }
        
    }];
    
    
    [[PNObservationCenter defaultCenter] addClientChannelSubscriptionStateObserver:self withCallbackBlock:^(PNSubscriptionProcessState state, NSArray *channels, PNError *error){
        
        switch (state) {
            case PNSubscriptionProcessSubscribedState:
                NSLog(@"OBSERVER: Subscribed to Channel: %@", channels[0]);
                // #2 Send a welcome message on subscribe
                [PubNub sendMessage:[NSString stringWithFormat:@"Hello Everybody!" ] toChannel:my_channel ];
                break;
            case PNSubscriptionProcessNotSubscribedState:
                NSLog(@"OBSERVER: Not subscribed to Channel: %@, Error: %@", channels[0], error);
                break;
            case PNSubscriptionProcessWillRestoreState:
                NSLog(@"OBSERVER: Will re-subscribe to Channel: %@", channels[0]);
                break;
            case PNSubscriptionProcessRestoredState:
                NSLog(@"OBSERVER: Re-subscribed to Channel: %@", channels[0]);
                break;
        }
    }];
    
    
    [[PNObservationCenter defaultCenter] addClientChannelUnsubscriptionObserver:self withCallbackBlock:^(NSArray *channel, PNError *error) {
        if ( error == nil )
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@", channel[0]);
            [PubNub subscribeOnChannel:my_channel];
        }
        else
        {
            NSLog(@"OBSERVER: Unsubscribed from Channel: %@, Error: %@", channel[0], error);
        }
    }];
    
    
    // Observer looks for message received events
    [[PNObservationCenter defaultCenter] addMessageReceiveObserver:self withBlock:^(PNMessage *message) {
        NSLog(@"OBSERVER: Channel: %@, Message: %@", message.channel.name, message.message);
        
        // Look for a message that matches "**************"
        if ( [[[NSString stringWithFormat:@"%@", message.message] substringWithRange:NSMakeRange(1,14)] isEqualToString: @"**************" ])
        {
            // Send a goodbye message
            [PubNub sendMessage:[NSString stringWithFormat:@"Thank you, GOODBYE!" ] toChannel:my_channel withCompletionBlock:^(PNMessageState messageState, id data) {
                if (messageState == PNMessageSent) {
                    NSLog(@"OBSERVER: Sent Goodbye Message!");
                    //Unsubscribe once the message has been sent.
                    [PubNub unsubscribeFromChannel:my_channel ];
                }
            }];
        }
    }];
    
    
    // #3 Add observer to catch message send events.
    [[PNObservationCenter defaultCenter] addMessageProcessingObserver:self withBlock:^(PNMessageState state, id data){
        
        switch (state) {
            case PNMessageSent:
                NSLog(@"OBSERVER: Message Sent.");
                break;
            case PNMessageSending:
                NSLog(@"OBSERVER: Sending Message...");
                break;
            case PNMessageSendingError:
                NSLog(@"OBSERVER: ERROR: Failed to Send Message.");
                break;
            default:
                break;
        }
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
