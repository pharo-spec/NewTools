Class {
	#name : #StSBVariableInspectionPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'methodList',
		'variableList'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSBVariableInspectionPanel class >> defaultSpec [

	^ SpecPanedLayout newHorizontal
		add: #variableList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBVariableInspectionPanel >> initializePorts [

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
StSBVariableInspectionPanel >> initializeWidgets [
	
	variableList := self newTable 
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
	methodList := self newTable
		hideColumnHeaders;
		addColumn: (StringTableColumn evaluated: #name);
		yourself.
		
	variableList transmitTo: methodList transform: #methods
]

{ #category : #accessing }
StSBVariableInspectionPanel >> methodList [
	^ methodList
]

{ #category : #accessing }
StSBVariableInspectionPanel >> variableList [
	^ variableList
]
