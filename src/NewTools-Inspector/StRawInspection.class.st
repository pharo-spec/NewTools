Class {
	#name : #StRawInspection,
	#superclass : #StInspection,
	#instVars : [
		'attributeTable'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StRawInspection class >> defaultSpec [

	^ SpBoxLayout newVertical 
		add: #attributeTable;
		yourself
]

{ #category : #specs }
StRawInspection class >> title [
	^ 'Raw'
]

{ #category : #building }
StRawInspection >> addValuesColumn [
	attributeTable addColumn: self valuesColumn
]

{ #category : #building }
StRawInspection >> addVariablesColumn [
	attributeTable addColumn: self variablesColumn
]

{ #category : #initialization }
StRawInspection >> initializeWidgets [
	attributeTable := self newTreeTable.
	self addVariablesColumn.
	self addValuesColumn.
	self setAttributeTable
]

{ #category : #accessing }
StRawInspection >> inspectorNodes [
	^ self model allInspectorNodes
]

{ #category : #building }
StRawInspection >> setAttributeTable [
	attributeTable
		roots: self inspectorNodes;
		children: [ :node | node children ]
]

{ #category : #building }
StRawInspection >> valuesColumn [
	^ SpStringTableColumn new
		title: 'Value';
		evaluated: #stringValue;
		beEditable;
		onAcceptEdition:
				[ :node :value | self inform: node label , '=' , value asString	"node value: value" ];
		yourself
]

{ #category : #building }
StRawInspection >> variablesColumn [
	^ SpCompositeTableColumn new
		title: 'Variable';
		width: 170;
		addColumn:
			(SpImageTableColumn new
				width: 20;
				evaluated: #icon;
				yourself);
		addColumn:
			(SpStringTableColumn new
				evaluated: #label;
				yourself);
		yourself
]
