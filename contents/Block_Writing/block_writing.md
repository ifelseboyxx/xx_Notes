# Objective-C 中 Block 的各种定义写法

## As a local variable：

```objc
<#ReturnType#> (^<#BlockName#>)(<#ParameterType#>) = ^<#ReturnType#>(<#Parameters#>) {<#...#>};
```

Example：

```objc
// type 1
void (^MyBlock)() = ^{
  // ...      
};  
MyBlock();
```
```objc
// type 2
void (^MyBlock)(NSString *name,int age) = ^(NSString *name,int age){
    NSLog(@"%@ - %d",name,age);
};
MyBlock(@"Atom",18);
```
```objc
// type 3
NSString * (^MyBlock)(NSString *name) = ^NSString*(NSString *name){
    return name;
};

NSLog(@"%@",MyBlock(@"Atom"));
```

## As a property

```objc
@property (nonatomic, copy) <#ReturnType#> (^<#BlockName#>)(<#ParameterType#>);
```

Example：

```objc
// type 1
@property (nonatomic, copy) void (^myBlock)();

self.myBlock = ^{
    // ...
};

self.myBlock();
```

```objc
// type 2
@property (nonatomic, copy) void (^myBlock)(NSString *name,int age);

self.myBlock = ^(NSString *name, int age) {
    NSLog(@"%@ - %d",name,age);
};

self.myBlock(@"Atom", 18);
```

```objc
// type 3
@property (nonatomic, copy) NSString * (^myBlock)(NSString *name);
```

## As a method parameter:

```objc
- (void)someMethodThatTakesABlock:(<#ReturnType#> (^)(<#ParameterType#>))<#blockName#>;
```

Example：

```objc
// type 1
- (void)someMethodThatTakesABlock:(void (^)())myBlock {
    // ...
}
```

```objc
// type 2
- (NSString * (^)(int))name {
    return ^(int age){
        return @"Atom";
    };
}

NSLog(@"%@",self.name(18));
```

## As a typedef

```objc
typedef <#ReturnType#> (^<#TypedefName#>)(<#ParameterType#>);
```

Example：

```objc
typedef void (^MyBlock)();

@property (nonatomic, copy) MyBlock myBlock;

MyBlock block = ^{
        
};
```

```objc
typedef void (^MyBlock)(NSString *name);

@property (nonatomic, copy) MyBlock myBlock;

MyBlock block = ^(NSString *name){
        
};
```

