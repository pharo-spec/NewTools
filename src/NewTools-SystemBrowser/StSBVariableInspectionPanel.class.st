Class {
	#name : #StSBVariableInspectionPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'methodList',
		'variableList'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSBVariableInspectionPanel class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		add: #variableList;
		add: #methodList;
		yourself
]

{ #category : #initialization }
StSBVariableInspectionPanel >> defineInputPorts [

	^ { 
	SpListItemsPort newDelegate: [ self variableList ].
	SpListItemsPort newName: 'method-items' delegate: [ self methodList ] 
	}	
]

{ #category : #initialization }
StSBVariableInspectionPanel >> defineOutputPorts [

	^ { 
	SpListSelectionPort newDelegate: [ self methodList ].
	SpListSelectionPort newName: #'variable-selection' delegate: [ self variableList ]
	}
]

{ #category : #initialization }
StSBVariableInspectionPanel >> initializeWidgets [
	
	variableList := self newTable 
		hideColumnHeaders;
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
	methodList := self newTable
		hideColumnHeaders;
		addColumn: (SpStringTableColumn evaluated: #name);
		yourself.
		
	variableList transmitTo: methodList transform: #methods.
	"clean methods when changing variables"
	variableList whenModelChangedDo: [ methodList items: #() ].	
]

{ #category : #accessing }
StSBVariableInspectionPanel >> methodList [
	^ methodList
]

{ #category : #accessing }
StSBVariableInspectionPanel >> variableList [
	^ variableList
]
