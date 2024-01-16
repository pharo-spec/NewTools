"
I provide a windowPathEditor 

API

- `currentDirectory:  aFileReference` see example class side 
- `presenterUI: theUIUsingThisPresenter` you have to send this message see the following example:

```smalltalk
		 MyUi >> initializePresenters
			...
			maVar := self instantiate: StFBWindowPathPresenter.
			maVar presenterUI: self.
			...
```
			
UI using this widget have to define openOn: aFileReference

"
Class {
	#name : 'StFBPathBreadcrumbPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'textInput',
		'editButton',
		'path',
		'isInEditMode'
	],
	#category : 'NewTools-FileBrowser-UI',
	#package : 'NewTools-FileBrowser',
	#tag : 'UI'
}

{ #category : 'specs' }
StFBPathBreadcrumbPresenter class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  vAlignCenter;
		  add: #path;
		  add: #editButton
		  expand: false
		  fill: false
		  padding: 0;
		  yourself
]

{ #category : 'specs' }
StFBPathBreadcrumbPresenter class >> editablelayout [

	^ SpBoxLayout newLeftToRight
		  add: #textInput;
		  add: #editButton
		  expand: false
		  fill: false
		  padding: 0;
		  yourself
]

{ #category : 'examples' }
StFBPathBreadcrumbPresenter class >> example [
	<example>
	^ self new
		currentDirectory: FileLocator imageDirectory;
		open
]

{ #category : 'accessing' }
StFBPathBreadcrumbPresenter >> currentDirectory [
	^ self owner ifNotNil: #currentDirectory
]

{ #category : 'api' }
StFBPathBreadcrumbPresenter >> currentDirectory: aFileReference [

	textInput text: aFileReference fullName.
	path file: aFileReference.
	self owner ifNotNil: [ :fileNavigation | 
		fileNavigation currentDirectory: aFileReference asAbsolute ].
	self needRebuild: false.
	self build
]

{ #category : 'accessing' }
StFBPathBreadcrumbPresenter >> entityText [
	^ textInput
]

{ #category : 'initialization' }
StFBPathBreadcrumbPresenter >> initializePresenters [

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

{ #category : 'accessing' }
StFBPathBreadcrumbPresenter >> path [
	^ path
]

{ #category : 'api' }
StFBPathBreadcrumbPresenter >> pathTextChangedTo: aStringOrText [

	| fileReference |
	
	fileReference := aStringOrText asString asFileReference.
	(fileReference exists and: [ fileReference isDirectory ])
		ifTrue: [ self owner openFolder: fileReference ]
		ifFalse: [ self inform: 'You have to input an existing path to a directory' ].
	isInEditMode := false.
	self layout: self class defaultLayout
]
