"
I am a presenter representing a group for method browsers, allowing them to open as tabs.

A group instance is a browsing context: opening a method browser in the same group
adds it as a tab (same browsing context), while a brand new group opens a new window
(a new browsing context).
"
Class {
	#name : 'StMethodBrowserGroup',
	#superclass : 'StPresenter',
	#instVars : [
		'notebook'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'adding' }
StMethodBrowserGroup class >> openNewBrowser: aMethodBrowser [
	"Open aMethodBrowser as a new browsing context: create a fresh group window that
	 hosts it as its first tab."

	| group |
	group := self new.
	group open.
	group addBrowser: aMethodBrowser.
	^ aMethodBrowser
]

{ #category : 'adding' }
StMethodBrowserGroup >> addBrowser: aMethodBrowser [
	"Add aMethodBrowser as a new tab in the receiver, i.e. in the same browsing context."

	aMethodBrowser browsingGroup: self.
	aMethodBrowser application: self application.
	aMethodBrowser owner: self.
	self addTab: aMethodBrowser.
	self window activate.
	^ aMethodBrowser
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
			(notebook pages anySatisfy: [ :page | page activePresenter ifNil: [ false ] ifNotNil: [ :browser | browser isDirty ] ])
				ifTrue: [
						(self application confirm: 'Some tabs have unsaved changes.
Is it OK to discard changes?') ifFalse: [ ann denyClose ] ] ].
	aWindowPresenter whenClosedDo: [
		notebook pages do: [ :page | page activePresenter ifNotNil: [ :browser | browser unregisterFromAnnouncements ] ] ]
]

{ #category : 'accessing' }
StMethodBrowserGroup >> notebook [

	^ notebook
]
