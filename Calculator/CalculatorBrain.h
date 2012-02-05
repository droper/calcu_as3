//
//  CalculatorBrain.h
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (void)popStack;
- (void)pushVariable:(NSString *)variable;
- (double)performOperation:(NSString *)operation
    usingVariableValues:(NSDictionary *)variablesDictionary;
- (double)performVariable:(NSString *)variable
      usingVariableValues:(NSDictionary *)variablesDictionary;
- (double)executeProgram:(NSDictionary *)variablesDictionary;


- (void)emptyStack;
- (NSString *)stackDescription;
- (NSString *)variablesDescription:(NSDictionary *)variablesDictionary;

@property (nonatomic, readonly) id program;


+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program
    usingVariableValues:(NSDictionary *)variableValues;
+ (NSSet *)variablesUsedInProgram:(id)program
        usingVariableValues:(NSDictionary *)variableValues;
;



@end
