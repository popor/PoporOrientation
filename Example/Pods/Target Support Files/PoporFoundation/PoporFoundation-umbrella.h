#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "NSObject+pAssign.h"
#import "NSObject+pPerformSelector.h"
#import "NSObject+pSwizzling.h"

FOUNDATION_EXPORT double PoporFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char PoporFoundationVersionString[];

