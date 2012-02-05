//
//  CalculatorViewController.m
//  Calculator
//
//  Created by soulse on 1/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController()

- (void)appendStackDisplay:(NSString *)text;

@property (nonatomic) BOOL thereIsAFloatPoint;
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *dictionaryOfVariables;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize stackDisplay;
@synthesize variablesDisplay;
@synthesize thereIsAFloatPoint;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize dictionaryOfVariables = _dictionaryOfVariables;
@synthesize brain = _brain;


- (NSDictionary *) dictionaryOfVariables
{
    if (!_dictionaryOfVariables) {
        NSLog(@"inicializo");
        _dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSNumber numberWithDouble:(double)3], @"x", 
                                 [NSNumber numberWithDouble:(double)2], @"y", 
                                 [NSNumber numberWithDouble:(double)1], @"z", nil];
        }
    return _dictionaryOfVariables;
}

- (CalculatorBrain *)brain
{
    if (!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)updateUI
{
    // Actuializamos el display recalculando el stack
    double result = [self.brain executeProgram:self.dictionaryOfVariables];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //Actualizamos la pantalla donde se muestra el stack
    [self appendStackDisplay:[self.brain stackDescription]];
    
    // Se muestran las variables en variablesDisplay
    self.variablesDisplay.text = [self.brain variablesDescription:self.dictionaryOfVariables];
}

- (void)appendStackDisplay:(NSString *)text
{
    //self.stackDisplay.text = [self.stackDisplay.text 
    //                        stringByAppendingString:[@" " stringByAppendingString:text]];
    self.stackDisplay.text = text;

}
    
- (IBAction)clearPresed:(id)sender {
    self.thereIsAFloatPoint = NO;
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
    self.display.text = @"0";    
    self.stackDisplay.text = @"";
    [self.brain emptyStack];
}

- (IBAction)digitPressed:(UIButton *)sender 
{
    NSString *digit = [sender currentTitle];
    
    //empece aqui
    NSRange range = [digit rangeOfString:@"."];
    
    if (range.location != NSNotFound) {
        if (self.thereIsAFloatPoint) {
            return;	
        }
        else {
            self.thereIsAFloatPoint = YES	;
        
        }
    }
    //termine aqui
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed 
{    
    [self.brain pushOperand:[self.display.text doubleValue]];
    
    //[self appendStackDisplay:self.display.text];
    [self appendStackDisplay:[self.brain stackDescription]];
    
    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thereIsAFloatPoint = NO;
}

- (IBAction)operarionPressed:(id)sender 
{
    
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed];
    }
    else {
        //[self appendStackDisplay:self.display.text];
    }
    
    NSString *operation = [sender currentTitle];
    
    double result = [self.brain performOperation:operation usingVariableValues:self.dictionaryOfVariables];
    
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    //[self appendStackDisplay:operation];
    [self appendStackDisplay:[self.brain stackDescription]];

}

- (IBAction)variablePressed:(UIButton *)sender {
   
    NSString *variable = [sender currentTitle];
    
    self.display.text = variable;
    
    //[self.brain pushOperand:[[self.dictionaryOfVariables objectForKey:variable] doubleValue]];
    [self.brain pushVariable:variable];
    
    
    //[self.brain performVariable:variable usingVariableValues:self.dictionaryOfVariables];
    

    NSLog(@"este es una variable %@",variable);
    
    [self appendStackDisplay:[self.brain stackDescription]];
    

    self.userIsInTheMiddleOfEnteringANumber = NO;
    self.thereIsAFloatPoint = NO;
    
    // Se muestran las variables en variablesDisplay
    self.variablesDisplay.text = [self.brain variablesDescription:self.dictionaryOfVariables];
}

- (IBAction)testPressed:(UIButton *)sender {
    
    NSString *caption = [sender currentTitle];
    
    if ([caption isEqualToString:@"Test 1"]){
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSNumber numberWithDouble:(double)5], @"x", 
                                  [NSNumber numberWithDouble:(double)4], @"y", 
                                  [NSNumber numberWithDouble:(double)3], @"z", nil];

    } else if ([caption isEqualToString:@"Test 2"]){
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithDouble:(double)-5], @"x", 
                                      [NSNumber numberWithDouble:(double)-8], @"y", 
                                      [NSNumber numberWithDouble:(double)0], @"z", nil];
        
    } else {
        self.dictionaryOfVariables = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      nil, @"x", 
                                      nil, @"y", 
                                      nil, @"z", nil];
        
    }
    
    // Se muestran las variables en variablesDisplay
    [self updateUI];

}


- (IBAction)undoPressed:(id)sender {
    // Si el usuario esta ingresando un numero borra los numeros hasta que 
    // termina y ejecuta el programa de nuevo
    if (self.userIsInTheMiddleOfEnteringANumber){
        if ([self.display.text length] > 0){
            self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        }else {
            double result = [self.brain executeProgram:self.dictionaryOfVariables];
            self.display.text = [NSString stringWithFormat:@"%g", result];
        }
    } else {
        //Si el usuario no esta ingresando numeros, elimina el ultimo item del stack
        [self.brain popStack];
        [self updateUI];
    }
}


- (void)viewDidUnload {
    [self setStackDisplay:nil];
    [self setVariablesDisplay:nil];
    [self setVariablesDisplay:nil];
    [super viewDidUnload];
}
@end