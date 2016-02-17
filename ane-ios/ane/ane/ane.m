//
//  ane.m
//  ane
//
//  Created by Aleksey Kabanov on 15.02.16.
//  Copyright © 2016 Aleksey Kabanov. All rights reserved.
//

#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import "VKStartScreen.h"

FREContext eventContext;

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"init FREOBJECT")
    VKStartScreen *vkstart = [[VKStartScreen alloc] init];
    [vkstart viewDidLoad];
    
    eventContext = ctx;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test Message"
                                                    message:@"This is a test"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    return NULL;
}

FREObject setVolume(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    return NULL;
}

void VolExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;
    
    func[1].name = (const uint8_t*) "setVolume";
    func[1].functionData = NULL;
    func[1].function = &setVolume;
    
    *functionsToSet = func;
}
void VolumeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}
