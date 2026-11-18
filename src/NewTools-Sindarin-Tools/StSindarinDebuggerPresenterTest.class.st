"
I test `StSindarinDebuggerPresenter` at the presenter level, without opening it.

## Responsibility:

- Check that the raw inspection presenter is created through the presenter, so that it belongs to it and uses its application.
- Check that it shows the node executed by the selected context of the stack.

## Collaborators: 

- `SindarinDebugger`: the model, created in `setUp` on a small block and terminated in `tearDown`, so that no process stays behind.
- `StPharoApplication`: the application of the presenter; its toolbar needs `toolbarDisplayMode`, which `SpApplication` does not answer.

## Internal Representation

- `sindarinDebugger`: the model.
- `presenter`: the presenter under test.
"
Class {
	#name : 'StSindarinDebuggerPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'sindarinDebugger',
		'presenter'
	],
	#category : 'NewTools-Sindarin-Tools-Tests',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Tests'
}

{ #category : 'running' }
StSindarinDebuggerPresenterTest >> setUp [

	super setUp.
	sindarinDebugger := SindarinDebugger debug: [ 3 + 4 ].
	presenter := StSindarinDebuggerPresenter newApplication: StPharoApplication current model: sindarinDebugger
]

{ #category : 'running' }
StSindarinDebuggerPresenterTest >> tearDown [

	sindarinDebugger terminate.
	super tearDown
]

{ #category : 'tests' }
StSindarinDebuggerPresenterTest >> testInspectorIsOwnedByThePresenter [

	self assert: presenter rawInspectionPresenter owner identicalTo: presenter
]

{ #category : 'tests' }
StSindarinDebuggerPresenterTest >> testInspectorShowsTheNodeOfTheSelectedContext [

	self assert: presenter rawInspectionPresenter model identicalTo: sindarinDebugger stack first sourceNodeExecuted
]
