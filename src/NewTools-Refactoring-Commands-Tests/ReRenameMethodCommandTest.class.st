Class {
	#name : 'ReRenameMethodCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameMethodCommandTest >> testRenameMethodCommandSuccess [

	| driver command context method dialog |
	method := RBClassDataForRefactoringTest >> #caller1.
	context := StCommandContextMock new
		           selectedNode: (OCMessageNode new
				            selector: (OCSelectorNode new
						             value: #'called:on1:';
						             yourself);
				            arguments: {
						            (OCVariableNode new
							             name: 'anObject';
							             yourself).
						            (OCVariableNode new
							             name: 'anArg';
							             yourself) };
				            yourself);
		           behavior: RBClassDataForRefactoringTest;
		           yourself.

	command := StRenameMethodCommand new.
	command context: context.
	driver := command prepareDriver.

	dialog := MockObject new.
	dialog on: #cancelled respond: false.
	dialog on: #methodName respond: (RBMethodName selector: #renamedCalled:on1: arguments: #( 'anObject' 'anArg' )).
	driver requestDialog: dialog.

	driver
		forTesting: true;
		runRefactoring.
	self assert: driver changes changes size equals: 6
]
