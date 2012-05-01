//
//  GoggleWindow.h
//  MacGoggles
//
//  Created by Esten C Hurtle on 4/26/12.
//

#import <AppKit/AppKit.h>
#import "GoggleView.h"
#import "GoggleViewController.h"

@interface GoggleWindow : NSWindow

@property (strong) NSArray *konamiCode;

@property (strong) NSMutableArray *buttonPresses;

@property (strong) GoggleViewController *windowViewController;

- (void) makeWindowViewFirstResponder;
- (void) doCleanup;

@end
