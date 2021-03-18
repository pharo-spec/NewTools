"
I provide a windowPathEditor 

API

* currentDirectory:  aFileReference
	see example class side 
	
* presenterUI: theUIUsingThisPresenter
	you have to send this message see 
	example (  )
		 MyUi >> initializeWidget
			...
			maVar := self instantiate: FDWindowPathPresenter.
			maVar presenterUI: self.
			...
			
UI using this widget have to define openOn: aFileReference
	
"
Class {
	#name : #StFBWindowPathPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textInput',
		'editButton',
		'path'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #specs }
StFBWindowPathPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #path;
		add: #editButton expand: false fill: false padding: 0;
		yourself
]

{ #category : #examples }
StFBWindowPathPresenter class >> example [
	<example>
	^ self new
		currentDirectory: FileLocator imageDirectory;
		openWithSpec
]

{ #category : #specs }
StFBWindowPathPresenter class >> otherlayout [
	^ SpBoxLayout newHorizontal
		add: #textInput withConstraints: [ :contraint | contraint spec: #fDLayoutFileDialog ];
		add: #editButton
			expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #accessing }
StFBWindowPathPresenter >> currentDirectory [
	^ self owner ifNotNil: #currentDirectory
]

{ #category : #api }
StFBWindowPathPresenter >> currentDirectory: aFileReference [
	self owner ifNotNil: [ :fileNavigation | fileNavigation currentDirectory: aFileReference asAbsolute ].
	textInput text: aFileReference fullName.
	path file: aFileReference.
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #accessing }
StFBWindowPathPresenter >> entityText [
	^ textInput
]

{ #category : #initialization }
StFBWindowPathPresenter >> initializePresenters [
	| isTextInput |
	textInput := self newTextInput.
	path := self instantiate: StFBPathPresenter.
	editButton := self newButton.

	isTextInput := false.

	path action: [ :fileReference | self owner openFolder: fileReference ].

	textInput
		autoAccept: false;
		placeholder: 'path/to/file'.

	editButton
		icon: (self iconNamed: #edit);
		action: [ self needRebuild: false.
			self buildWithSpecLayout: (isTextInput ifTrue: [ self class defaultSpec ] ifFalse: [ self class otherlayout ]).
			isTextInput := isTextInput not ]
]

{ #category : #accessing }
StFBWindowPathPresenter >> path [
	^ path
]
