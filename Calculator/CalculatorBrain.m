//
//  CalculatorBrain.m
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
#define PI 3.1416


@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;

//@property (nonatomic, strong) 	
@end


@implementation CalculatorBrain

//@synthesize dictionaryOfVariables= _dictionaryOfVariables;
@synthesize operandStack = _operandStack;


- (NSMutableArray *)operandStack
{
    if (!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (id)program
{
    return [self.operandStack copy];
}


+ (BOOL)isOperation:(NSString *) operation
{
    NSSet *operations;
    operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"pi", nil];
    
    if ([operations containsObject:operation])
    {
        return TRUE;
    } else return FALSE;
}

+ (BOOL)isFunction:(NSString *) function
{
    NSSet *functions;
    functions = [NSSet setWithObjects:@"sqrt",@"cos",@"sin", nil];
    
    if ([functions containsObject:function])
    {
        return TRUE;
    } else return FALSE;
}

+ (BOOL)isNumber:(NSString *) operation
{
    NSSet *operations;
    operations = [NSSet setWithObjects:@"+",@"-",@"*",@"/",@"sqrt",@"cos",@"sin", nil];
    
    if (![operations containsObject:operation])
    {
        return TRUE;
    } else return FALSE;
}

+ (NSString *)descriptionOfProgram:(id)program	
{
    BOOL oper = NO;    // Variable booleana que indica si es el primer o segundo operando
    NSMutableArray *stack;
    NSString *res=@"";
    NSMutableArray *temp;
    temp = [[NSMutableArray alloc] init];
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    /*for (int i=0;i<[stack count];i++){
        if ([self isNumber:[stack objectAtIndex:i]]){
            if (![[stack objectAtIndex:i] respondsToSelector:@selector(stringValue)]){
                [stack removeObjectAtIndex:i+1];
            }
        }
    }*/
    
    
    while ([stack count] > 0){
        NSLog(@"Entrando a loop");
        NSLog(@"Valor de last object: %@",[stack lastObject]);
        
        if ([self isOperation:stack.lastObject]){
            [temp addObject:[stack lastObject]];
            [stack removeLastObject];
            oper = YES; // operando 2

        } else if ([self isNumber:stack.lastObject]){
            if (oper == YES) {	
                if ([[stack lastObject] respondsToSelector:@selector(stringValue)]){
                    res = [NSString stringWithFormat:@"%@)%@", [[stack lastObject] stringValue], res];
                } else {
                    res = [NSString stringWithFormat:@"%@)%@", [stack lastObject], res];
                }

            } else {
                if ([[stack lastObject] respondsToSelector:@selector(stringValue)]){
                    res = [NSString stringWithFormat:@"(%@%@", [[stack lastObject] stringValue], res];
                } else {
                    res = [NSString stringWithFormat:@"(%@%@", [stack lastObject], res];
                }

            }
            [stack removeLastObject];
            // Si el elemento en temporal es operador lo agregamos al resultado

            while ([temp lastObject] == @"(") {
                [temp removeLastObject];
                res = [NSString stringWithFormat:@"(%@", res];
            }
            
            if ([self isOperation:[temp lastObject]]){
                res = [NSString stringWithFormat:@"%@	%@", [temp lastObject], res];
                [temp removeLastObject];
            
            // falta arreglar function
            } else if ([self isFunction:[temp lastObject]]){
                res = [NSString stringWithFormat:@"%@(%@", [temp lastObject], res];
                [temp removeLastObject];
                while ([temp lastObject] == @"(") {
                    [temp removeLastObject];
                    res = [NSString stringWithFormat:@"(%@", res];
                }
            } 
            
            if ([self isOperation:stack.lastObject] && oper == YES) {
                //res = [NSString stringWithFormat:@")%@",res];
                //[temp addObject:@"("];
            } 

            oper = NO;
            
        // Si son funciones las agregamos
        } else if ([self isFunction:stack.lastObject]){
            //res = [res stringByAppendingString:@")"];
            res = [NSString stringWithFormat:@")%@", res];
            [temp addObject:[stack lastObject]];
            [stack removeLastObject];            
            
        }
    }
    return res;
}

- (NSString *)stackDescription
{
    return [[self class] descriptionOfProgram:self.operandStack];
}

- (void)pushOperand:(double)operand
{
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)popStack
{
    [self.operandStack removeLastObject];
}

- (void)pushVariable:(NSString *)variable
{
    [self.operandStack addObject:variable];
}

- (void)emptyStack
{
    [self.operandStack removeAllObjects];
}

- (double)performOperation:(NSString *)operation
    usingVariableValues:(NSDictionary *)variablesDictionary
{

    [self.operandStack addObject:operation];
    return [[self class] runProgram:self.program usingVariableValues:variablesDictionary];    
}

- (double)executeProgram:(NSDictionary *)variablesDictionary
{
    return [[self class] runProgram:self.program usingVariableValues:variablesDictionary];    
}

- (double)performVariable:(NSString *)variable
      usingVariableValues:(NSDictionary *)variablesDictionary
{
 
    NSLog(@"Perform last object: %@",variable);

    return [[self class] runProgram:self.program usingVariableValues:variablesDictionary];    
}

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    //test
    double result = 0;
    NSLog(@"Valor de variable?: %@",[stack lastObject]);
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        NSLog(@"Entre a nsnumber");        
        result = [topOfStack doubleValue];
        NSLog(@"El result es: %f",result);
    }
    else if ([topOfStack isKindOfClass:[NSString class]])
    {
        NSString *operation = topOfStack;
        if ([operation isEqualToString:@"+"]) {
            result = [self popOperandOffProgramStack:stack] +
            [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]) {
            result = [self popOperandOffProgramStack:stack] *
            [self popOperandOffProgramStack:stack];
        } else if ([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack] / divisor;
        } else if ([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([operation isEqualToString:@"pi"]) {
            result = [self popOperandOffProgramStack:stack];
            [stack addObject:[NSNumber numberWithDouble:result]];
            [stack addObject:[NSNumber numberWithDouble:PI]];
        }    
    }
    
    return result;
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}

+ (double)runProgram:(id)program
    usingVariableValues:(NSDictionary *)variableValues
{
    NSLog(@"Entre a usingVariables");
    
    NSMutableArray *stack;
    
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    
    //Iteramos la pila por su indice
    for (int i=0;i<[stack count];i++){
        //Si el elemento de la pila es una llave del diccionario de variables
        //reemplazamos ese elemento por su valor en el diccionario de variables
        if ([variableValues objectForKey:[stack objectAtIndex:i]]){
            [stack replaceObjectAtIndex:i withObject:(NSNumber *)[variableValues objectForKey:[stack objectAtIndex:i]]];
            NSLog(@"ALG DE CAMBIO El valor de la variable es: %@",[stack objectAtIndex:i]);
        }
    }
    
    return [self popOperandOffProgramStack:stack];
}


+ (NSSet *)variablesUsedInProgram:(id)program
    usingVariableValues:(NSDictionary *)variableValues
{
    //iterar la pila 
    //comprobar si hay una variable en la pila
    //y agregarla a un set
    
    NSLog(@"Entre a variablesusedinprogram");
    
    NSMutableSet *variablesInProgram = [[NSMutableSet alloc] init];
    
    //iteramos la pila
    for (int i=0;i<[program count];i++){
        // Si el elemento de la pila es una llave del diccionario de variables
        // entonces es una variable y la agregamos al NSMutableSet
        if ([variableValues objectForKey:[program objectAtIndex:i]]){
            NSLog(@"Encontro variable en el stack %@", [program objectAtIndex:i]);            
            [variablesInProgram addObject:[program objectAtIndex:i]];
       }
    }
    
    NSLog(@"El numero de variables: %@", variablesInProgram);
    if ([variablesInProgram count] > 0){
        NSLog(@"Envie valores:");
        return variablesInProgram;
    }
    else {
         NSLog(@"Envie nil");
        return nil;
    }
}

- (NSString *)variablesDescription:(NSDictionary *)variablesDictionary
{
    NSSet *variables = [[NSSet alloc] init];
    NSString *variablesDescription = @"";
    
    variables = [[self class] variablesUsedInProgram:[self operandStack] usingVariableValues:variablesDictionary];
    
    for (id variable in variables){
        variablesDescription = [NSString stringWithFormat:@"%@ = %@ %@", variable, [variablesDictionary objectForKey:variable], variablesDescription];
    }
    
    return variablesDescription;
}

@end
