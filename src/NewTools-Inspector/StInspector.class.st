Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'views',
		'evaluator',
		'model'
	],
	#classVars : [
		'PreferredExtent'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StInspector class >> defaultSpec [
	<spec: #default>
	
	^ SpPanedLayout newVertical
		position: 70 percent;
		add: #views;
		add: #evaluator;
		yourself
]

{ #category : #accessing }
StInspector class >> defaultTitle [

	^ 'Inspector'
]

{ #category : #accessing }
StInspector class >> extensionsPragma [

	^ #inspectorPresentationOrder:title:
]

{ #category : #'tools registry' }
StInspector class >> inspect: anObject [

	^ self openOn: anObject
]

{ #category : #opening }
StInspector class >> openOn: anObject [

	^ (self on: (StInspectorModel on: anObject)) openWithSpec
]

{ #category : #accessing }
StInspector class >> preferredExtent [
	
	^ PreferredExtent ifNil: [ PreferredExtent := 600@400 ]
]

{ #category : #accessing }
StInspector class >> titleFor: anObject [ 

	^ 'Inspector on {1}' format: { anObject gtDisplayString  }
]

{ #category : #private }
StInspector >> allPages [

	^ self model objectInspectionPages
]

{ #category : #'private builder' }
StInspector >> buildToolBar [

	^ CmCommandGroup forSpec
		register: (StInspectorBrowseCommand forSpecContext: self);
		register: (StInspectorHelpCommand forSpecContext: self);
		asToolBarPresenterWith: [ :presenter | presenter beIcons ]
]

{ #category : #initialization }
StInspector >> initializeWidgets [

	views := self newNotebook.
	evaluator := self newCode.

	views pages: self allPages.
		
	self refresh
]

{ #category : #initialization }
StInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		toolBar: self buildToolBar
]

{ #category : #'model access' }
StInspector >> inspectedObject [ 	
	^self model inspectedObject
]

{ #category : #'model access' }
StInspector >> model [ 

	^ model
]

{ #category : #'model access' }
StInspector >> model: anInspectorModel [

	model := anInspectorModel.
	self refresh
]

{ #category : #private }
StInspector >> refresh [
	"model changed?  
	 update inspector values."

	self flag: #TODO.	"not finished, clearly :P"
	self withWindowDo: [ :window | 
		window title: self title ].
	evaluator doItReceiver: self model inspectedObject.
	views pagesChanged.
	self update
]

{ #category : #'model access' }
StInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel

	
]

{ #category : #accessing }
StInspector >> title [
	^ self class titleFor: self model inspectedObject
]
