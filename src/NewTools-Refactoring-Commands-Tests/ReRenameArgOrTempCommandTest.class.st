Class {
	#name : 'ReRenameArgOrTempCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameArgOrTempCommandTest >> testRenameArgOrTempCommandSuccess [

	| driver command context method dialogMock |
	
	method := ReClassToConvertTemporaryToInstanceVariable >> #doAction1.
	command := StRenameArgOrTempCommand new.
	context := StCommandContextMock new
		           method: method;
		           selectedNode: (OCVariableNode new
				            name: 'temp';
				            start: 15;
				            yourself).
	command context: context.
	driver := command prepareDriver.
	dialogMock := StRequestDialogMock new.
	dialogMock response: 'tmp2'.
	driver requestDialog: dialogMock.
	driver
		forTesting: true;
		runRefactoring.

	self assert: driver changes changes size equals: 1
]
