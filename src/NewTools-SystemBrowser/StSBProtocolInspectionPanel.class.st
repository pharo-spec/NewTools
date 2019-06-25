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
StSBProtocolInspectionPanel >> defineInputPorts [

	^ { 
	SpListItemsPort newDelegate: [ self protocolList ].
	SpListItemsPort newName: 'method-items' delegate: [ self methodList ]
	}
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> defineOutputPorts [

	^ { 
	SpListSelectionPort newDelegate: [ self methodList ].
	SpListSelectionPort newName: #'protocol-selection' delegate: [ self protocolList ]. 
	}
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> initializeWidgets [
	
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

{ #category : #accessing }
StSBProtocolInspectionPanel >> methodList [
	^ methodList
]

{ #category : #accessing }
StSBProtocolInspectionPanel >> protocolList [
	^ protocolList
]
