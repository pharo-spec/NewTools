Class {
	#name : 'ReInlineMethodCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReInlineMethodCommandTest >> testInlineMethodCommandSuccess [

	| driver command context |
	command := StInlineMethodCommand new.
	context := StCommandContextMock new
		           sourceInterval: (63 to: 78);
		           selector: #rewriteUsing:;
		           behavior: RBTransformationRuleTestData.
	context method: context.
	command context: context.
	driver := command prepareDriver.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 1
]
