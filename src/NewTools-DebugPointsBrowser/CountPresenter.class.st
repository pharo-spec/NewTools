"
I am the UI element for the CountBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'CountPresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#instVars : [
		'textInput'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
CountPresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	behavior := self debugPoint getBehavior: CountBehavior.
	checkBox state: (self debugPoint getBehavior: CountBehavior) isNotNil.
	behavior ifNotNil: [ 
		textInput text: behavior count asString ].
]

{ #category : 'layout' }
CountPresenter >> defaultLayout [ 
	| newLayout |
	newLayout := SpBoxLayout newTopToBottom 
		add: checkBox expand: false;
		yourself.
		
	self behavior ifNotNil: [
		newLayout add: self expandedLayout expand: false;
		yourself].
		
	^newLayout

]

{ #category : 'layout' }
CountPresenter >> expandedLayout [
	^( SpBoxLayout newLeftToRight borderWidth: 5;
			add: (self newLabel label: 'Current Count:') expand: false ;
			add: textInput  expand: true ;
			yourself)
]

{ #category : 'initialization' }
CountPresenter >> initializePresenters [ 
	
	textInput := self newTextInput beNotEditable .
	
	checkBox  := self newCheckBox label: 'Counter: Tracks how many times the debug point was reached'.
	checkBox whenActivatedDo: [ 
		self behavior ifNil: [ 
			debugPoint addBehavior: CountBehavior new ] ].
	checkBox whenDeactivatedDo: [ 
		
		self debugPoint removeBehavior: CountBehavior. 
		self behavior: nil. ].
]
