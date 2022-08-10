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
		'path',
		'isInEditMode'
	],
	#category : #'NewTools-FileBrowser-UI'
}

{ #category : #specs }
StFBWindowPathPresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  vAlignCenter;
		  add: #path;
		  add: #editButton
		  expand: false
		  fill: false
		  padding: 0;
		  yourself
]

{ #category : #specs }
StFBWindowPathPresenter class >> editablelayout [

	^ SpBoxLayout newLeftToRight
		  add: #textInput;
		  add: #editButton
		  expand: false
		  fill: false
		  padding: 0;
		  yourself
]

{ #category : #examples }
StFBWindowPathPresenter class >> example [
	<example>
	^ self new
		currentDirectory: FileLocator imageDirectory;
		openWithSpec
]

{ #category : #accessing }
StFBWindowPathPresenter >> currentDirectory [
	^ self owner ifNotNil: #currentDirectory
]

{ #category : #api }
StFBWindowPathPresenter >> currentDirectory: aFileReference [

	textInput text: aFileReference fullName.
	path file: aFileReference.
	self owner ifNotNil: [ :fileNavigation | 
		fileNavigation currentDirectory: aFileReference asAbsolute ].
	self needRebuild: false.
	self build
]

{ #category : #accessing }
StFBWindowPathPresenter >> entityText [
	^ textInput
]

{ #category : #initialization }
StFBWindowPathPresenter >> initializePresenters [

	textInput := self newTextInput.
	path := self instantiate: StFBPathPresenter.
	editButton := self newButton.

	isInEditMode := false.

	path action: [ :fileReference | self owner openFolder: fileReference ].

	self entityText whenSubmitDo: [ :newText | 
		self pathTextChangedTo: newText ].

	textInput placeholder: 'path/to/file'.

	editButton
		addStyle: 'small';
		icon: (self application iconNamed: #edit);
		action: [ 
			self needRebuild: false.
			isInEditMode
				ifTrue: [ self pathTextChangedTo: self entityText text ]
				ifFalse: [ self layout: self class editablelayout ].
			isInEditMode := isInEditMode not ]
]

{ #category : #accessing }
StFBWindowPathPresenter >> path [
	^ path
]

{ #category : #'as yet unclassified' }
StFBWindowPathPresenter >> pathTextChangedTo: aStringOrText [

	| fileReference |
	fileReference := aStringOrText asString asFileReference.
	(fileReference exists and: [ fileReference isDirectory ])
		ifTrue: [ self owner openFolder: fileReference ]
		ifFalse: [ 
		self inform: 'You have to input an existing path to a directory' ].
	isInEditMode := false.
	self layout: self class defaultLayout
]
