"
I am the UI element for the OnceBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'OncePresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
OncePresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	behavior := self debugPoint getBehavior: OnceBehavior.
	checkBox state: (self debugPoint getBehavior: OnceBehavior) isNotNil.

]

{ #category : 'layout' }
OncePresenter >> defaultLayout [ 
	
	^SpBoxLayout newTopToBottom
		add: checkBox expand: false;
		yourself.
]

{ #category : 'initialization' }
OncePresenter >> initializePresenters [ 
	
	checkBox  := self newCheckBox label: 'Once: Deactivates debug point after one hit'.
	checkBox whenActivatedDo: [ self behavior ifNil: [ debugPoint addBehavior: OnceBehavior new ] ].
	checkBox whenDeactivatedDo: [ 
		self debugPoint removeBehavior: OnceBehavior. 
		self behavior: nil. ].
]
