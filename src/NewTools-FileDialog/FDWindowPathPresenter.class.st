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
	#name : #FDWindowPathPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'textInput',
		'editButton',
		'path'
	],
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #specs }
FDWindowPathPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #path;
		add: #editButton expand: false fill: false padding: 0;
		yourself
]

{ #category : #examples }
FDWindowPathPresenter class >> example [
	<example>
	^ self new
		currentDirectory: FileLocator imageDirectory;
		openWithSpec
]

{ #category : #specs }
FDWindowPathPresenter class >> otherlayout [
	^ SpBoxLayout newHorizontal
		add: #textInput withConstraints: [ :contraint | contraint spec: #fDLayoutFileDialog ];
		add: #editButton
			expand: false
			fill: false
			padding: 0;
		yourself
]

{ #category : #accessing }
FDWindowPathPresenter >> currentDirectory [
	^ self owner ifNotNil: #currentDirectory
]

{ #category : #api }
FDWindowPathPresenter >> currentDirectory: aFileReference [
	self owner ifNotNil: [ :fileNavigation | fileNavigation currentDirectory: aFileReference asAbsolute ].
	textInput text: aFileReference fullName.
	path file: aFileReference.
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #accessing }
FDWindowPathPresenter >> entityText [
	^ textInput
]

{ #category : #initialization }
FDWindowPathPresenter >> initializePresenters [
	| isTextInput |
	textInput := self newTextInput.
	path := self instantiate: FDPathPresenter.
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
FDWindowPathPresenter >> path [
	^ path
]
