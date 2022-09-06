//
//  NSString+SHA1.h
//  BeautyTruth
//
//  Created by TobyDev on 04/07/2020.
//

#import <Foundation/Foundation.h>

@interface NSString (SHA1)

- (NSString *)hashedValue:(NSString *)key;

@end

