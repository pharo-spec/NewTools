"
I am a single object inspector.
I present a notebook with the possible inspection of the object.

I am usually embedded into an StInspector, but I can be used standalone.
"
Class {
	#name : #StObjectInspector,
	#superclass : #StPresenter,
	#instVars : [
		'views',
		'evaluator',
		'model',
		'activationBlock',
		'header',
		'alivePresentersByPage',
		'activateOnSingleClick'
	],
	#classVars : [
		'PreferredExtent'
	],
	#classInstVars : [
		'header'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #commands }
StObjectInspector class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	| group |
	
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	(StInspectorCommand toolbarCommandsFor: presenter)
		do: [ :cmd | group register: cmd ].
	
	aCmCommandsGroup register: group
]

{ #category : #commands }
StObjectInspector class >> buildRootCommandsGroupFor: aPresenter [
	| rootCommandGroup |
	
	rootCommandGroup := CmCommandGroup forSpec beRoot.
	"Register extension commands first."
	self buildExtensionCommandsWith: aPresenter forRoot: rootCommandGroup.
	"Register default commands."
	self buildCommandsGroupWith: aPresenter forRoot: rootCommandGroup.
	
	^ rootCommandGroup
]

{ #category : #accessing }
StObjectInspector class >> defaultTitle [

	^ 'Inspector'
]

{ #category : #'tools registry' }
StObjectInspector class >> inspect: anObject [

	^ self openOn: anObject
]

{ #category : #opening }
StObjectInspector class >> onObject: anObject [

	^ self on: (StInspectorModel on: anObject)
]

{ #category : #opening }
StObjectInspector class >> openOn: anObject [

	^ (self onObject: anObject) openWithSpec
]

{ #category : #private }
StObjectInspector >> activate: aSelection [

	activationBlock ifNil: [ ^ self ].
	activationBlock cull: aSelection
]

{ #category : #accessing }
StObjectInspector >> activateOnDoubleClick [

	activateOnSingleClick := true
]

{ #category : #accessing }
StObjectInspector >> activateOnSingleClick [

	activateOnSingleClick := true
]

{ #category : #private }
StObjectInspector >> addActivationTo: aPresenter [
	
	aPresenter hasOutputActivationPort ifFalse: [ ^ self ]. 
	activateOnSingleClick ifTrue: [ aPresenter activateOnSingleClick ].
	aPresenter outputActivationPort 
		transmitDo: [ :selection | self activate: selection ]
]

{ #category : #private }
StObjectInspector >> allContexts [

	^ self model objectInspectionContexts
]

{ #category : #private }
StObjectInspector >> allPages [
	
	^ self allContexts 
		collect: [ :each | self newPageForContext: each ]
	
]

{ #category : #'private builder' }
StObjectInspector >> buildToolbar [

	^ self rootCommandsGroup asToolbarPresenterWith: [ :presenter | 
			presenter 
				displayMode: self application toolbarDisplayMode;
				addStyle: 'stToolbar' ]
]

{ #category : #transmission }
StObjectInspector >> defaultInputPort [

	^ self inputModelPort
]

{ #category : #'api-focus' }
StObjectInspector >> defaultKeyboardFocus [

	^ views pages 
		ifNotEmpty: [ :pages | pages first activePresenter ] 
		ifEmpty: [ self ]
]

{ #category : #initialization }
StObjectInspector >> initialize [

	activateOnSingleClick := false.
	super initialize.
	"I keep the presenters I'm showing in this variable because they can change (and they are 
	 initialized lazily in the notebook)"
	alivePresentersByPage := WeakSet new
]

{ #category : #initialization }
StObjectInspector >> initializeLayout [
	
	self layout: (SpBoxLayout newVertical 
		add: header expand: false fill: false padding: 5;
		add: views;
		yourself)
]

{ #category : #initialization }
StObjectInspector >> initializePresenters [

	views := self newNotebook.
	header := self instantiate: StHeaderBar.
	self initializeLayout.

	self refresh
]

{ #category : #initialization }
StObjectInspector >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		toolbar: self buildToolbar
]

{ #category : #transmission }
StObjectInspector >> inputModelPort [

	^ SpModelPort newPresenter: self
]

{ #category : #accessing }
StObjectInspector >> inspectedObject [
 	
	^ self model inspectedObject
]

{ #category : #private }
StObjectInspector >> keepPresenter: aPresenter [

	alivePresentersByPage add: aPresenter
]

{ #category : #'model access' }
StObjectInspector >> model [ 

	^ model
]

{ #category : #'model access' }
StObjectInspector >> model: anInspectorModel [

	"if same object, I do not want to update to not trigger infinite updates"
	model inspectedObject == anInspectorModel inspectedObject 
		ifTrue: [ ^ self ].
	model := anInspectorModel.
	self refresh
]

{ #category : #'private factory' }
StObjectInspector >> newInspectionForContext: aContext [
	
	^ StObjectContextPresenter on: (StObjectContextModel new 
		inspection: self model;
		inspectedObject: self inspectedObject;
		context: aContext; 
		yourself)
]

{ #category : #'private factory' }
StObjectInspector >> newPageForContext: aContext [ 

	^ SpNotebookPage new
		title: aContext title;
		presenterProvider: [ self newInspectionForContext: aContext ];
		whenRetrievedDo: [ :presenter | 
			self keepPresenter: presenter.
			self addActivationTo: presenter ];
		yourself
]

{ #category : #accessing }
StObjectInspector >> rawInspectorPageOrNil [

	^ views pages 
		detect: [ :page | page title = 'Raw' ] 
		ifNone: [ nil ]
]

{ #category : #'private updating' }
StObjectInspector >> refresh [
	"model changed?  
	 update inspector values."

	self updateTitle.
	self updateHeaderBar.
	self updateEvaluator.
	self updatePages
]

{ #category : #accessing }
StObjectInspector >> refreshContent [
	"I force a refresh of current page contents. "

	views selectedPage resetContent
]

{ #category : #accessing }
StObjectInspector >> selectedObject [
	^ self inspectedObject
]

{ #category : #accessing }
StObjectInspector >> selectedPage [

	^ views selectedPage
]

{ #category : #accessing }
StObjectInspector >> selectedPageName [

	^ self selectedPage title
]

{ #category : #private }
StObjectInspector >> setModel: aModel [

	self model: aModel
]

{ #category : #'model access' }
StObjectInspector >> setModelBeforeInitialization: anInspectorModel [

	model := anInspectorModel
]

{ #category : #stepping }
StObjectInspector >> step [

	alivePresentersByPage 
		do: [ :each | each step ]
]

{ #category : #accessing }
StObjectInspector >> title [

	^ self model windowTitle
]

{ #category : #accessing }
StObjectInspector >> trySelectAnyPageWithName: aCollection [
	"Tries to select a the first page of aCollection that exists in the pages list."
	| pagesToSearch |

	pagesToSearch := ((aCollection asOrderedCollection 
		reject: [ :each | each isNil ])
		reject: [ :each | each = StRawInspection label ])
		removeDuplicates.
	pagesToSearch ifEmpty: [ ^ self ].

	pagesToSearch do: [ :eachName |
		views pages 
			detect: [ :each | each title = eachName ]
			ifFound: [ :aPage | 
				views selectPage: aPage.
				^ self ] ]
]

{ #category : #'private updating' }
StObjectInspector >> updateEvaluator [

	"evaluator beForObject: self model inspectedObject"
]

{ #category : #'private updating' }
StObjectInspector >> updateHeaderBar [
		
	header label: self model labelString.
	header toolbarActions: self rootCommandsGroup 
]

{ #category : #'private updating' }
StObjectInspector >> updatePages [

	views 
		pages: self allPages;
		selectPageIndex: 1
]

{ #category : #'private updating' }
StObjectInspector >> updateTitle [
		
	self isRoot ifFalse: [ ^ self ].
	self withWindowDo: [ :window | 
		window title: self title ].
]

{ #category : #'api-events' }
StObjectInspector >> whenActivatedDo: aBlock [

	activationBlock := aBlock
]

{ #category : #'api-events' }
StObjectInspector >> whenClosedDo: aBlock [

	header whenClosedDo: aBlock
]
