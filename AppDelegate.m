//
//  AppDelegate.m
//  osx
//
//  Created by Teus Benschop on 28/05/2015.
//  Copyright (c) 2015 Teus Benschop. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WebKit.h>
#import "bibledit.h"

@interface AppDelegate ()

@property (weak) IBOutlet WebView *webview;
@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    NSArray *components = [NSArray arrayWithObjects:[[NSBundle mainBundle] resourcePath], @"webroot", nil];
    NSString *packagePath = [NSString pathWithComponents:components];

    NSString * documents = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    components = [NSArray arrayWithObjects:documents, @"webroot", nil];
    NSString *webrootPath = [NSString pathWithComponents:components];

    const char * package = [packagePath UTF8String];
    const char * webroot = [webrootPath UTF8String];
    
    bibledit_initialize_library (package, webroot);
    bibledit_start_library ();
    
    // Open the web app in the web view
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    [[[self webview] mainFrame] loadRequest:urlRequest];
    [self.window setContentView:self.webview];
    
    float timezoneoffset = ([[NSTimeZone systemTimeZone] secondsFromGMT] / 3600.0);
    bibledit_set_timezone_hours_offset_utc ((int)timezoneoffset);
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    bibledit_stop_library ();
    while (bibledit_is_running ()) {}
    bibledit_shutdown_library ();
}

@end
