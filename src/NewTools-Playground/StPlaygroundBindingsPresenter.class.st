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
StPlaygroundBindingsPresenter >> bindings [

	^ playground bindings
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
		yourself.

	self flag: #TODO. "Temporal? This is to avoid a dependency (while making inspector work 
	properly)"
	inspector := self class environment 
		at: #StInspector
		ifPresent: [ :aClass | self newInspectorWithTransmission: aClass ]
		ifAbsent: [ self newCodeWithTransmission ].

	self updatePresenter
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self title;
		initialExtent: self class defaultExtent
]

{ #category : #'private factory' }
StPlaygroundBindingsPresenter >> newBindingPresenter: anAssociation [

	^ StPlaygroundBindingPresenter on: anAssociation
]

{ #category : #'private factory' }
StPlaygroundBindingsPresenter >> newBindingPresenterList [

	^ self bindings associations collect: [ :eachAssoc |
		self newBindingPresenter: eachAssoc ]
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> newCodeWithTransmission [
	| presenter |
	
	presenter := self newCode 
		beNotEditable;
		withoutSyntaxHighlight;
		withoutLineNumbers.
	bindingList 
		transmitTo: presenter
		transform: [ :anAssociation | 
			anAssociation 
				ifNotNil: [ anAssociation value printString ]
				ifNil: [ '' ] ].
	
	^ presenter
]

{ #category : #initialization }
StPlaygroundBindingsPresenter >> newInspectorWithTransmission: aClass [
	| presenter |
	
	presenter := self instantiate: aClass.
	bindingList 
		transmitTo: presenter
		transform: [ :anAssociation | 
			anAssociation ifNotNil: [ anAssociation value ] ].
		
	^ presenter
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

	bindingList items: self bindings associations
]
