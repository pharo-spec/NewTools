"
I create a vertical list of UI elements, based on the behaviors and class of a DebugPoint.
"
Class {
	#name : 'DebugPointEditorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'debugPoint',
		'isActiveCheckBox',
		'actionBar'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'action handling' }
DebugPointEditorPresenter >> changeDebugPointState: newState [
	self debugPoint enabled: newState.
	DebugPointManager notifyDebugPointChanged: self debugPoint .
]

{ #category : 'layout' }
DebugPointEditorPresenter >> createLayout [

	self debugPoint ifNil: [ ^self layout: self defaultLayout ].
	self layout: SpBoxLayout newTopToBottom.
	self layout add: actionBar expand: false.
	self layout add: self newActiveCheckBox expand: false.
	DebugPointBehavior allSubclassesDo: [ :behavior |
		| behaviorUI | 
		behaviorUI := (behavior uiElement new debugPoint: self debugPoint ).
		 self layout add: behaviorUI expand: ((self debugPoint getBehavior: behavior) ifNotNil: [ behaviorUI expand ] ifNil: [ false ] ) .
		]. 
	debugPoint uiElement ifNotNil: [ :ui | self layout add: ui ].
	"self layout add: debugPoint uiElement."

]

{ #category : 'accessing' }
DebugPointEditorPresenter >> debugPoint [
	^debugPoint
	

	
]

{ #category : 'accessing' }
DebugPointEditorPresenter >> debugPoint: aDebugPoint [
	debugPoint := aDebugPoint .
	
	self updateAll.
	
]

{ #category : 'layout' }
DebugPointEditorPresenter >> defaultLayout [ 
	^SpBoxLayout new hAlignCenter; vAlignCenter;
	add: (SpLabelPresenter new label: 'Select a Debug Point');
	yourself.
]

{ #category : 'initialization' }
DebugPointEditorPresenter >> initializePresenters [

	actionBar := self newToolbar
		             add: (self newToolbarButton
				              label: 'Refresh';
				              icon: (self iconNamed: #smallUpdate);
				              help: 'refresh page';
				              action: [ self updateAll ];
				              yourself);
		             add: (self newToolbarButton
				              label: 'Remove';
				              icon: (self iconNamed: #smallCancel);
				              help: 'Remove this point';
				              action: [ debugPoint remove ];
				              yourself);
		             yourself
]

{ #category : 'presenter building' }
DebugPointEditorPresenter >> newActiveCheckBox [
	isActiveCheckBox := self newCheckBox label: 'enabled: (de)activates debug point'.
	isActiveCheckBox state: self debugPoint enabled.
	isActiveCheckBox whenActivatedDo: [ self changeDebugPointState: true ].
	isActiveCheckBox whenDeactivatedDo: [ self changeDebugPointState: false ].
	^isActiveCheckBox 
]

{ #category : 'updating - presenters' }
DebugPointEditorPresenter >> updateAll [

	self createLayout.
	"self layout children do: [ :c | c update]"
]
