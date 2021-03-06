//
//  UIWebView+BlocksKit.m
//  BlocksKit
//

#import "UIWebView+BlocksKit.h"
#import "A2BlockDelegate+BlocksKit.h"

#pragma mark Custom delegate

@interface A2DynamicUIWebViewDelegate : A2DynamicDelegate
@end

@implementation A2DynamicUIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	BOOL ret = YES;
	
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)])
		ret = [realDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];

	BOOL (^block)(UIWebView *, NSURLRequest *, UIWebViewNavigationType) = [self blockImplementationForMethod:_cmd];
	if (block)
		ret &= block(webView, request, navigationType);

	return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(webViewDidStartLoad:)])
		[realDelegate webViewDidStartLoad:webView];

	void(^block)(UIWebView *) = [self blockImplementationForMethod:_cmd];
	if (block)
		block(webView);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(webViewDidFinishLoad:)])
		[realDelegate webViewDidFinishLoad:webView];

	void(^block)(UIWebView *) = [self blockImplementationForMethod:_cmd];
	if (block)
		block(webView);
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	id realDelegate = self.realDelegate;
	if (realDelegate && [realDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)])
		[realDelegate webView:webView didFailLoadWithError:error];

	void(^block)(UIWebView *, NSError *) = [self blockImplementationForMethod:_cmd];
	if (block)
		block(webView, error);
}

@end

#pragma mark Category

@implementation UIWebView (BlocksKit)

@dynamic shouldStartLoadBlock, didStartLoadBlock, didFinishLoadBlock, didFinishWithErrorBlock;

+ (void)load {
	@autoreleasepool {
		[self registerDynamicDelegate];
		NSDictionary *methods = [NSDictionary dictionaryWithObjectsAndKeys:
								 @"webView:shouldStartLoadWithRequest:navigationType:", @"shouldStartLoadBlock",
								 @"webViewDidStartLoad:", @"didStartLoadBlock",
								 @"webViewDidFinishLoad:", @"didFinishLoadBlock",
								 @"webView:didFailLoadWithError:", @"didFinishWithErrorBlock",
								 nil];
		[self linkDelegateMethods:methods];
	}
}

@end

BK_MAKE_CATEGORY_LOADABLE(UIWebView_BlocksKit)