ALModelManager
==============


## Introduction

This is a Observation Object model for using KVO.

Model is so easy creation from JSON Object.


## Waring

be carefully Using This.

KVO is not a Simple and hard for Debuging.


## Usage

#### FIRST,

Define to Model from Super class. (model is SubClass for SuperModel)


###### Like.h

create model like this. 

    #import "SuperModel.h"
    @interface Like : SuperModel
    @property (strong, nonatomic) NSString *movie;
    @property (strong, nonatomic) NSString *sports;
    @property (strong, nonatomic) NSString *something;
    @end

and make instance of model using '- (id)initWithDictionary' method not '- (id)init'

more sample & Information : User.h/User.m

#### SECOND, 

imort ALModelManager and declared DataModel`s (Property)

###### ALModelManager.h

    @interface ALModelManager : NSObject
    // Here!
    @property (strong, nonatomic) Like *likes;
    ....
    + (ALModelManager *)sharedInstance;
    + (void)releaseInstance;
    @end


#### THIRD,  

add Observation and Remove Observation 

###### Viewcontroller.m file

    - (id)initWithCoder:(NSCoder *)aDecoder
    {
      self = [super initWithCoder:aDecoder];
      if (self) {
          _alt = [[ALTransaction alloc] initWithTarget:self
                                       successSelector:@selector(recieveSuccess:)
                                       failureSelector:@selector(recieveFailure:)];
      }
      return self;
    }
    - (void)recieveSuccess:(id)result
    {
    }
    - (void)recieveFailure:(id)result
    {
    }

#### LAST,  

don`t forget Remove all KVO.

###### AppDelegate.m

    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        [self removeAllObservations];
        [self removeAllObservers];
    }

#### that`s it!



## Detail Info


## Bugs / Feature Requests

Think you’ve found a bug? 

Please open a case in issue page.


## License

GNU GPL V2 - Read a Lincense file.


## References

