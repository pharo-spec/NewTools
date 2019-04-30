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

	^ SpecPanedLayout newHorizontal
		add: #protocolList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> defineInputPorts [

	^ { 
	SpecListItemsPort newDelegate: [ self protocolList ].
	SpecListItemsPort newName: 'method-items' delegate: [ self methodList ]
	}
]

{ #category : #initialization }
StSBProtocolInspectionPanel >> defineOutputPorts [

	^ { 
	SpecListSelectionPort newDelegate: [ self methodList ].
	SpecListSelectionPort newName: #'protocol-selection' delegate: [ self protocolList ]. 
	}
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
