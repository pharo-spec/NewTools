Class {
	#name : #StObjectPrinterTest,
	#superclass : #TestCase,
	#category : #'NewTools-Inspector-Tests'
}

{ #category : #assertions }
StObjectPrinterTest >> assertIsError: aCollection expectedMessage: aMessage [
	
	self assert: aCollection asString equals: 'Error printing: ', aMessage.
	self assert: aCollection runs anyOne first color equals: Color red
]

{ #category : #tests }
StObjectPrinterTest >> testPrintDoesNotUnderstand [

	| printedValue |
	printedValue := StObjectPrinter asTruncatedTextFrom: StObjectWithPrintDoesNotUnderstand new.
	
	self assertIsError: printedValue expectedMessage: 'StObjectWithPrintDoesNotUnderstand>> #iShouldNotUnderstandThis'
]

{ #category : #tests }
StObjectPrinterTest >> testPrintError [

	| printedValue |
	printedValue := StObjectPrinter asTruncatedTextFrom: StObjectWithPrintError new.
	
	self assertIsError: printedValue expectedMessage: 'Some error message'
]

{ #category : #tests }
StObjectPrinterTest >> testPrintHalt [

	| printedValue |
	printedValue := StObjectPrinter asTruncatedTextFrom: StObjectWithPrintHalt new.
	
	self assertIsError: printedValue expectedMessage: 'Halt'
]
