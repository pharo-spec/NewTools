Class {
	#name : #StMillerInspector,
	#superclass : #SpMillerColumnPresenter,
	#instVars : [
		'millerList',
		'model'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StMillerInspector class >> defaultSpec [

	^ SpScrollableLayout new 
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
		presenterBlock: [ :aModel | StInspector onObject: aModel ];
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
