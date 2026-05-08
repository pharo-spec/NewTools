Class {
	#name : 'ReRenameMethodCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameMethodCommandTest >> testRenameMethodCommandSuccess [

	| driver command context node method ast dialog |
	method := RBClassDataForRefactoringTest >> #caller1.
	ast := OpalCompiler new parse: method sourceCode.
	node := ast allChildren detect: [ :n | n isMessage and: [ n selector = 'called:on1:' ] ].

	context := StCommandContextMock new
		           selectedNode: node;
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
	self assert: driver changes changes size equals: 5
]
