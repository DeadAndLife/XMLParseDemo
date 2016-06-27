//
//  QYBook.h
//  01-XMLParseDemo
//
//  Created by qingyun on 16/6/25.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QYBook : NSObject
@property(nonatomic,strong)NSString *Kcategory;
@property(nonatomic,strong)NSString *lang;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *author;
@property(nonatomic,strong)NSString *year;
@property(nonatomic,strong)NSString *price;
@end
