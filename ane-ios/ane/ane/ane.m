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
#import <Foundation/Foundation.h>


FREContext eventContext;
VKStartScreen *vkscreen;

NSString *appVkId;

uint32_t _reqCounter = 0;
BOOL isDebug = false;

void traceToAne(NSString *str){
    if(isDebug){
        NSLog(str);
    }
    FREDispatchStatusEventAsync(eventContext,
                                ( const uint8_t * ) "LOG",
                                ( const uint8_t * ) [str UTF8String] );
    
}


FREObject init(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    NSDictionary *bundleInfo = [[NSBundle mainBundle] infoDictionary];
    
    
    uint32_t bIsDebug;
    FREGetObjectAsBool(argv[1], &bIsDebug);
    isDebug = 1 == bIsDebug;
    
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &length, &value);
    
    appVkId = [NSString stringWithUTF8String: (char*) value];
    
    NSString *appName = [bundleInfo objectForKey:@"CFBundleIdentifier"];
    
    vkscreen = [[VKStartScreen alloc] init];
    UIScreen *sc = [UIScreen mainScreen];
    CGRect rect0 = sc.bounds;
    
    CGRect rect = CGRectMake(0, 0, rect0.size.width, rect0.size.height);
    vkscreen.view.frame = rect;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    UIWindow * win = [delegate window];
    [win addSubview:vkscreen.view];
    
    [vkscreen.view setUserInteractionEnabled:false];
    
    eventContext = ctx;
    [vkscreen start:appVkId scope:nil];
    
    traceToAne([NSString stringWithFormat:@"AppName: %@",appName]);
    traceToAne([NSString stringWithFormat:@"AppVkId: %@",appVkId]);
    
    return NULL;
}

FREObject login(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    traceToAne(@"begin login");
    
    uint32_t length;
    const uint8_t *value;
    FREGetObjectAsUTF8(argv[0], &length, &value);
    NSString *strScope = [NSString stringWithUTF8String: (char*) value];
    traceToAne([NSString stringWithFormat:@"strScope: %@",strScope]);
    NSData *data = [strScope dataUsingEncoding:NSUTF8StringEncoding];
    traceToAne([NSString stringWithFormat:@"data: %@",data]);
    
    NSArray *arrayScope = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:nil];
    traceToAne([NSString stringWithFormat:@"arrayScope: %lu",(unsigned long)arrayScope.count]);
    traceToAne([NSString stringWithFormat:@"arrayScope: %@",arrayScope]);
    [vkscreen auth:arrayScope];
    traceToAne(@"end login");
    return NULL;
}

FREObject isLoggedIn(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    traceToAne(@"isLoggedIn");
    
    FREObject retBool = nil;
    FRENewObjectFromBool([VKSdk isLoggedIn], &retBool);
    
    return retBool;
}

FREObject logout(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    traceToAne(@"logout");
    
    [VKSdk forceLogout];
    
    return NULL;
}

FREObject testCaptcha(FREContext ctx, void* funcData, uint32_t argc, FREObject argv[])
{
    traceToAne(@"testCaptcha");
    
    [vkscreen testCaptcha];
    
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
    traceToAne([NSString stringWithFormat:@"apiCall",params]);

    NSData *data = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *paramsDic = [NSJSONSerialization JSONObjectWithData:data
                                                          options:0
                                                            error:nil];
    
    VKRequest *request = [VKApi requestWithMethod:method andParameters:paramsDic];

    uint32_t idReq = ++_reqCounter;
    NSString *idString = [NSString stringWithFormat:@"%d",idReq];
    FREObject returnIdRequest = nil;
    FRENewObjectFromUTF8(strlen([idString UTF8String]), (const uint8_t *)[idString UTF8String], &returnIdRequest);
    
    [request executeWithResultBlock:^(VKResponse *response) {
        NSString *code = [NSString stringWithFormat:@"response%d",idReq];
        FREDispatchStatusEventAsync(eventContext,
                                    ( const uint8_t * ) [code UTF8String],
                                    ( const uint8_t * ) [[response responseString] UTF8String] );

        traceToAne([NSString stringWithFormat:@"Result: %@", response]);
    }                    errorBlock:^(NSError *error) {
        NSString *code = [NSString stringWithFormat:@"responseError%d",idReq];
        NSString *errorJson = [NSString stringWithFormat:@"{\"vkErrorCode\":%ld, \"message\":\"%@\"}",(long)error.vkError.errorCode,error.vkError.errorMessage];
        FREDispatchStatusEventAsync(eventContext,
                                    ( const uint8_t * ) [code UTF8String],
                                    ( const uint8_t * ) [errorJson UTF8String]);
        traceToAne([NSString stringWithFormat:@"Error: %@", [error localizedDescription]]);
    }];
    
    return returnIdRequest;
}


void VolExtContextInitializer(void* extData, const uint8_t* ctxType, FREContext ctx, uint32_t* numFunctionsToTest, const FRENamedFunction** functionsToSet)
{
    *numFunctionsToTest = 6;
    
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
    
    func[5].name = (const uint8_t*) "testCaptcha";
    func[5].functionData = NULL;
    func[5].function = &testCaptcha;
    
    *functionsToSet = func;
}
void VolumeExtensionInitializer(void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet)
{
    *extDataToSet = NULL;
    *ctxInitializerToSet = &VolExtContextInitializer;
}

