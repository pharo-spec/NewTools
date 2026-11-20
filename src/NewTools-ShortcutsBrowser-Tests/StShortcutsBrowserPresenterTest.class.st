"
I test `StShortcutsBrowserPresenter`, the browser of the keyboard shortcuts (keymaps) of the image, at the presenter level.

## Responsibility:

- Check its action bar: a Browse and an Inspect button, created through the browser and owned by the action bar, so that they use the browser application.
- Check that the Inspect button opens one inspector on the selected shortcut (it used to open two).

## Collaborators: 

- `StInspectorPresenter`: the inspector opened by the Inspect button; `testInspectOpensOneInspector` counts the open ones and closes those it opened (`closeInspectorsNotIn:`).

## Internal Representation

- `browser`: the presenter under test, not opened.
"
Class {
	#name : 'StShortcutsBrowserPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'browser'
	],
	#category : 'NewTools-ShortcutsBrowser-Tests',
	#package : 'NewTools-ShortcutsBrowser-Tests'
}

{ #category : 'helpers' }
StShortcutsBrowserPresenterTest >> buttonLabeled: aString [

	^ browser actionBar presenters detect: [ :each | each label = aString ]
]

{ #category : 'helpers' }
StShortcutsBrowserPresenterTest >> closeInspectorsNotIn: someInspectors [

	self openInspectors reject: [ :each | someInspectors includes: each ] thenDo: [ :each | each window close ]
]

{ #category : 'helpers' }
StShortcutsBrowserPresenterTest >> openInspectors [
	"Answer the inspectors shown in an open window."

	^ StInspectorPresenter allInstances select: [ :each | each window isNotNil and: [ each window isOpen ] ]
]

{ #category : 'running' }
StShortcutsBrowserPresenterTest >> setUp [

	super setUp.
	browser := StShortcutsBrowserPresenter new
]

{ #category : 'tests' }
StShortcutsBrowserPresenterTest >> testActionBarButtonsBelongToTheBrowser [

	self assert: browser actionBar owner identicalTo: browser.
	browser actionBar presenters do: [ :each | self assert: each owner identicalTo: browser actionBar ]
]

{ #category : 'tests' }
StShortcutsBrowserPresenterTest >> testActionBarButtonsUseTheBrowserApplication [

	browser actionBar presenters do: [ :each | self assert: each application identicalTo: browser application ]
]

{ #category : 'tests' }
StShortcutsBrowserPresenterTest >> testActionBarOffersBrowseAndInspect [

	self assert: (browser actionBar presenters collect: [ :each | each label ] as: Array) equals: #( 'Browse' 'Inspect' )
]

{ #category : 'tests' }
StShortcutsBrowserPresenterTest >> testInspectOpensOneInspector [
	"The Inspect button used to send #inspect, which opens an inspector, and then open a second one on its result."

	| before |
	browser shortcutTable selectIndex: 1.
	before := self openInspectors.
	[
		(self buttonLabeled: 'Inspect') click.
		self assert: (self openInspectors reject: [ :each | before includes: each ]) size equals: 1 ] ensure: [
		self closeInspectorsNotIn: before ]
]
