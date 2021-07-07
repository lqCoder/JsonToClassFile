//
//  CreateFileModel.h
//  JsToClassFile
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PropertyModel : NSObject//属性类
@property (nonatomic,strong) id keyObject;
@property (nonatomic,strong) id valueObject;

@property (nonatomic,copy) NSString* convertString;
@end

@interface ClassModel : NSObject//表示类
@property (nonatomic,copy) NSString * myClassName;
@property (nonatomic,strong) NSMutableArray* fieldsArray;

@end
