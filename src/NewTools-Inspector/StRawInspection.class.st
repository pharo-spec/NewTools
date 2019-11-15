Class {
	#name : #StRawInspection,
	#superclass : #StInspection,
	#instVars : [
		'attributeTable',
		'mementoNodes'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StRawInspection class >> defaultSpec [

	^ SpBoxLayout newVertical 
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
StRawInspection >> attributesTableMenu [
	
	^ CmCommandGroup forSpec
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: self);
		register: (StInspectorBrowseSelectedCommand forSpecContext: self);
		asMenuPresenter
]

{ #category : #initialization }
StRawInspection >> defineOutputPorts [

	^ { 
	SpSelectionPort newDelegate: [ attributeTable ].
	SpActivationPort newDelegate: [ attributeTable ] }
]

{ #category : #initialization }
StRawInspection >> initialize [ 

	super initialize.
	
]

{ #category : #initialization }
StRawInspection >> initializePresenters [

	attributeTable := self newTreeTable
		contextMenu: self attributesTableMenu;
		yourself.
	self addVariablesColumn.
	self addValuesColumn.
	self setAttributeTable
]

{ #category : #accessing }
StRawInspection >> inspectorNodes [
	^ self model allInspectorNodes
]

{ #category : #'model access' }
StRawInspection >> model: aModel [

	super model: aModel.
	self setAttributeTable
]

{ #category : #accessing }
StRawInspection >> selectFirst [

	self selectPath: #(1)
]

{ #category : #accessing }
StRawInspection >> selectPath: aPath [

	attributeTable selectPath: aPath
]

{ #category : #accessing }
StRawInspection >> selectedItem [

	^ attributeTable selectedItem
]

{ #category : #accessing }
StRawInspection >> selectedObject [

	^ attributeTable selectedItem value
]

{ #category : #accessing }
StRawInspection >> selectedPath [

	^ attributeTable selection selectedPath
]

{ #category : #building }
StRawInspection >> setAttributeTable [

	attributeTable
		roots: self inspectorNodes;
		children: [ :node | node children ]
]

{ #category : #stepping }
StRawInspection >> step [
	| rootNodes selectedPath |

	rootNodes := self model allInspectorNodes.
	mementoNodes ifNil: [ 
		mementoNodes := rootNodes collect: #mementoValue.
		^ self ].
	(rootNodes collect: #value) = mementoNodes ifTrue: [ ^ self ].

	mementoNodes := rootNodes collect: #mementoValue.
	selectedPath := attributeTable selection selectedPath.
	attributeTable roots: rootNodes.
	selectedPath ifNotNil: [ 
		attributeTable selectPath: selectedPath ]
]

{ #category : #building }
StRawInspection >> valuesColumn [

	^ SpStringTableColumn new
		title: 'Value';
		evaluated: #stringValue;
		beEditable;
		onAcceptEdition: [ :node :value | 
			self inform: node label , '=' , value asString	"node value: value" ];
		sortFunction: #stringValue ascending;
		yourself
]

{ #category : #building }
StRawInspection >> variablesColumn [

	^ SpCompositeTableColumn new
		title: 'Variable';
		width: 170;
		addColumn: (SpImageTableColumn new
			beNotExpandable;
			evaluated: #icon;
			yourself);
		addColumn: (SpStringTableColumn new
			evaluated: #label;
			yourself);
		sortFunction: #label ascending;
		yourself
]
