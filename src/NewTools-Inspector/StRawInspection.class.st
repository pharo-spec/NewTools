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

	^ SpecBoxLayout newVertical 
		add: #attributeTable;
		yourself
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
StRawInspection >> initialize [ 

	super initialize.
	self title: 'Raw'
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
	^ StringTableColumn new
		title: 'Value';
		evaluated: #stringValue;
		beEditable;
		onAcceptEdition:
				[ :node :value | self inform: node label , '=' , value asString	"node value: value" ];
		yourself
]

{ #category : #building }
StRawInspection >> variablesColumn [
	^ CompositeTableColumn new
		title: 'Variable';
		width: 170;
		addColumn:
			(ImageTableColumn new
				width: 20;
				evaluated: #icon;
				yourself);
		addColumn:
			(StringTableColumn new
				evaluated: #label;
				yourself);
		yourself
]
