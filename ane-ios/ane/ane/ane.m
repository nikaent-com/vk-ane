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
#import <Foundation/Foundation.h>


FREContext eventContext;
VKStartScreen *tugeAneAdView;

NSString *appVkId;

FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &length, &value);
    
    appVkId = [NSString stringWithUTF8String: (char*) value];
    
    NSString *appName = [bundleInfo objectForKey:@"CFBundleIdentifier"];
    NSLog(@"AppName: %@",appName);
    NSLog(@"AppVkId: %@",appVkId);
    
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
    [tugeAneAdView start:appVkId scope:nil];
    
    return NULL;
}

FREObject login(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"login");
    
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &length, &value);
    NSString *strScope = [NSString stringWithUTF8String: (char*) value];
    NSData *data = [strScope dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *arrayScope = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:nil];
    
    [tugeAneAdView auth:arrayScope];
    NSLog(@"login: %@",arrayScope);
    return NULL;
}

FREObject isLoggedIn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"isLoggedIn");
    
    FREObject retBool = nil;
    FRENewObjectFromBool([VKSdk isLoggedIn], &retBool);
    
    return retBool;
}

FREObject logout(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSLog(@"logout");
    
    [VKSdk forceLogout];
    
    return NULL;
}

NSString* getString(FREObject obj){
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(obj, &length, &value);
    return [NSString stringWithUTF8String: (char*) value];
}

FREObject apiCall(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSString *method = getString(argv[0]);
    NSString *params = getString(argv[1]);
    NSLog(@"apiCall",params);

    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *paramsDic = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:nil];
    
    VKRequest *request = [VKApi requestWithMethod:method andParameters:paramsDic];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result: %@", response);
    }                    errorBlock:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    
/*    switch (method) {
        case 2:{
            NSLog(@"getUsers");
            NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];

            NSArray *arrayScope = [NSJSONSerialization JSONObjectWithData:data
                                                                  options:0
                                                                    error:nil];
            VKApi users
            VKRequest *request = [[VKApi users] get];
            [request executeWithResultBlock:^(VKResponse *response) {
                NSLog(@"Result: %@", response);
            }                    errorBlock:^(NSError *error) {
                NSLog(@"Error: %@", error);
            }];
        }break;
            
        default:
            break;
    }
 */
    
    return NULL;
}

void VolExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 5;
    
    FRENamedFunction* func = (FRENamedFunction*) malloc(sizeof(FRENamedFunction) * *numFunctionsToTest);
    
    func[0].name = (const uint8_t*) "init";
    func[0].functionData = NULL;
    func[0].function = &init;
    
    func[1].name = (const uint8_t*) "login";
    func[1].functionData = NULL;
    func[1].function = &login;
    
    func[2].name = (const uint8_t*) "isLoggedIn";
    func[2].functionData = NULL;
    func[2].function = &isLoggedIn;
    
    func[3].name = (const uint8_t*) "logout";
    func[3].functionData = NULL;
    func[3].function = &logout;
    
    func[4].name = (const uint8_t*) "apiCall";
    func[4].functionData = NULL;
    func[4].function = &apiCall;
    
    *functionsToSet = func;
}
void VolumeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    //initReg();
    
    *extDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}

