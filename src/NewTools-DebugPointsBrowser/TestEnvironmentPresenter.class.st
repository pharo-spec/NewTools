"
I am the UI element for the TestEnvironmentBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'TestEnvironmentPresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
TestEnvironmentPresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	behavior := self debugPoint getBehavior: TestEnvironmentBehavior .
	checkBox state: (self debugPoint getBehavior: TestEnvironmentBehavior) isNotNil.

]

{ #category : 'layout' }
TestEnvironmentPresenter >> defaultLayout [ 
	
	^SpBoxLayout newTopToBottom
		add: checkBox expand: false;
		yourself.
]

{ #category : 'initialization' }
TestEnvironmentPresenter >> initializePresenters [ 
	
	checkBox  := self newCheckBox label: 'Test Environment Only: Hits only when executing tests'.
	checkBox whenActivatedDo: [ self behavior ifNil: [ debugPoint addBehavior: TestEnvironmentBehavior new ] ].
	checkBox whenDeactivatedDo: [ 
		self debugPoint removeBehavior: TestEnvironmentBehavior. 
		self behavior: nil. ].
]
