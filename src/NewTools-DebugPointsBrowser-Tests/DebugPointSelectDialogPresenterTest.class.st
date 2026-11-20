"
I test `DebugPointSelectDialogPresenter` at the presenter level, without opening it.

## Responsibility:

- Check that its code and variable target presenters are created through the dialog, so that they belong to it and use its application.
- Check that the code is read only and that the variable target presenter uses its dialog layout.

## Collaborators: 

- `DebugPointSelectDialogPresenter`: created on a fresh `SpApplication`.

## Internal Representation

- `dialog`: the presenter under test.
"
Class {
	#name : 'DebugPointSelectDialogPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'dialog'
	],
	#category : 'NewTools-DebugPointsBrowser-Tests',
	#package : 'NewTools-DebugPointsBrowser-Tests'
}

{ #category : 'running' }
DebugPointSelectDialogPresenterTest >> setUp [

	super setUp.
	dialog := DebugPointSelectDialogPresenter newApplication: SpApplication new
]

{ #category : 'tests' }
DebugPointSelectDialogPresenterTest >> testCodeIsNotEditable [

	self deny: dialog code isEditable
]

{ #category : 'tests' }
DebugPointSelectDialogPresenterTest >> testCodeIsOwnedByTheDialog [

	self assert: dialog code owner identicalTo: dialog
]

{ #category : 'tests' }
DebugPointSelectDialogPresenterTest >> testVariableTargetPresenterIsOwnedByTheDialog [

	self assert: dialog variableTargetPresenter owner identicalTo: dialog
]

{ #category : 'tests' }
DebugPointSelectDialogPresenterTest >> testVariableTargetPresenterUsesTheDialogLayout [

	| target |
	target := dialog variableTargetPresenter.
	self assert: target layout presenters size equals: target dialogLayout presenters size
]
