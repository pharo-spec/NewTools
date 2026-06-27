"
I am a presenter representing a group for method browsers, allowing them to open as tabs.
"
Class {
	#name : 'StMethodBrowserGroup',
	#superclass : 'StPresenter',
	#instVars : [
		'notebook'
	],
	#classVars : [
		'Current'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'adding' }
StMethodBrowserGroup class >> addOrCreateTab: aMethodBrowser [
	"Main entry point. Find or create the group window, add a tab for aMethodBrowser."

	(Current isNil or: [ Current isDisplayed not ])
		ifTrue: [
				Current := self new.
				Current open ]
		ifFalse: [ Current window activate ].

	aMethodBrowser application: Current application.
	aMethodBrowser owner: Current.
	Current addTab: aMethodBrowser.
	^ aMethodBrowser
]

{ #category : 'accessing' }
StMethodBrowserGroup class >> current [

	^ Current
]

{ #category : 'initialization' }
StMethodBrowserGroup class >> reset [

	<script>
	Current := nil
]

{ #category : 'adding' }
StMethodBrowserGroup >> addTab: aMethodBrowser [

	| page |
	page := SpNotebookPage title: aMethodBrowser windowTitle provider: [ aMethodBrowser ].
	page beCloseable.

	aMethodBrowser onTitleChangedDo: [ :newTitle |
			page title: newTitle.
			notebook pageTitleChanged: page ].
	notebook addPage: page.
	notebook selectPage: page.
	self defer: [ aMethodBrowser methodList listPresenter takeKeyboardFocus ]
]

{ #category : 'initialization' }
StMethodBrowserGroup >> connectPresenters [

	notebook whenSelectedPageChangedDo: [ :page | page ifNotNil: [ self withWindowDo: [ :window | window title: page title ] ] ].
	notebook whenPageRemovedDo: [ :page |
			page activePresenter ifNotNil: [ :browser | browser unregisterFromAnnouncements ].
			notebook pages ifEmpty: [ self withWindowDo: [ :w | w delete ] ] ]
]

{ #category : 'layout' }
StMethodBrowserGroup >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: notebook;
		  yourself
]

{ #category : 'closing' }
StMethodBrowserGroup >> handleTabsFor: anAnnouncement [

	notebook pages size > 1 ifFalse: [ ^ self ].

	anAnnouncement denyClose.
	notebook removePage: notebook selectedPage.

	self defer: [
			self withWindowDo: [ :w | w activate ].
			notebook selectedPage activePresenter ifNotNil: [ :browser | browser methodList listPresenter takeKeyboardFocus ] ]
]

{ #category : 'initialization' }
StMethodBrowserGroup >> initializePresenters [

	notebook := self newNotebook
]

{ #category : 'initialization' }
StMethodBrowserGroup >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.

	aWindowPresenter
		title: 'Message Browser';
		initialExtent: 900 @ 600.
	aWindowPresenter whenWillCloseDo: [ :ann |
			self handleTabsFor: ann.
			(notebook pages anySatisfy: [ :page | page activePresenter ifNil: [ false ] ifNotNil: [ :browser | browser isDirty ] ])
				ifTrue: [
						(self application confirm: 'Some tabs have unsaved changes.
Is it OK to discard changes?') ifFalse: [ ann denyClose ] ] ].
	aWindowPresenter whenClosedDo: [
			notebook pages do: [ :page | page activePresenter ifNotNil: [ :browser | browser unregisterFromAnnouncements ] ].
			self class reset ]
]

{ #category : 'accessing' }
StMethodBrowserGroup >> notebook [

	^ notebook
]
