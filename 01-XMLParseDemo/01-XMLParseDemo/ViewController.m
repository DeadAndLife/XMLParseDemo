//
//  ViewController.m
//  01-XMLParseDemo
//
//  Created by qingyun on 16/6/25.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "ViewController.h"
#import "QYBook.h"
#import "GDataXMLNode.h"


@interface ViewController ()<NSXMLParserDelegate>

@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)QYBook *book;
@property(nonatomic,strong)NSString *content;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)SaxParse:(id)sender {
  //1.创建解析对象
    //1.1获取xml的URL
    NSURL *xmlUrl=[[NSBundle mainBundle] URLForResource:@"bookstore" withExtension:@"xml"];
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithContentsOfURL:xmlUrl];

  //2.设置Delegate
    xmlParser.delegate=self;

  //3.开始解析
    [xmlParser parse];

}

#pragma mark xmlParserDelegate
//xml文档开始解析时调用,在这里要声明一个数组,该方法只会调用一次
-(void)parserDidStartDocument:(NSXMLParser *)parser{
    _dataArr=[NSMutableArray array];
}
//xml文档解析结束的时候调用,该方法只会调用一次,使用数据
-(void)parserDidEndDocument:(NSXMLParser *)parser{
    NSLog(@"=========%@",_dataArr);
}
//当发现开始标签时候调用,创建mode,属性值赋值给mode属性
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if([elementName isEqualToString:@"book"]){
      //初始化mode
        _book=[QYBook new];
        //把属性的值赋值给mode的category
        [_book setValuesForKeysWithDictionary:attributeDict];
    }else if ([elementName isEqualToString:@"title"]){
       //把title的属性 赋值给mode的lang
        [_book setValuesForKeysWithDictionary:attributeDict];
    }
}
//发现文本内容时调用
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //赋值给全局变量
    _content=string;
}

//发现结束标签时调用,将conten赋值给mode相应的属性
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    /*if ([elementName isEqualToString:@"title"]) {
        _book.title=_content;
    }else if([elementName isEqualToString:@"author"]){
        _book.author=_content;

    }*/
    if([elementName isEqualToString:@"book"]){
        [_dataArr addObject:_book];
    }else if ([elementName isEqualToString:@"bookstore"]){
    }else{
    //kvc进行赋值
        [_book setValue:_content forKeyPath:elementName];
    }

}

//xml文档解析错误时调用
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError{
    NSLog(@"=======%@",parseError);

}
//Dom解析
- (IBAction)DomPar:(id)sender {
   //创建数组
    _dataArr=[NSMutableArray array];
   //1.创建GDataXMLDocument对象
    NSString *xmlPath=[[NSBundle mainBundle] pathForResource:@"bookstore" ofType:@"xml"];
    //xmlPath====>Nsdata
    NSData *xmlData=[NSData dataWithContentsOfFile:xmlPath];
    GDataXMLDocument *xmlDoc=[[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    //2.获取根元素
      GDataXMLElement *rootElement=[xmlDoc rootElement];
    //3.取出rootElement的子元素
       NSArray *booKarr=[rootElement elementsForName:@"book"];
    //4.取出每个XMLElement子元素
    for (GDataXMLElement *element in booKarr) {
        //1.初始化mode
        QYBook *book=[QYBook new];
        //2.取出属性值 category
        GDataXMLNode *nodeCatory=[element attributeForName:@"category"];
        book.Kcategory=[nodeCatory stringValue];
        //3.取出titile
         GDataXMLElement *titleElememt=[element elementsForName:@"title"][0];
         book.lang=[[titleElememt attributeForName:@"lang"] stringValue];
         book.title=[titleElememt stringValue];
        //4.取出author子元素
        GDataXMLElement *authorElement=[element elementsForName:@"author"][0];
        book.author=[authorElement stringValue];
        //5取year子元素
        book.year=[[element elementsForName:@"year"][0] stringValue];
        //6.取price子元素
        book.price=[[element elementsForName:@"price"][0] stringValue];
        //存储在数组里
        [_dataArr addObject:book];
    }
  
    NSLog(@"======%@",_dataArr);
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
