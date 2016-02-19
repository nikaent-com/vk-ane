//
//  VKStartScreen.m
//
//  Copyright (c) 2014 VK.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "VKStartScreen.h"

static NSString *const TOKEN_KEY = @"my_application_access_token";
static NSString *const NEXT_CONTROLLER_SEGUE_ID = @"START_WORK";
static NSArray *SCOPE = nil;

@interface VKStartScreen () <UIAlertViewDelegate, VKSdkUIDelegate>

@end

@implementation VKStartScreen

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)start {
    SCOPE = @[VK_PER_FRIENDS, VK_PER_WALL, VK_PER_AUDIO, VK_PER_PHOTOS, VK_PER_NOHTTPS, VK_PER_EMAIL, VK_PER_MESSAGES];
    [[VKSdk initializeWithAppId:@"5282890"] registerDelegate:self];
    [[VKSdk instance] setUiDelegate:self];
    [VKSdk wakeUpSession:SCOPE completeBlock:^(VKAuthorizationState state, NSError *error) {
        if (state == VKAuthorizationAuthorized) {
            [self startWorking];
        } else if (error) {
            [[[UIAlertView alloc] initWithTitle:nil message:[error description] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
        }else{
            [self auth];
        }
    }];
}

- (void)startWorking {
    //[self performSegueWithIdentifier:NEXT_CONTROLLER_SEGUE_ID sender:self];
    [self getUsers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)authorize:(id)sender {
    [VKSdk authorize:SCOPE];
}

-(void) auth{
    [[[UIAlertView alloc] initWithTitle:nil message:@"auth" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    [VKSdk authorize:SCOPE];
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


- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError {
    VKCaptchaViewController *vc = [VKCaptchaViewController captchaControllerWithError:captchaError];
    [vc presentIn:self.navigationController.topViewController];
}

- (void)vkSdkTokenHasExpired:(VKAccessToken *)expiredToken {
    [self authorize:nil];
}

- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result {
    if (result.token) {
        [self startWorking];
    } else if (result.error) {
        NSLog([NSString stringWithFormat:@"Access denied\n%@", result.error]);
    }
}

- (void)vkSdkUserAuthorizationFailed {
    NSLog(@"Access denied\n%@");
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)vkSdkShouldPresentViewController:(UIViewController *)controller {
    [[[UIAlertView alloc] initWithTitle:nil message:@"vkSdkShouldPresentViewController" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil] show];
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [VKSdk processOpenURL:url fromApplication:sourceApplication];
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
}

@end
