"
A raw inspection is the basic inspection over any object of the system. 
It will show the variables the object is composed of and it will allow dive into and editing of them.
"
Class {
	#name : 'StRawInspectionPresenter',
	#superclass : 'StInspectionPresenter',
	#instVars : [
		'attributeTable',
		'mementoNodes'
	],
	#category : 'NewTools-Inspector-View',
	#package : 'NewTools-Inspector',
	#tag : 'View'
}

{ #category : 'commands' }
StRawInspectionPresenter class >> buildCommandsGroupWith: presenter forRoot: aCmCommandsGroup [
	aCmCommandsGroup
		beDisplayedAsGroup;
		register: (StInspectorInspectSelectedCommand forSpecContext: presenter);
		register: (StInspectorBrowseSelectedCommand forSpecContext: presenter);
		register: (SpBrowsePointersToCommand forSpecContext: presenter)
]

{ #category : 'accessing' }
StRawInspectionPresenter class >> label [

	^ 'Raw'
]

{ #category : 'api' }
StRawInspectionPresenter >> activateOnDoubleClick [

	attributeTable activateOnDoubleClick
]

{ #category : 'api' }
StRawInspectionPresenter >> activateOnSingleClick [

	attributeTable activateOnSingleClick
]

{ #category : 'building' }
StRawInspectionPresenter >> addValuesColumn [

	attributeTable addColumn: self valuesColumn
]

{ #category : 'building' }
StRawInspectionPresenter >> addVariablesColumn [

	attributeTable addColumn: self variablesColumn
]

{ #category : 'layout' }
StRawInspectionPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom 
		add: attributeTable;
		yourself
]

{ #category : 'ports' }
StRawInspectionPresenter >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : 'testing' }
StRawInspectionPresenter >> enableSlotMenuEntries [
	^ self selectedItem class == StInspectorSlotNode
]

{ #category : 'testing' }
StRawInspectionPresenter >> hasOutputActivationPort [

	^ true
]

{ #category : 'initialization' }
StRawInspectionPresenter >> initializePresenters [

	attributeTable := self newTreeTable
		addStyle: 'stTree';
		beResizable;
		actions: self rootCommandsGroup;
		dragEnabled: true;
		whenDragStartDo: [ :announcement |
			announcement transfer description: announcement transfer passenger first stringValue ];
		wantsDrop: [ :transfer |
			transfer target notNil and: [
				transfer target canSave and: [
					transfer passenger isArray and: [
						transfer passenger size = 1 and: [
							transfer passenger first isKindOf: StInspectorNode ] ] ] ] ];
		acceptDrop: [ :transfer |
			| value |
			value := transfer passenger first value.
			transfer target save: (transfer shouldCopy ifTrue: [ value copy ] ifFalse: [ value ]).
			self step ];
		yourself.
	self addVariablesColumn.
	self addValuesColumn.
	self setAttributeTable
]

{ #category : 'accessing' }
StRawInspectionPresenter >> inspectorNodes [

	^ self model allInspectorNodes
]

{ #category : 'accessing - model' }
StRawInspectionPresenter >> model: aModel [

	super model: aModel.
	self setAttributeTable
]

{ #category : 'ports' }
StRawInspectionPresenter >> outputActivationPort [
	
	^ (SpActivationPort newPresenter: self) 
		delegateTo: [ attributeTable ];
		yourself
]

{ #category : 'ports' }
StRawInspectionPresenter >> outputSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ attributeTable ];
		yourself
]

{ #category : 'accessing' }
StRawInspectionPresenter >> selectFirst [

	self selectPath: #(1)
]

{ #category : 'accessing' }
StRawInspectionPresenter >> selectPath: aPath [

	attributeTable selectPath: aPath
]

{ #category : 'accessing' }
StRawInspectionPresenter >> selectedItem [

	^ attributeTable selectedItem
]

{ #category : 'accessing' }
StRawInspectionPresenter >> selectedObject [

	^ attributeTable selectedItem value
]

{ #category : 'accessing' }
StRawInspectionPresenter >> selectedPath [

	^ attributeTable selection selectedPath
]

{ #category : 'building' }
StRawInspectionPresenter >> setAttributeTable [

	attributeTable children: [ :node | node children ]
]

{ #category : 'stepping' }
StRawInspectionPresenter >> step [
	| rootNodes |

	rootNodes := self model allInspectorNodes.
	mementoNodes ifNil: [ 
		mementoNodes := rootNodes collect: #mementoValue.
		^ self ].
	(rootNodes collect: #value) = mementoNodes ifTrue: [ ^ self ].

	mementoNodes := rootNodes collect: #mementoValue.
	attributeTable updateRootsKeepingSelection: rootNodes
]

{ #category : 'building' }
StRawInspectionPresenter >> updatePresenter [

	attributeTable roots: self inspectorNodes
]

{ #category : 'building' }
StRawInspectionPresenter >> valuesColumn [

	^ SpStringTableColumn new
		title: 'Value';
		evaluated: #stringValue;
		"beEditable;"
		onAcceptEdition: [ :node :value | 
			self inform: node label , '=' , value asString	"node value: value" ];
		sortFunction: #stringValue ascending;
		yourself
]

{ #category : 'building' }
StRawInspectionPresenter >> variablesColumn [

	^ SpCompositeTableColumn new
		title: 'Variable';
		width: 170;
		addColumn: (SpImageTableColumn new
			beNotExpandable;
			evaluated: [ :aNode | self iconNamed: aNode iconName ];
			yourself);
		addColumn: (SpStringTableColumn new
			evaluated: [ :aNode | aNode label ];
			yourself);
		sortFunction: #label ascending;
		yourself
]
