Class {
	#name : 'ReRenameClassCommandTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Refactoring-Commands-Tests',
	#package : 'NewTools-Refactoring-Commands-Tests'
}

{ #category : 'tests' }
ReRenameClassCommandTest >> testRenameClassCommandSuccess [

	| driver command context dialogMock changes rename |
	command := StRenameClassCommand new.
	context := StCommandContextMock new name: #ReClassToConvertTemporaryToInstanceVariable.
	command context: context.
	driver := command prepareDriver.
	dialogMock := StRequestDialogMock new.
	dialogMock response: 'NewClassNameForTest'.
	driver requestDialog: dialogMock.
	driver
		forTesting: true;
		runRefactoring.

	"The reference changes are nested in the rename change, which moves them to the new class name when it runs."
	changes := driver changes changes.
	self assert: changes size equals: 1.
	rename := changes first.
	self assert: rename oldName asSymbol equals: #ReClassToConvertTemporaryToInstanceVariable.
	self assert: rename newName asSymbol equals: #NewClassNameForTest.
	self denyEmpty: rename changes
]
