Class {
	#name : #StSBProtocolInspectionPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'protocolList',
		'methodList'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSBProtocolInspectionPanel class >> defaultSpec [

	^ SpecPanedLayout newHorizontal
		add: #protocolList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> initializePorts [

	self addOutputPort: (ListSelectionPresenterPort new
		delegateTo: [ self methodList ];
		yourself).
	self addOutputPort: (ListSelectionPresenterPort new
		name: #'protocol-selection';
		delegateTo: [ self methodList ];
		yourself).
	self addInputPort: (ItemsPresenterPort new
		delegateTo: [ self protocolList ];
		yourself).
	self addInputPort: (ItemsPresenterPort new
		name: 'method-items';
		delegateTo: [ self protocolList ];
		yourself)	
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> initializeWidgets [
	
	protocolList := self newTable 
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
	methodList := self newTable
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
		
	protocolList transmitTo: methodList transform: #methods
]

{ #category : #accessing }
StSBProtocolInspectionPanel >> methodList [
	^ methodList
]

{ #category : #accessing }
StSBProtocolInspectionPanel >> protocolList [
	^ protocolList
]
