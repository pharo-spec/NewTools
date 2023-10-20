Class {
	#name : 'StSBVariableInspectionPanel',
	#superclass : 'StSBPanel',
	#instVars : [
		'methodList',
		'variableList'
	],
	#category : 'NewTools-SystemBrowser-View',
	#package : 'NewTools-SystemBrowser',
	#tag : 'View'
}

{ #category : 'specs' }
StSBVariableInspectionPanel class >> defaultSpec [

	^ SpPanedLayout newHorizontal
		add: #variableList;
		add: #methodList;
		yourself
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> defaultInputPort [

	^ self inputItemsPort
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> initializePresenters [
	
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

{ #category : 'initialization' }
StSBVariableInspectionPanel >> inputItemsPort [

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ self variableList ];
		yourself
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> inputMethodItemsPort [

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ self methodList ];
		yourself
]

{ #category : 'accessing' }
StSBVariableInspectionPanel >> methodList [
	^ methodList
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> outputSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ self methodList ];
		yourself
]

{ #category : 'initialization' }
StSBVariableInspectionPanel >> outputVariableSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ self variableList ];
		yourself
]

{ #category : 'accessing' }
StSBVariableInspectionPanel >> variableList [
	^ variableList
]
