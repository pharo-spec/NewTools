Class {
	#name : 'ReRenameVariableCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameVariableCommandTest >> testRenameVariableCommandSuccess [

	| driver command context ast node method dialogMock |
	command := StRenameVariableCommand new.
	method := RBTransformationRuleTestData >> #isEmpty.
	ast := OpalCompiler new
		       class: method methodClass;
		       parse: method sourceCode.
	node := ast allChildren detect: [ :n | n isVariable and: [ n name = 'builder' ] ].
	context := StCommandContextMock new
		           name: node name;
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
