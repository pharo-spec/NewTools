Class {
	#name : 'RePushUpVariableCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
RePushUpVariableCommandTest >> testPushUpVariableToClassSideCommandSuccess [

	| driver command context method |
	command := StPushUpVariableCommand new.
	method := RBTransformationRuleTestData >> #isEmpty.
	context := StCommandContextMock new
		           variable: (OCVariableNode new name: 'builder' ; yourself);
		           behavior: RBTransformationRuleTestData.
	command context: context.
	driver := command prepareDriver.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 2
]
