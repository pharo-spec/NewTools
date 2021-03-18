"
Presenter for path name
"
Class {
	#name : #StSimplePathNamePresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'tree',
		'text',
		'label',
		'button'
	],
	#category : #'NewTools-SimpleFileBrowser-UI-Components'
}

{ #category : #specs }
StSimplePathNamePresenter class >> defaultSpec [ 
	^ SpBoxLayout newLeftToRight 	
		add: #label expand: false;
		add: #text;		
		yourself
]

{ #category : #initialization }
StSimplePathNamePresenter >> initializePresenters [

	label := self newLabel label: 'Path:'.
	text := self newTextInput 
]

{ #category : #actions }
StSimplePathNamePresenter >> openNativeFileBrowser [
	| path |
	
	path := self pathName.
	path isEmpty ifTrue: [ ^ self inform: 'No path selected' ].
	(StSimpleFileUtils representsShortWindowsDrive: path) 
		ifTrue: [ path := path , '\' ].
	path asFileReference openInOSFileBrowser
]

{ #category : #initialization }
StSimplePathNamePresenter >> pathName [

	^ text text
]

{ #category : #initialization }
StSimplePathNamePresenter >> pathName: aString [

	text text: aString
]
