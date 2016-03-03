#import "VKStartScreen.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";
static NSArray *SCOPE = nil;

@interface VKStartScreen () <UIAlertViewDelegate, VKSdkUIDelegate>

@end

@implementation VKStartScreen

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initReg];
}
- (void)start:(NSString*) appVkId scope:(NSArray *) scope {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    id delegate = [[UIApplication sharedApplication] delegate];
    [[VKSdk initializeWithAppId:appVkId] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            NSLog(@"error VKAuthorization");
        }
    }];
}

- (void)startWorking {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) auth:(NSArray *) scope{
    [VKSdk authorize:scope];
}

- (IBAction)openShareDialog:(id)sender {
    VKShareDialogController *shareDialog = [VKShareDialogController new];
    shareDialog.text = @"This post created created created created and made and post and delivered using #vksdk #ios";
    shareDialog.uploadImages = @[ [VKUploadImage uploadImageWithImage:[UIImage imageNamed:@"apple"] andParams:[VKImageParameters jpegImageWithQuality:1.0] ] ];
    [shareDialog setCompletionHandler:^(VKShareDialogController *dialog, VKShareDialogControllerResult result) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:shareDialog animated:YES completion:nil];
}

-(void) getUsers{
    [self callMethod:[[VKApi users] get:@{VK_API_FIELDS : @"first_name, last_name, uid, photo_100", VK_API_USER_IDS : @[@(1), @(2), @(3)]}]];

}

- (void)callMethod:(VKRequest *)method {
    self->callingRequest = method;
    
    self->callingRequest.debugTiming = YES;
    self->callingRequest.requestTimeout = 10;
    
    [self->callingRequest executeWithResultBlock:^(VKResponse *response) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Result: %@", response] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
      }errorBlock:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"Error: %@", error] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        self->callingRequest = nil;
    }];
}

- (void)testCaptcha {
    VKRequest *request = [[VKApiCaptcha new] force];
    [request executeWithResultBlock:^(VKResponse *response) {
        NSLog(@"Result testCaptcha: %@", response);
    }                    errorBlock:^(NSError *error) {
        NSLog(@"Error testCaptcha: %@", error);
    }];
}


- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [VKSdk authorize:nil];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self startWorking];
    } else if (result.error) {
        NSLog([NSString stringWithFormat:@"Access denied\n%@", result.error]);
    }
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"Access denied\n");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    NSLog(@"vkSdkShouldPresentViewController\n");
    
    [self presentViewController:controller animated:YES completion:nil];
}

-(void) initReg
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
        
        SEL selectorToOverride1 = @selector(application:openURL:sourceApplication:annotation:);
        SEL selectorToOverride2 = @selector(application:didFinishLaunchingWithOptions:);
        
        Method m1 = class_getInstanceMethod([VKStartScreen class], selectorToOverride1);
        Method m2 = class_getInstanceMethod([VKStartScreen class], selectorToOverride2);
        
        IMP theImplementation1 = [self methodForSelector:selectorToOverride1];
        IMP theImplementation2 = [self methodForSelector:selectorToOverride2];
        
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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    return YES;
}

@end
