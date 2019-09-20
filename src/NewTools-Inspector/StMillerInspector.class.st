Class {
	#name : #StMillerInspector,
	#superclass : #StPresenter,
	#instVars : [
		'millerList',
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #accessing }
StMillerInspector class >> defaultSpacing [

	^ 3
]

{ #category : #specs }
StMillerInspector class >> defaultSpec [

	^ SpBoxLayout newVertical
		add: #millerList;
		yourself
]

{ #category : #'instance creation' }
StMillerInspector class >> onObject: anObject [

	^ self on: (StInspectorModel on: anObject)
]

{ #category : #'instance creation' }
StMillerInspector class >> openOn: anObject [

	^ (self onObject: anObject) openWithSpec
]

{ #category : #initialization }
StMillerInspector >> initializePresenters [

	millerList := self instantiate: SpMillerColumnPresenter.
	millerList 
		spacing: self spacing;
		presenterBlock: [ :aModel | self spawnInspectorFor: aModel ];
		setRootModel: self model inspectedObject
]

{ #category : #initialization }
StMillerInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self model windowTitle;
		initialExtent: StInspector preferredExtent;
		whenResizingDo: [ :ann | 
			StInspector preferredExtent: ann newSize ]
]

{ #category : #accessing }
StMillerInspector >> model [

	^ model
]

{ #category : #'accessing model' }
StMillerInspector >> model: aModel [

	model := aModel.
	millerList setRootModel: aModel
]

{ #category : #'accessing model' }
StMillerInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : #accessing }
StMillerInspector >> spacing [
	
	^ self class defaultSpacing
]

{ #category : #initialization }
StMillerInspector >> spawnInspectorFor: aModel [
		
	self flag: #HACK. "I do not like to use this, but I really do not want to add a method 
	#isInspectorNode in Object :("
	^ StInspector onObject: ((aModel isKindOf: StInspectorNode)
		ifTrue: [ aModel rawValue ]
		ifFalse: [ aModel ])
]
