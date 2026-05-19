Class {
	#name : 'ReRenameVariableCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameVariableCommandTest >> testRenameVariableCommandSuccess [

	| driver command context method dialogMock |
	command := StRenameVariableCommand new.
	method := RBTransformationRuleTestData >> #isEmpty.
	context := StCommandContextMock new
		           name: 'builder';
		           behavior: RBTransformationRuleTestData.
	command context: context.
	driver := command prepareDriver.
	dialogMock := StRequestDialogMock new.
	dialogMock response: 'var'.
	driver requestDialog: dialogMock.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 1
]
