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
		'currentDirectory',
		'presenterUI',
		'editButton',
		'path'
	],
	#category : #'NewTools-FileDialog-UI'
}

{ #category : #specs }
FDWindowPathPresenter class >> defaultSpec [
	^ SpBoxLayout newHorizontal
		add: #path;
		add: #editButton
			expand: false
			fill: false
			padding: 0;
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
	^ currentDirectory
]

{ #category : #api }
FDWindowPathPresenter >> currentDirectory: aFileReference [
	currentDirectory := aFileReference asAbsolute.
	self updatePathInputWith: aFileReference.
	path file: aFileReference.
	self needRebuild: false.
	self buildWithSpec
]

{ #category : #accessing }
FDWindowPathPresenter >> entityText [
	^ textInput entityText
]

{ #category : #initialization }
FDWindowPathPresenter >> initializeWidgets [
	| isTextInput |
	isTextInput := false.
	textInput := self instantiate: SpSelectEntity.
	path := self instantiate: FDPathPresenter.
	path action: [ :fileReference | self select: fileReference ].
	editButton := self newButton.
	textInput entityText autoAccept: false.
	textInput placeholder: 'give/me/a/path'.
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

{ #category : #accessing }
FDWindowPathPresenter >> presenterUI [
	^ presenterUI
]

{ #category : #accessing }
FDWindowPathPresenter >> presenterUI: anObject [
	presenterUI := anObject
]

{ #category : #initialization }
FDWindowPathPresenter >> select: fileReference [
	self currentDirectory: fileReference asFileReference.
	textInput entityText text: currentDirectory fullName.
	^ presenterUI openOn: currentDirectory
]

{ #category : #api }
FDWindowPathPresenter >> updatePathInputWith: aFileReference [
	textInput possibleEntities: (aFileReference children collect: #fullName).
	textInput entityText text: aFileReference fullName
]
