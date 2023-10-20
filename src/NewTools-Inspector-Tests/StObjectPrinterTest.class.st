Class {
	#name : 'StObjectPrinterTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Inspector-Tests',
	#package : 'NewTools-Inspector-Tests'
}

{ #category : 'assertions' }
StObjectPrinterTest >> assertIsError: aCollection expectedMessage: aMessage [
	
	self assert: aCollection asString equals: 'Error printing: ', aMessage.
]

{ #category : 'tests' }
StObjectPrinterTest >> testPrintDoesNotUnderstand [

	| printedValue selector error |
	selector := #iShouldNotUnderstandThis.
	
	error := MessageNotUnderstood new message: ((Message selector: selector) lookupClass: StObjectWithPrintDoesNotUnderstand).
	printedValue := StObjectPrinter asTruncatedTextFrom: (StObjectWithPrintDoesNotUnderstand withMissingMessageSelector: selector).
	
	self assertIsError: printedValue expectedMessage: error messageText
]

{ #category : 'tests' }
StObjectPrinterTest >> testPrintError [

	| printedValue |
	printedValue := StObjectPrinter asTruncatedTextFrom: StObjectWithPrintError new.
	
	self assertIsError: printedValue expectedMessage: 'Some error message'
]

{ #category : 'tests' }
StObjectPrinterTest >> testPrintHalt [

	| printedValue |
	printedValue := StObjectPrinter asTruncatedTextFrom: StObjectWithPrintHalt new.
	
	self assertIsError: printedValue expectedMessage: 'Halt'
]
