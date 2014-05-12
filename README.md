# TKDynamicRACTableView
  
![Mou icon](http://images.cnblogs.com/cnblogs_com/tinkl/253133/o_2445FE59-4074-4301-B423-A362740C3FBC.png)

image link <http://images.cnblogs.com/cnblogs_com/tinkl/253133/o_2445FE59-4074-4301-B423-A362740C3FBC.png>

## Requirements

**tinkl**, is some of my experiences,hope that can help *ios  developers*.make the word be better and easier

**TKDynamicRACTableView** uses ARC and requires iOS 7.0+.

It probably will work with iOS 6, I have not tried,but  it is not using any iOS7 specific APIs.
 
####  Installation

> just download zip file… &gt; and you can use it .

#### Links and Email

if you have some Question to ask me, you can contact email <nicolastinkl@gmail.com> link.

or see blogs <http://www.cnblogs.com/tinkl/>

[id]: http://mouapp.com "Markdown editor on Mac OS X"



#### Some Code

Just see this:

NetWork with Get request:

```
- (RACSignal *)fetchPostsWithURL:(NSString *)urlString
{
    return [[self rac_GET:urlString parameters:nil] map:^id(NSDictionary *data) {
        return [[((NSArray *)data[@"moments"]).rac_sequence map:^id(id value) {
            return [[TKPost alloc] initWithDictionary:value error:nil];
        }] array];
    }];
}
```

Post request:

```
- (RACSignal *)fetchPostsWithPost:(NSMutableDictionary * ) params
{
    UALog(@"send json:  %@",params);
     /*     return [[self rac_GET:@"http://api.huaban.com/fm/wallpaper/tags" parameters:nil] map:^id(NSArray *tags) {
     return [[tags.rac_sequence map:^id(id value) {
     return value;
     }] array];
     }]; // test ok
      */
    return [[[[self rac_POST:@"http://api.petta.mobi/api.do" parameters:params] map:^id(id posts) {
        /*!
         *  reponse code 200
         */
        UALogFull(@" reponse code 200 ");
        if (posts) {
            UALog(@"response message : %@",posts[@"response"][@"response_msg"]);
        }
        if (posts && [posts[@"response"][@"response_code"] intValue] == 0) {
            NSArray * moments = posts[@"moments"];
            UALog(@"moments %lu",(unsigned long)moments.count);
            return  [[moments.rac_sequence map:^id(id value) {                
                TKPost * post = [[TKPost alloc] initWithDictionary:value error:nil];
                post.posttype = @"singleimage";
                return post;
            }] array];
        }else{
            /*!
             *  error  maybe network error
             */
            return @[];
        }
    }]  catch:^RACSignal *(NSError *error) {
        return [RACSignal error:error];
    }] replayLazily];
}
```


Data init :

```
  @weakify(self);
    [RACObserve(self, viewModel.post) subscribeNext:^(NSArray * posts) {
        @strongify(self);
        if (posts.count > 0) {
                    
            self.tableViewDataSource.posts = [posts copy];
            
            [self.tableView reloadData];
        }else{
            UALog(@"NO data");
        }
    }];
```

####  Features

------------------------------------

1. Gives Xcode's autocompletion to be able to filter like Open Quickly does2. Ordered  
3. Supports Xcode 5.0, 5.0.1, 5.0.2 and 5.1
4. Supports Xcode's learning and context-aware priority system
5. Uses Grand Central Dispatch to parallelise matching
6. Productivity++ 

#### Notes

--------

* Only tested with Xcode 5 on 10.8.5
* Hasn't been tested with other plugins 



#### Changelog
1.0.0 - 2014/05/12
-----------------
1. Add ReactiveViewModel ,ReactiveCocoa , Objection.....
2. Add (MVVM) .
![Mou icon](https://f.cloud.github.com/assets/432536/867984/291ed380-f760-11e2-9106-d3158320af39.png)
3. Add JsonModel
4. add UIView-AutoLayout


1.0.0 - 2014/02/04
----------

Initial release

