Class {
	#name : 'ReMoveInstanceVariableToClassSideTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReMoveInstanceVariableToClassSideTest >> testMoveInstanceVariableToClassSideCommandSuccess [

	| driver command context |
	command := StMoveInstanceVariableToClassSideCommand new.
	context := StCommandContextMock new variable: (InstanceVariableSlot new named: #builder; owningClass: RBTransformationRuleTestData; yourself).
	context selectedMethod: context.
	command context: context.
	driver := command prepareDriver.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 2
]
