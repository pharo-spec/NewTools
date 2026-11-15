"
I test `DebugPointEditorPresenter` at the presenter level, without opening it.

## Responsibility:

- Check the layout shown without debug point: a label asking to select one, created once by the editor and kept when the editor is updated.
- Check that the presenters shown for a debug point, those of its behaviors (`DebugPointBehavior class>>#uiElement`) and the one of its kind (`BreakDebugPoint>>#presentIn:`, `WatchDebugPoint>>#presentIn:`), are created through the editor, so that they belong to it and use its application.

## Collaborators: 

- `DebugPointEditorPresenter`: created on a fresh `SpApplication`, without debug point; the tests that show one use a `BreakDebugPoint` or `WatchDebugPoint` that is never installed, so no method is changed.

## Internal Representation

- `editor`: the presenter under test.
"
Class {
	#name : 'DebugPointEditorPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'editor'
	],
	#category : 'NewTools-DebugPointsBrowser-Tests',
	#package : 'NewTools-DebugPointsBrowser-Tests'
}

{ #category : 'helpers' }
DebugPointEditorPresenterTest >> presentersNotOwnedByTheEditor [
	"Answer the class names of the presenters of the editor layout that the editor does not own."

	^ editor layout presenters reject: [ :each | each owner == editor ] thenCollect: [ :each | each class name ]
]

{ #category : 'running' }
DebugPointEditorPresenterTest >> setUp [

	super setUp.
	editor := DebugPointEditorPresenter newApplication: SpApplication new
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testBehaviorPresentersAreOwnedByTheEditor [
	"The debug point is not installed, so the test changes no method."

	editor debugPoint: BreakDebugPoint new.
	self assertEmpty: (self presentersNotOwnedByTheEditor reject: [ :each | each = #BreakPresenter ])
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testBreakPresenterIsOwnedByTheEditor [

	editor debugPoint: BreakDebugPoint new.
	self assert: (editor layout presenters detect: [ :each | each class == BreakPresenter ]) owner identicalTo: editor
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testNoSelectionLabelAsksToSelectADebugPoint [

	self assert: editor layout presenters first label equals: 'Select a Debug Point'
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testNoSelectionLabelIsKeptWhenUpdatingWithoutDebugPoint [

	| label |
	label := editor layout presenters first.
	editor updateAll.
	self assert: editor layout presenters first identicalTo: label
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testNoSelectionLabelIsOwnedByTheEditor [

	self assert: editor layout presenters first owner identicalTo: editor
]

{ #category : 'tests' }
DebugPointEditorPresenterTest >> testWatchPresenterIsOwnedByTheEditor [

	editor debugPoint: WatchDebugPoint new.
	self assert: (editor layout presenters detect: [ :each | each class == WatchPresenter ]) owner identicalTo: editor
]
