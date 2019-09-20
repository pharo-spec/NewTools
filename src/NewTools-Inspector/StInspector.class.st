Class {
	#name : #StInspector,
	#superclass : #StPresenter,
	#instVars : [
		'views',
		'evaluator',
		'model',
		'activationBlock',
		'header'
	],
	#classVars : [
		'PreferredExtent'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StInspector class >> defaultSpec [
	<spec: #default>
	
	^ SpBoxLayout newVertical 
		add: #header expand: false fill: false padding: 5;
		add: (SpPanedLayout newVertical
			position: 70 percent;
			add: #views;
			add: #evaluator;
			yourself);
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

{ #category : #private }
StInspector >> activate: aSelection [

	activationBlock ifNil: [ ^ self ].
	activationBlock cull: aSelection
]

{ #category : #private }
StInspector >> addActivationTo: aPresenter [
	
	(aPresenter hasPortNamed: 'activation') ifFalse: [ ^ self ]. 
	
	aPresenter
		transmitPort: 'activation'
		do: [ :selection | self activate: selection ]
]

{ #category : #private }
StInspector >> allPages [
	| pages |

	pages := self model objectInspectionPages.
	pages do: [ :each | 
		each whenRetrievedDo: [ :presenter | 
			self addActivationTo: presenter ] ].
	
	^ pages
	
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
StInspector >> initializePresenters [

	header := self instantiate: StHeaderBar.
	views := self newNotebook.	
	evaluator := self newCode.
			
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
	self updateHeaderBar.
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

	^ self model windowTitle
]

{ #category : #private }
StInspector >> toolbarActions [
	| group |
	
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	(StInspectorCommand toolbarCommandsFor: self)
		do: [ :cmd | group register: cmd ].
	
	^ group
]

{ #category : #private }
StInspector >> updateHeaderBar [
		
	header label: self model descriptionString.
	header toolbarActions: self toolbarActions
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
