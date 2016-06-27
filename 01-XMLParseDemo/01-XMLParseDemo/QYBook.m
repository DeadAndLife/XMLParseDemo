//
//  QYBook.m
//  01-XMLParseDemo
//
//  Created by qingyun on 16/6/25.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "QYBook.h"

@implementation QYBook
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"category"]) {
        _Kcategory=value;
    }

}


@end
