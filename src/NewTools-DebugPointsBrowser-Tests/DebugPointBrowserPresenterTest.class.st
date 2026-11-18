"
I test `DebugPointBrowserPresenter` at the presenter level, without opening it.

## Responsibility:

- Check that its subpresenters (the editor, the code and the variable target presenter) are created through the browser, so that they belong to it and use its application.
- Check that the code is read only.

## Collaborators: 

- `DebugPointBrowserPresenter`: created on a fresh `SpApplication`. It subscribes to its `codeSupportAnnouncer` when created, so `tearDown` unsubscribes it.

## Internal Representation

- `browser`: the presenter under test.
"
Class {
	#name : 'DebugPointBrowserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser'
	],
	#category : 'NewTools-DebugPointsBrowser-Tests',
	#package : 'NewTools-DebugPointsBrowser-Tests'
}

{ #category : 'running' }
DebugPointBrowserPresenterTest >> setUp [

	super setUp.
	browser := DebugPointBrowserPresenter newApplication: SpApplication new
]

{ #category : 'running' }
DebugPointBrowserPresenterTest >> tearDown [

	DebugPointBrowserPresenter codeSupportAnnouncer unsubscribe: browser.
	super tearDown
]

{ #category : 'tests' }
DebugPointBrowserPresenterTest >> testCodeIsNotEditable [

	self deny: browser dpCode isEditable
]

{ #category : 'tests' }
DebugPointBrowserPresenterTest >> testCodeIsOwnedByTheBrowser [

	self assert: browser dpCode owner identicalTo: browser
]

{ #category : 'tests' }
DebugPointBrowserPresenterTest >> testEditorIsOwnedByTheBrowser [

	self assert: browser dpEditor owner identicalTo: browser
]

{ #category : 'tests' }
DebugPointBrowserPresenterTest >> testVariableTargetPresenterIsOwnedByTheBrowser [

	self assert: browser variableTargetPresenter owner identicalTo: browser
]
