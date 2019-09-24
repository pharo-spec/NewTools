Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'millerList',
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #accessing }
StInspector class >> defaultSpacing [

	^ 3
]

{ #category : #specs }
StInspector class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #millerList;
		yourself
]

{ #category : #'instance creation' }
StInspector class >> inspect: anObject [

	^ self openOn: anObject
]

{ #category : #'instance creation' }
StInspector class >> onObject: anObject [

	^ self on: (StInspectorModel on: anObject)
]

{ #category : #'instance creation' }
StInspector class >> openOn: anObject [

	^ (self onObject: anObject) openWithSpec
]

{ #category : #initialization }
StInspector >> initializePresenters [

	millerList := self instantiate: SpMillerColumnPresenter.
	millerList 
		spacing: self spacing;
		presenterBlock: [ :aModel | self spawnInspectorFor: aModel ];
		setRootModel: self model inspectedObject
]

{ #category : #initialization }
StInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model windowTitle;
		initialExtent: StObjectInspector preferredExtent;
		whenOpenedDo: [ self startStepping ];
		whenClosedDo: [ self stopStepping ];
		whenResizingDo: [ :ann | StObjectInspector preferredExtent: ann newSize ]
]

{ #category : #accessing }
StInspector >> model [

	^ model
]

{ #category : #'accessing model' }
StInspector >> model: aModel [

	model := aModel.
	millerList setRootModel: aModel
]

{ #category : #'accessing model' }
StInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : #accessing }
StInspector >> spacing [
	
	^ self class defaultSpacing
]

{ #category : #initialization }
StInspector >> spawnInspectorFor: aModel [
		
	self flag: #HACK. "I do not like to use this, but I really do not want to add a method 
	#isInspectorNode in Object :("
	^ StObjectInspector onObject: ((aModel isKindOf: StInspectorNode)
		ifTrue: [ aModel rawValue ]
		ifFalse: [ aModel ])
]

{ #category : #'private stepping' }
StInspector >> startStepping [
	
	StInspectorRefreshService uniqueInstance register: self
]

{ #category : #'private stepping' }
StInspector >> step [ 

	millerList pages
		do: [ :each | each step ]
]

{ #category : #'private stepping' }
StInspector >> stopStepping [

	StInspectorRefreshService uniqueInstance unregister: self
]
