#import <UIKit/UIKit.h>
#import <VKSdk/VKSdk.h>
#import "FlashRuntimeExtensions.h"

@interface VKStartScreen : UIViewController <VKSdkDelegate>{
@private
VKRequest *callingRequest;
FREContext _eventContext;
}

- (void) auth:(NSArray *) scope;
- (void) regSender:(FREContext) eventContext;
- (void) start:(NSString*) appVkId scope:(NSArray *) scope;
- (void) testCaptcha;

@end

