Class {
	#name : #StSBProtocolInspectionPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'protocolList',
		'methodList'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSBProtocolInspectionPanel class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		add: #protocolList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> defaultInputPort [

	^ self inputItemsPort
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> initializePresenters [
	
	protocolList := self newTable 
		hideColumnHeaders;
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
	methodList := self newTable
		hideColumnHeaders;
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
	
	protocolList transmitTo: methodList transform: #methods.
	"clean methods when changing protocols"
	protocolList whenModelChangedDo: [ methodList items: #() ].
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> inputItemsPort [

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ self protocolList ];
		yourself
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> inputMethodItemsPort [

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ self methodList ];
		yourself
]

{ #category : #accessing }
StSBProtocolInspectionPanel >> methodList [
	^ methodList
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> outputProtocolSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ self protocolList ];
		yourself
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> outputSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ self methodList ];
		yourself
]

{ #category : #accessing }
StSBProtocolInspectionPanel >> protocolList [
	^ protocolList
]
