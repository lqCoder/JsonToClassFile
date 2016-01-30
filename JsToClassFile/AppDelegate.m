//
//  AppDelegate.m
//  JsToClassFile
//  Created by li qiao  on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//注意: 转成的类文件的建立格式与MJExtension第三方框架数据生成的格式相同，最好与MJExtension配套使用。我把转换的大体思路写出来了，我用的是MJExtension旧版本，MJExtension新版本的一些数据转换的地方变了，现在这个就不适用了。我就需要使用着看懂我的代码自己修改了。

#import "AppDelegate.h"
#import "CreateFileModel.h"
#import "JSONKit.h"

@interface AppDelegate ()
@property (weak) IBOutlet NSTextField* classText;
@property (weak) IBOutlet NSWindow* window;

@property (weak) IBOutlet NSScrollView *textScrollView;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    
}

- (IBAction)createClassFile:(id)sender
{
    NSTextView* jsonTextView=(NSTextView*)self.textScrollView.contentView.documentView;
    
    NSString* jsonStr=jsonTextView.textStorage.string;
    NSDictionary* dic = [self GetDictionaryWithJson:jsonStr];
    if (dic == nil) {
        jsonTextView.string = @"JSON格式错误";
        return;
    }
    NSString* className = self.classText.stringValue;
    if (className==nil||className.length<1) {
        className=@"lqClass";
    }
    className=[self stringToClassName:className];
    NSArray* keyArray = [dic allKeys];

    NSMutableArray* createFileModelArray = [[NSMutableArray alloc] init];
    [self ergodicMethod:keyArray dataSourceDic:dic className:className createFileModelArray:createFileModelArray];

    [self createJsonModelFily:createFileModelArray classFileName:className];
}

- (void)ergodicMethod:(NSArray*)keyArray dataSourceDic:(NSDictionary*)dic className:(NSString*)className createFileModelArray:(NSMutableArray*)createFileModelArray
{
    ClassModel* createFileModel = [[ClassModel alloc] init];
    createFileModel.myClassName = className;
    createFileModel.fieldsArray = [[NSMutableArray alloc] init];
    [createFileModelArray addObject:createFileModel];

    for (int i = 0; i < keyArray.count; i++) {
        id key = [keyArray objectAtIndex:i];
        id value = [dic objectForKey:key];
        
        PropertyModel* fieldsModel = [[PropertyModel alloc] init];
        fieldsModel.keyObject = key;
        fieldsModel.valueObject = value;
        
        key=[self stringToClassName:key];

        if ([value isKindOfClass:[NSDictionary class]]) {
            NSDictionary* dicChild = (NSDictionary*)value;
            NSArray* dicChildKeyArray = [dicChild allKeys];
//            NSString* tempClassName = [NSString stringWithFormat:@"%@Child", key];
            NSString* tempClassName=[NSString stringWithFormat:@"%@%@",className,key];

            fieldsModel.convertString=tempClassName;
            [self ergodicMethod:dicChildKeyArray dataSourceDic:dicChild className:tempClassName createFileModelArray:createFileModelArray];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            NSArray* tempArray = (NSArray*)value;

            if (tempArray.count > 0) {
                id arrayValue = tempArray[0];
                if ([arrayValue isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary* dicChild = (NSDictionary*)arrayValue;
                    NSArray* dicChildKeyArray = [dicChild allKeys];
//                    NSString* tempClassName = [NSString stringWithFormat:@"%@Child", key];
                    NSString* tempClassName = [NSString stringWithFormat:@"%@%@",className,key];

                    fieldsModel.convertString = tempClassName;
                    
                    [self ergodicMethod:dicChildKeyArray dataSourceDic:dicChild className:tempClassName createFileModelArray:createFileModelArray];
                }
            }else{
//                fieldsModel.convertString=[NSString stringWithFormat:@"%@Child", key];
                fieldsModel.convertString=[NSString stringWithFormat:@"%@%@",className,key];
                
                ClassModel* emptyArrayCreateFileModel = [[ClassModel alloc] init];
                emptyArrayCreateFileModel.myClassName = fieldsModel.convertString;
                emptyArrayCreateFileModel.fieldsArray = [[NSMutableArray alloc] init];
                [createFileModelArray addObject:emptyArrayCreateFileModel];
            }
        }

        [createFileModel.fieldsArray addObject:fieldsModel];
    }
}

-(void)createJsonModelFily:(NSMutableArray*)createFileModelArray classFileName:(NSString*)className{
    NSString* pointHFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import <Foundation/Foundation.h>\r\n"];
//    NSString* pointHFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import \"BaseResponseData.h\"\r\n"];
    NSString* pointMFileStr = [NSString stringWithFormat:@"//  Created by li qiao robot \r\n#import \"%@.h\" \r\n",className];
    for (NSInteger i=createFileModelArray.count-1;i>=0;i--) {
        ClassModel* createFileModel =[createFileModelArray objectAtIndex:i];
        pointHFileStr = [pointHFileStr stringByAppendingString:[NSString stringWithFormat:@"@interface %@ : NSObject\r\n", createFileModel.myClassName]];
        pointMFileStr = [pointMFileStr stringByAppendingString:[NSString stringWithFormat:@"@implementation %@\r\n", createFileModel.myClassName]];
        
        NSString* convertString=nil;
        for (PropertyModel* fieldsModel in createFileModel.fieldsArray) {
            NSString* fileStr;
            if ([fieldsModel.valueObject isKindOfClass:[NSString class]]) {
                fileStr = [NSString stringWithFormat:@"@property (copy,nonatomic)   NSString *%@;\r\n", fieldsModel.keyObject];
            }
            else if ([fieldsModel.valueObject isKindOfClass:[NSNumber class]]) {
                fileStr = [NSString stringWithFormat:@"@property (strong,nonatomic) NSNumber *%@;\r\n", fieldsModel.keyObject];
            }
            else if ([fieldsModel.valueObject isKindOfClass:[NSArray class]]) {
                fileStr = [NSString stringWithFormat:@"@property (strong,nonatomic) NSArray *%@;\r\n", fieldsModel.keyObject];
                
                NSLog(@"fieldsModel.convertString:%@",fieldsModel.convertString);
                if (convertString) {
                    convertString=[NSString stringWithFormat:@"%@,@\"%@\" : [%@ class]",convertString,fieldsModel.keyObject,fieldsModel.convertString!=nil?fieldsModel.convertString:@"NSString"];
                }else{
                    convertString=[NSString stringWithFormat:@"-(NSDictionary*)objectClassInArray{  \r\n       return @{ @\"%@\" : [%@ class] ", fieldsModel.keyObject,fieldsModel.convertString!=nil?fieldsModel.convertString:@"NSString"];
                }
                //                NSString* convertStr = [NSString stringWithFormat:@"-(NSDictionary*)objectClassInArray{  \r\n       return @{ @\"%@\" : [%@ class] }; \r\n}\r\n", fieldsModel.keyObject, fieldsModel.convertString];
                //                pointMFileStr = [pointMFileStr stringByAppendingString:convertStr];
            }
            else {
                if (fieldsModel.convertString) {
                    fileStr = [NSString stringWithFormat:@"@property (strong,nonatomic) %@ *%@;\r\n",fieldsModel.convertString, fieldsModel.keyObject];
                }else{
                    fileStr = [NSString stringWithFormat:@"@property (strong,nonatomic) NSString *%@;\r\n", fieldsModel.keyObject];
                }
            }
            
            pointHFileStr = [pointHFileStr stringByAppendingString:fileStr];
        }
        if (convertString) {
            convertString=[convertString stringByAppendingString:@"}; \r\n}\r\n"];
            pointMFileStr = [pointMFileStr stringByAppendingString:convertString];
        }
        
        NSLog(@"model.myClassName:%@", createFileModel.myClassName);
        pointHFileStr = [pointHFileStr stringByAppendingString:@"@end\r\n\r\n"];
        pointMFileStr = [pointMFileStr stringByAppendingString:@"@end\r\n\r\n"];
    }
    
    NSOpenPanel *panel = [NSOpenPanel openPanel];
    panel.canChooseDirectories = YES;
    panel.canChooseFiles = NO;
    [panel beginSheetModalForWindow:self.window completionHandler:^(NSInteger result) {
        if(result == 0) return ;
        NSString* path = [panel.URL path];
        [pointHFileStr writeToFile:[NSString stringWithFormat:@"%@/%@.h",path,className] atomically:NO encoding:NSUTF8StringEncoding error:nil];
        [pointMFileStr writeToFile:[NSString stringWithFormat:@"%@/%@.m",path,className] atomically:NO encoding:NSUTF8StringEncoding error:nil];
    }];
}

-(NSString*)stringToClassName:(NSString*)string{//字符串转换为类名，规则为第一个字母大写
    NSString* oneString=[[string substringWithRange:NSMakeRange(0, 1)] uppercaseString];
    NSString* fromOneString=[string substringFromIndex:1];
    string=[oneString stringByAppendingString:fromOneString];
    return string;
}

- (NSDictionary*)GetDictionaryWithJson:(NSString*)jsonStr
{
    return [jsonStr objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
}

- (void)applicationWillTerminate:(NSNotification*)aNotification
{
    // Insert code here to tear down your application
}

@end
