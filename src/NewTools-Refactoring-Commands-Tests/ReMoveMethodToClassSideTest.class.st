Class {
	#name : 'ReMoveMethodToClassSideTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReMoveMethodToClassSideTest >> testMoveInstanceVariableToClassSideCommandSuccess [

	| driver command context |
	command := StMoveMethodToClassSideCommand new.
	context := StCommandContextMock new selectedMethod: RBTransformationRuleTestData >> #isEmpty.

	command context: context.
	driver := command prepareDriver.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 6
]
