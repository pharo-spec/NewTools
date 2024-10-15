"
I am a select dialog to display DebugPoints so that the scope of a DebugPoint can be set to a specific object.
"
Class {
	#name : 'DebugPointSelectDialogPresenter',
	#superclass : 'SpSelectDialog',
	#instVars : [
		'code',
		'scope',
		'variableTargetPresenter'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'layout' }
DebugPointSelectDialogPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 5;
		  spacing: 5;
		  add: label expand: false;
		  add: (SpPanedLayout newTopToBottom
				   add: list;
				   add: code;
				   yourself);
		  yourself
]

{ #category : 'initialization' }
DebugPointSelectDialogPresenter >> initializePresenters [

	label := self newLabel.

	list := self instantiate: DebugPointTablePresenter.
	code := DebugPointCodePresenter new
		beForScripting;
		editable: false.

	self initializeVariableTargetPresenter.

	list transmitDo: [ :dp |
		dp ifNotNil: [ dp updateDebugPointUIManager: self ] ]
]

{ #category : 'presenter building' }
DebugPointSelectDialogPresenter >> initializeVariableTargetPresenter [

	variableTargetPresenter := DebugPointVariableTargetPresenter new.
	variableTargetPresenter layout: variableTargetPresenter dialogLayout
]

{ #category : 'initialization' }
DebugPointSelectDialogPresenter >> initializeWindow: aWindowPresenter [ 
	
	aWindowPresenter
		title: 'Debug Points';		
		windowIcon: (self application iconNamed: #bug);
		initialExtent: 800@400

]

{ #category : 'api' }
DebugPointSelectDialogPresenter >> items: items [
	"filter debug points such that only those that are attached to the class of the inspected object are displayed"

	list items: (items select: [ :db | db targetClass = self scope ])
]

{ #category : 'accessing' }
DebugPointSelectDialogPresenter >> scope [  
	^scope
]

{ #category : 'accessing' }
DebugPointSelectDialogPresenter >> scope: anObject [ 
"see items: method"
	scope := anObject class
]

{ #category : 'layout' }
DebugPointSelectDialogPresenter >> switchToNodeTargetView [

	self layout: self defaultLayout
]

{ #category : 'layout' }
DebugPointSelectDialogPresenter >> switchToVariableTargetView [

	self layout: self variableTargetLayout
]

{ #category : 'updating - presenters' }
DebugPointSelectDialogPresenter >> updateCode: aDebugPointTarget [

	code updateCode: aDebugPointTarget
]

{ #category : 'updating - presenters' }
DebugPointSelectDialogPresenter >> updateVariableTargetPresenterFrom: aDebugPointTarget [

	variableTargetPresenter target: aDebugPointTarget
]

{ #category : 'layout' }
DebugPointSelectDialogPresenter >> variableTargetLayout [

	^ SpBoxLayout newTopToBottom
		  borderWidth: 5;
		  spacing: 5;
		  add: label expand: false;
		  add: (SpPanedLayout newTopToBottom
				   add: list;
				   add: variableTargetPresenter;
				   positionOfSlider: 30 percent;
				   yourself);
		  yourself
]
