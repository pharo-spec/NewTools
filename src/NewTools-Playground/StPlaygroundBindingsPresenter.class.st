"
I am a presenter to show all bindings of parent Playground.
I show a list of active bindings. 
A panel to inspect each of the bindings values is shown too.
"
Class {
	#name : 'StPlaygroundBindingsPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'bindingList',
		'inspector',
		'parent',
		'bindingPanel',
		'inspectorPanel'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'accessing' }
StPlaygroundBindingsPresenter class >> defaultExtent [

	^ (600@400)
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter class >> defaultTitle [

	^ 'Bindings'
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter class >> emptyMessage [

	^ 'There are no bindings to list.'
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter class >> unselectedMessage [

	^ 'Select a variable to inspect its value.'
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter >> bindings [

	^ parent interactionModel bindings
]

{ #category : 'private' }
StPlaygroundBindingsPresenter >> contextMenuActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (StRemoveBindingCommand forSpecContext: self);
		register: (StToggleBindingCommand forSpecContext: self);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StRemoveAllBindingsCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : 'layout' }
StPlaygroundBindingsPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		positionOfSlider: 30 percent;
		add: bindingPanel;
		add: inspectorPanel;
		yourself
]

{ #category : 'testing' }
StPlaygroundBindingsPresenter >> hasSelectedBinding [

	^ self selectedBinding isNotNil
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		centeredRelativeTo: parent window;
		addDefaultButton: 'Close' do: [ :presenter | 
			presenter triggerOkAction.
			presenter close ]
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> initializeInspectorPanel [

	inspectorPanel := (self instantiate: StHeaderPanel)
		number: 2;
		label: 'Inspector'.

	inspector := self newPresenterSelector
		when: [ :aBinding | aBinding isNotNil ] show: [ :aBinding | 
			self flag: #TODO. "Temporal? This is to avoid a dependency (while making 
			inspector work properly)"
			self class environment 
				at: #StInspectorPresenter
				ifPresent: [ :aClass | self newInspectorWithTransmission: aClass on: aBinding ]
				ifAbsent: [ self newCodeWithTransmissionOn: aBinding ] ];
		when: [ :aBinding | aBinding isNil ] show: [ 
			bindingList items
				ifNotEmpty: [ self class unselectedMessage asPresenter ]
				ifEmpty: [ self class emptyMessage asPresenter ] ];
		updatePresenter.

	inspectorPanel presenter: inspector
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> initializeListPanel [

	bindingPanel := (self instantiate: StHeaderPanel)
		number: 1;
		label: 'Bindings';
		toolbarActions: self toolbarActions.
		
	bindingList := self newTable
		addColumn: (SpStringTableColumn new 
			title: 'Name';
			evaluated: [ :each | each key ]; 
			beSortable;
			yourself);
		addColumn: (SpStringTableColumn new  
			title: 'Scope';
			evaluated: [ :each | self scopeNameFor: each ];
			beSortable;
			yourself);
	   actions: self contextMenuActions;
		yourself.
	
	bindingPanel presenter: bindingList
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> initializePresenters [

	self initializeListPanel.
	self initializeInspectorPanel.
	
	bindingList transmitTo: inspector.

]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		initialExtent: self class defaultExtent
]

{ #category : 'testing' }
StPlaygroundBindingsPresenter >> isLocalBinding: aBinding [

	^ (self application sharedBindings includesKey: aBinding key) not
]

{ #category : 'private' }
StPlaygroundBindingsPresenter >> moveSelectedBindingToLocalScope [
	| selection |
		
	selection := self selectedBinding.
	parent interactionModel makeBindingLocal: selection
]

{ #category : 'private' }
StPlaygroundBindingsPresenter >> moveSelectedBindingToSharedScope [
	| selection |
		
	selection := self selectedBinding.
	parent interactionModel makeBindingShared: selection
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> newCodeWithTransmissionOn: aBinding [
	
	^ self newCode 
		text: aBinding value printString;
		beNotEditable;
		withoutSyntaxHighlight;
		withoutLineNumbers; 
		yourself
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> newInspectorWithTransmission: aClass on: aBinding [
	
	^ self 
		instantiate: aClass 
		on: aBinding value
]

{ #category : 'actions' }
StPlaygroundBindingsPresenter >> removeAllBindings [
	
	parent removeAllBindings.
	self updatePresenterKeepingSelection
]

{ #category : 'actions' }
StPlaygroundBindingsPresenter >> removeSelectedBinding [

	self selectedBindingIsLocal 
		ifTrue: [ parent interactionModel removeBinding: self selectedBinding ]
		ifFalse: [ self application removeSharedBinding: self selectedBinding ].
	self updatePresenterKeepingSelection
]

{ #category : 'private' }
StPlaygroundBindingsPresenter >> scopeNameFor: aBinding [

	^ self application sharedBindings
		at: aBinding key
		ifPresent: [ :found | 'shared' ]
		ifAbsent: [ 'local' ]
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter >> selectedBinding [

	^ bindingList ifNotNil: [ bindingList selection selectedItem ]
]

{ #category : 'testing' }
StPlaygroundBindingsPresenter >> selectedBindingIsLocal [
	| selection |

	selection := self selectedBinding.
	selection ifNil: [ ^ false ].
	
	^ self isLocalBinding: selection
]

{ #category : 'accessing - model' }
StPlaygroundBindingsPresenter >> setModelBeforeInitialization: aPlayground [

	parent := aPlayground
]

{ #category : 'accessing' }
StPlaygroundBindingsPresenter >> sortedBindingAssociations [

	^ self bindings associations sort: [ :a | self isLocalBinding: a ] ascending
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> title [

	parent withWindowDo: [ :w | 
		^ 'Bindings for {1}' format: { w title } ].
	^ self class defaultTitle
]

{ #category : 'actions' }
StPlaygroundBindingsPresenter >> toggleSelectedBindingScope [

	self selectedBindingIsLocal 
		ifTrue: [ self moveSelectedBindingToSharedScope ]
		ifFalse: [ self moveSelectedBindingToLocalScope ].
	self updatePresenterKeepingSelection
]

{ #category : 'private' }
StPlaygroundBindingsPresenter >> toolbarActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (StRemoveAllBindingsCommand forSpecContext: self);
		yourself
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> updatePresenter [
	
	self updatePresenterWithSelection: [
		bindingList selectIndex: 1 ]
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> updatePresenterKeepingSelection [
	| selection |
	
	selection := self selectedBinding.
	self updatePresenterWithSelection: [ 
		bindingList selectItem: ((bindingList items includes: selection) 
			ifTrue: [ selection ]
			ifFalse: [ bindingList items first ]) ]
]

{ #category : 'initialization' }
StPlaygroundBindingsPresenter >> updatePresenterWithSelection: aBlock [
	| newBindings oldBindings |

	newBindings := self sortedBindingAssociations. 
	oldBindings := bindingList items.
	"I re-set the items even if they are the same because I want to force a refresh"	
	bindingList items: newBindings.
	newBindings = oldBindings ifTrue: [ ^ self ].
	newBindings ifNotEmpty: aBlock
]
