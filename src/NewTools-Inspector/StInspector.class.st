Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'views',
		'evaluator',
		'model',
		'activationBlock'
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
StInspector class >> onObject: anObject [

	^ self on: (StInspectorModel on: anObject)
]

{ #category : #opening }
StInspector class >> openOn: anObject [

	^ (self onObject: anObject) openWithSpec
]

{ #category : #accessing }
StInspector class >> preferredExtent [
	
	^ PreferredExtent ifNil: [ PreferredExtent := 600@400 ]
]

{ #category : #accessing }
StInspector class >> preferredExtent: aPoint [
	
	PreferredExtent := aPoint
]

{ #category : #accessing }
StInspector class >> titleFor: anObject [ 

	^ 'Inspector on {1}' format: { anObject gtDisplayString  }
]

{ #category : #private }
StInspector >> activate: aSelection [

	activationBlock ifNil: [ ^ self ].
	activationBlock cull: aSelection
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
		asToolbarPresenterWith: [ :presenter | presenter beIcons ]
]

{ #category : #initialization }
StInspector >> defineInputPorts [

	^ { SpModelPort new }
]

{ #category : #initialization }
StInspector >> defineOutputPorts [

	^ { SpActivationPort new }
]

{ #category : #initialization }
StInspector >> initializeEvaluator [
	
	evaluator := self newCode
]

{ #category : #initialization }
StInspector >> initializePresenters [

	self initializeViews.
	self initializeEvaluator.
			
	self refresh
]

{ #category : #initialization }
StInspector >> initializeViews [

	views := self newNotebook.
	views pages: self allPages.
	views pages do: [ :each |
		(each hasPortNamed: 'activation') ifTrue: [ 
			each 
				transmitPort: 'activation' 
				do: [ :selection | self activate: selection ] ] ]
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

	"if same object, I do not want to update to not trigger infinite updates"
	model inspectedObject == anInspectorModel inspectedObject 
		ifTrue: [ ^ self ].
	model := anInspectorModel.
	self refresh
]

{ #category : #private }
StInspector >> refresh [
	"model changed?  
	 update inspector values."

	self updateTitle.
	evaluator doItReceiver: self model inspectedObject.
	views 
		pages: self allPages;
		selectPageIndex: 1.
]

{ #category : #private }
StInspector >> setModel: aModel [

	self model: aModel
]

{ #category : #'model access' }
StInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : #accessing }
StInspector >> title [

	^ self class titleFor: self model inspectedObject
]

{ #category : #private }
StInspector >> updateTitle [
		
	self withWindowDo: [ :window | 
		window title: self title ].
]

{ #category : #'api-events' }
StInspector >> whenActivatedDo: aBlock [

	activationBlock := aBlock
]
