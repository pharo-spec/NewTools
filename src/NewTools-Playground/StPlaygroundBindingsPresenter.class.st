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
		yourself
]

{ #category : #private }
StPlaygroundBindingsPresenter >> contextMenuKeyBindings [

	^ self contextMenuActions asKMCategory
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

	bindingList := self newList
		display: [ :each | each key ];
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
				ifNotEmpty: [ self class unselectedMessage ]
				ifEmpty: [ self class emptyMessage ] ];
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

{ #category : #'accessing model' }
StPlaygroundBindingsPresenter >> setModelBeforeInitialization: anObject [

	playground := anObject
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> title [

	playground withWindowDo: [ :w | 
		^ 'Bindings for {1}' format: { w title } ].
	^ self class defaultTitle
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> updatePresenter [
	| newBindings oldBindings |

	newBindings := self bindings associations. 
	oldBindings := bindingList items.
	newBindings = oldBindings ifTrue: [ ^ self ].
	
	bindingList items: newBindings.
	newBindings ifNotEmpty: [ 
		bindingList selectIndex: 1 ]
]
