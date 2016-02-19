//
//  ane.m
//  ane
//
//  Created by Aleksey Kabanov on 15.02.16.
//  Copyright © 2016 Aleksey Kabanov. All rights reserved.
//

#define NSLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }


#import "FlashRuntimeExtensions.h"
#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import "VKStartScreen.h"


FREContext eventContext;
VKStartScreen *tugeAneAdView;

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    NSString *appName = [bundleInfo objectForKey:@"CFBundleIdentifier"];
    NSLog(@"AppName: %@",appName);
    
    tugeAneAdView = [[VKStartScreen alloc] init];
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect0 = sc.bounds;
    
    CGRect rect = CGRectMake(0, 0, rect0.size.width, rect0.size.height);
    tugeAneAdView.view.frame = rect;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
    [win addSubview:tugeAneAdView.view];
    
    [tugeAneAdView.view setUserInteractionEnabled:false];
    
    eventContext = ctx;
    
    [tugeAneAdView start];
    
    return NULL;
}

FREObject login(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"login");
    [tugeAneAdView auth];
    return NULL;
}

void VolExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 2;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;
    
    func[1].name = (const uint8_t*) "login";
    func[1].functionData = NULL;
    func[1].function = &login;
    
    *functionsToSet = func;
}
void VolumeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}

void registerForRemote()
{
    NSLog(@"AsPush :: registering app for remote notifications.");
    
    //Code below found on stack overflow. Fantastic find.
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    Class objectClass = object_getClass(delegate);
    
    NSString *newClassName = [NSString stringWithFormat:@"Custom_%@", NSStringFromClass(objectClass)];
    Class modDelegate = NSClassFromString(newClassName);
    if (modDelegate == nil)
    {
        // this class doesn't exist; create it
        // allocate a new class
        modDelegate = objc_allocateClassPair(objectClass, [newClassName UTF8String], 0);
        
        SEL selectorToOverride1 = @selector(application:openURL:options:);
        SEL selectorToOverride2 = @selector(application:openURL:);
        
        Method m1 = class_getInstanceMethod([VKStartScreen class], selectorToOverride1);
        Method m2 = class_getInstanceMethod([VKStartScreen class], selectorToOverride2);
        
        IMP theImplementation1 = [tugeAneAdView methodForSelector:selectorToOverride1];
        IMP theImplementation2 = [tugeAneAdView methodForSelector:selectorToOverride2];
        
        class_addMethod(modDelegate, selectorToOverride1, theImplementation1, method_getTypeEncoding(m1));
        class_addMethod(modDelegate, selectorToOverride2, theImplementation2, method_getTypeEncoding(m2));
                                                                                // register the new class with the runtime
        objc_registerClassPair(modDelegate);
                                                                                }
                                                                                // change the class of the object
        object_setClass(delegate, modDelegate);
                                                                                
                                                                                //Register this app for remote notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
}

