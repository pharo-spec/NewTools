"
Description
--------------------

I am a page that will display flags locations to the user.

Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	code:					<aTextPresenter>		A text presenter to show the source code of the method containing the flag.
	locationsTable:		<aTablePresenter>		A table presenter to show the different locations to highlight to the user depending on the page organization.

"
Class {
	#name : #FBFlagPresentationPresenter,
	#superclass : #FBPagePresenter,
	#instVars : [
		'code',
		'locationsTable'
	],
	#category : #'NewTools-FlagBrowser-Presenters'
}

{ #category : #testing }
FBFlagPresentationPresenter class >> isAbstract [
	^ self = FBFlagPresentationPresenter
]

{ #category : #accessing }
FBFlagPresentationPresenter >> code [
	^ code
]

{ #category : #accessing }
FBFlagPresentationPresenter >> code: anObject [
	code := anObject
]

{ #category : #initialization }
FBFlagPresentationPresenter >> initializePresenter [
	code whenTextIsAcceptedDo: [ :text | code behavior compile: text ].
	locationsTable
		transmitTo: code
		transform: #sourceCode
		postTransmission: [ :destination :origin :location | 
			destination
				behavior: location classLocation;
				selection: location interval ]
]

{ #category : #initialization }
FBFlagPresentationPresenter >> initializeWidgets [
	locationsTable := self newTable.
	code := self newCode.
	locationsTable
		beResizable;
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | selection selectedItem openInBrowser ];
		contextMenu: self tableMenu.
	code syntaxHighlight: true
]

{ #category : #accessing }
FBFlagPresentationPresenter >> locationsTable [
	^ locationsTable
]

{ #category : #accessing }
FBFlagPresentationPresenter >> locationsTable: anObject [
	locationsTable := anObject
]

{ #category : #initialization }
FBFlagPresentationPresenter >> tableMenu [
	| aMenu |
	
	aMenu := SpMenuPresenter new.
	aMenu addGroup: [ :aGroup | aGroup 
		addItem: [ :anItem |	anItem
			name: 'Browse';
			icon: (self iconNamed: #smallFind);
			action: [ :param | self locationsTable selectedItem openInBrowser ] ] ].

	^ aMenu
]
