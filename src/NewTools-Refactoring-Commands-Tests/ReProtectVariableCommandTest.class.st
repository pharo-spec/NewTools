Class {
	#name : 'ReProtectVariableCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReProtectVariableCommandTest >> testPushUpVariableToClassSideCommandSuccess [

	| driver command context method |
	command := StProtectVariableCommand new.
	method := RBBasicLintRuleTestData >> #result.
	context := StCommandContextMock new
		           variable: (OCVariableNode new
				            name: 'result';
				            yourself);
		           behavior: RBBasicLintRuleTestData.
	command context: context.
	driver := command prepareDriver.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 1
]
