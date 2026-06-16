Class {
	#name : 'ReMoveTempDefinitionCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReMoveTempDefinitionCommandTest >> testRenameArgOrTempCommandSuccess [

	| driver command context method |
	method := RBClassDataForRefactoringTest >> #moveDefinition .
	command := StMoveTempDefinitionCommand new.
	context := StCommandContextMock new
		           selectedMethod: method;
		           selectedNode: (OCVariableNode new
				            name: 'temp';
				            start: 19;
				            yourself).
	command context: context.
	driver := command prepareDriver.

	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 1
]
