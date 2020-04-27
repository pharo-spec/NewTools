"
I am a presenter to show all bindings of parent Playground.
I show a list of active bindings. 
A panel to inspect each of the bindings values is shown too.
"
Class {
	#name : #StPlaygroundBindingsPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'bindingList',
		'playground',
		'inspector'
	],
	#category : #'NewTools-Playground-View'
}

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> defaultExtent [

	^ 600@400
]

{ #category : #specs }
StPlaygroundBindingsPresenter class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		position: 30 percent;
		add: #bindingList;
		add: #inspector;
		yourself
]

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> defaultTitle [

	^ 'Bindings'
]

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> emptyMessage [

	^ 'There are no bindings to list.'
]

{ #category : #accessing }
StPlaygroundBindingsPresenter class >> unselectedMessage [

	^ 'Select a variable to inspect its value.'
]

{ #category : #accessing }
StPlaygroundBindingsPresenter >> bindings [

	^ playground bindings
]

{ #category : #private }
StPlaygroundBindingsPresenter >> contextMenu [

	^ self contextMenuActions asMenuPresenter
]

{ #category : #private }
StPlaygroundBindingsPresenter >> contextMenuActions [

	^ CmCommandGroup forSpec
		beRoot;
		register: (StRemoveBindingCommand forSpecContext: self);
		register: (StMoveBindingCommand forSpecContext: self);
		yourself
]

{ #category : #private }
StPlaygroundBindingsPresenter >> contextMenuKeyBindings [

	^ self contextMenuActions asKMCategory
]

{ #category : #testing }
StPlaygroundBindingsPresenter >> hasSelectedBinding [

	^ self selectedBinding notNil
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializeDialogWindow: aDialogWindowPresenter [

	aDialogWindowPresenter 
		centeredRelativeTo: playground window;
		addButton: 'Close' do: [ :presenter | 
			presenter triggerOkAction.
			presenter close ]
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializePresenters [

	bindingList := self newTable
		addColumn: (SpStringTableColumn title: 'Name' evaluated: [ :each | each key ]);
		addColumn: (SpStringTableColumn 
			title: 'Scope' 
			evaluated: [ :each | self scopeNameFor: each ]) 
			beNotExpandable;
		contextMenu: [ self contextMenu ];
		contextKeyBindings: self contextMenuKeyBindings;
		yourself.

	inspector := self newPresenterSelector
		when: [ :aBinding | aBinding notNil ] show: [ :aBinding | 
			self flag: #TODO. "Temporal? This is to avoid a dependency (while making 
			inspector work properly)"
			self class environment 
				at: #StInspector
				ifPresent: [ :aClass | self newInspectorWithTransmission: aClass on: aBinding ]
				ifAbsent: [ self newCodeWithTransmissionOn: aBinding ] ];
		when: [ :aBinding | aBinding isNil ] show: [ 
			bindingList items
				ifNotEmpty: [ self class unselectedMessage asPresenter ]
				ifEmpty: [ self class emptyMessage asPresenter ] ];
		updatePresenter.
	
	bindingList transmitTo: inspector.
	
	self updatePresenter
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self title;
		initialExtent: self class defaultExtent
]

{ #category : #testing }
StPlaygroundBindingsPresenter >> isLocalBinding: aBinding [

	^ (self application sharedBindings includesKey: aBinding key) not
]

{ #category : #private }
StPlaygroundBindingsPresenter >> moveSelectedBindingToLocalScope [
	| selection |
		
	selection := self selectedBinding.
	self application removeSharedBinding: selection.
	playground addBinding: selection
]

{ #category : #private }
StPlaygroundBindingsPresenter >> moveSelectedBindingToSharedScope [
	| selection |
		
	selection := self selectedBinding.
	playground removeBinding: selection.
	self application addSharedBinding: selection
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> newCodeWithTransmissionOn: aBinding [
	
	^ self newCode 
		text: aBinding value printString;
		beNotEditable;
		withoutSyntaxHighlight;
		withoutLineNumbers; 
		yourself
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> newInspectorWithTransmission: aClass on: aBinding [
	
	^ self 
		instantiate: aClass 
		on: aBinding value
]

{ #category : #actions }
StPlaygroundBindingsPresenter >> removeSelectedBinding [

	self selectedBindingIsLocal 
		ifTrue: [ playground removeBinding: self selectedBinding ]
		ifFalse: [ self application removeSharedBinding: self selectedBinding ].
	self updatePresenterKeepingSelection
]

{ #category : #private }
StPlaygroundBindingsPresenter >> scopeNameFor: aBinding [

	^ self application sharedBindings
		at: aBinding key
		ifPresent: [ :found | 'shared' ]
		ifAbsent: [ 'local' ]
]

{ #category : #accessing }
StPlaygroundBindingsPresenter >> selectedBinding [

	^ bindingList ifNotNil: [ bindingList selection selectedItem ]
]

{ #category : #testing }
StPlaygroundBindingsPresenter >> selectedBindingIsLocal [
	| selection |

	selection := self selectedBinding.
	selection ifNil: [ ^ false ].
	
	^ self isLocalBinding: selection
]

{ #category : #'accessing model' }
StPlaygroundBindingsPresenter >> setModelBeforeInitialization: anObject [

	playground := anObject
]

{ #category : #accessing }
StPlaygroundBindingsPresenter >> sortedBindingAssociations [

	^ self bindings associations sort: [ :a | self isLocalBinding: a ] ascending
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> title [

	playground withWindowDo: [ :w | 
		^ 'Bindings for {1}' format: { w title } ].
	^ self class defaultTitle
]

{ #category : #actions }
StPlaygroundBindingsPresenter >> toggleSelectedBindingScope [

	self selectedBindingIsLocal 
		ifTrue: [ self moveSelectedBindingToSharedScope ]
		ifFalse: [ self moveSelectedBindingToLocalScope ].
	self updatePresenterKeepingSelection
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> updatePresenter [
	
	self updatePresenterWithSelection: [ 
		bindingList selectIndex: 1 ]
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> updatePresenterKeepingSelection [
	| selection |
	
	selection := self selectedBinding.
	self updatePresenterWithSelection: [ 
		bindingList selectItem: ((bindingList items includes: selection) 
			ifTrue: [ selection ]
			ifFalse: [ bindingList items first ]) ]
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> updatePresenterWithSelection: aBlock [
	| newBindings oldBindings |

	newBindings := self sortedBindingAssociations. 
	oldBindings := bindingList items.
	"I re-set the items even if they are the same because I want to force a refresh"	
	bindingList items: newBindings.
	newBindings = oldBindings ifTrue: [ ^ self ].
	newBindings ifNotEmpty: aBlock
]
