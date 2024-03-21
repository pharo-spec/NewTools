"
I am the UI element for the ScriptBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'ScriptPresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#instVars : [
		'codeInput'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'action handling' }
ScriptPresenter >> activate [
	| bh |
	self behavior ifNotNil: [ ^self ].
	bh := (ScriptBehavior new script: (self debugPoint properties at: #Script ifAbsent: '')).
	self debugPoint addBehavior: bh.
	self behavior: bh
]

{ #category : 'action handling' }
ScriptPresenter >> deactivate [
	self debugPoint removeBehavior: ScriptBehavior.
	self behavior: nil.
]

{ #category : 'accessing' }
ScriptPresenter >> debugPoint: aDebugPoint [
	super debugPoint: aDebugPoint.
	behavior := self debugPoint getBehavior: ScriptBehavior.
	checkBox state: self behavior isNotNil.
	
	(self behavior ifNotNil: [:bh | codeInput text: bh script]).
]

{ #category : 'layout' }
ScriptPresenter >> defaultLayout [ 
	| newLayout |
	newLayout := SpBoxLayout newTopToBottom 
		add: checkBox expand: false;
		yourself.
		
	self behavior ifNotNil: [
		newLayout add: ( SpBoxLayout newLeftToRight borderWidth: 5;
			add: codeInput expand: true ;
			yourself) expand: true;
		yourself].
		
	^newLayout
	
]

{ #category : 'expanding-collapsing' }
ScriptPresenter >> expand [
	^true
]

{ #category : 'initialization' }
ScriptPresenter >> initializePresenters [ 
	
	checkBox  := self newCheckBox label: 'Script: Executes a script at each hit'.
	checkBox whenActivatedDo: [ self activate ].
	checkBox whenDeactivatedDo: [ self deactivate ].
	
	codeInput := self newCode.
	codeInput beForScripting.
	codeInput whenTextChangedDo: [ self behavior ifNotNil: [behavior script: codeInput text ]].
]
