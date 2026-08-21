Class {
	#name : 'StSettingsTree',
	#superclass : 'Model',
	#instVars : [
		'collector',
		'nodeList',
		'persistence'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'opening' }
StSettingsTree class >> settingsKeywords [

	^ (Pragma allNamed: #systemsettings) collect: [: p | p method selector ]
]

{ #category : 'accessing' }
StSettingsTree >> acceptableKeywords: keywords [
	self collector
		selectors: keywords;
		filter: [:prg | prg methodClass isMeta].
	nodeList := nil.
	self collector reset
]

{ #category : 'checking' }
StSettingsTree >> checkForUnknownParent [
	self unclassified
		ifNotEmpty: [ :nodesWithUnknownParent |
			| builder g |
			builder := StSettingTreeBuilder new.
			g := (builder group: #nodesWithUnknownParent) node.
			self nodeList addFirst: g.
			g model: self.
			g item label: '*** Unclassified ***'.
			g item icon: (self iconNamed: #smallDebug).
			g item order: 0.0.
			nodesWithUnknownParent
				do: [ :node | node parentName: #nodesWithUnknownParent ] ]
]

{ #category : 'checking' }
StSettingsTree >> checkForUnknownTarget [
	"check only root because other nodes with unknown target inherits it from its parent"
	self settingTreeRoots do: [:node | node item target ifNil: [node item target: (node pragma ifNotNil: [:prg | prg methodClass instanceSide])]].
	self settingTreeRoots do: [:node | node checkForUnknownTarget]
]

{ #category : 'querying' }
StSettingsTree >> childrenOf: aNode [
	| children idx order |
	"Get aNode children. Assign children order if one child has an order which is not nil"
	children := self nodeList select: [ :p | p parentName = aNode settingDeclaration name ].
	children
		detect: [ :n | n order isNotNil ]
		ifFound: [ :firstWithOrder |
			idx := children indexOf: firstWithOrder.
			order := firstWithOrder order.
			idx > 1
				ifTrue: [
					idx - 1 to: 1 do: [ :pos |
						(children at: pos) order: order - 1.
						order := order - 1 ] ].
			order := firstWithOrder order.
			idx + 1 to: children size do: [ :pos |
				(children at: pos) order ifNil: [ (children at: pos) order: order + 1 ] ifNotNil: [ order := (children at: pos) order ].
				order := order + 1 ] ].
	^ children
]

{ #category : 'accessing' }
StSettingsTree >> collector [
	^ collector ifNil: [collector := PragmaCollector new]
]

{ #category : 'querying' }
StSettingsTree >> deeplyDetect: aBlock [
	self settingTreeRoots
		do: [:sub | (sub deeplyDetect: aBlock)
				ifNotNil: [:found | ^ found]].
	^ nil
]

{ #category : 'querying' }
StSettingsTree >> deeplySelect: aBlock [
	^ self deeplySelect: aBlock in: OrderedCollection new
]

{ #category : 'querying' }
StSettingsTree >> deeplySelect: aBlock in: aCollection [
	self settingTreeRoots
		do: [:aRoot | aRoot deeplySelect: aBlock in: aCollection].
	^ aCollection
]

{ #category : 'accessing' }
StSettingsTree >> defaultCategories [
	"Answer a <Collection> of <StSettingNode> representing the default main setting categories in the system"

	^ self treeRoots.
]

{ #category : 'private - tree building' }
StSettingsTree >> emptyNodeNamed: aSymbol [
	(self nodeNamed: aSymbol)
]

{ #category : 'testing' }
StSettingsTree >> hasSettingsFile [ 
	"Answer <true> if a system settings file exists"

	^ self persistence hasSettingsFile 
]

{ #category : 'accessing' }
StSettingsTree >> itemSortBlock [
	^ [:a :b |
		((a order isNotNil and: [b order isNotNil]) and: [a order ~= b order])
			ifTrue: [a order < b order]
			ifFalse: [((a order isNil and: [b order isNil]) or: [a order = b order])
				ifTrue: [a label < b label]
				ifFalse: [a order ifNil: [false] ifNotNil: [true]]]]
]

{ #category : 'instance creation' }
StSettingsTree >> newSettingTreeBuilderNodes [
	"Walk over the receiver's pragmas. Build and answer a <Collection> of <StSettingNode>, each one representing a specific setting"
	| builder |

	builder := StSettingTreeBuilder new.
	self pragmasDo: [ :p | builder buildPragma: p ].
	nodeList := builder nodeList.
	nodeList do: [: n | n model: self ].
	self checkForUnknownParent.
	self checkForUnknownTarget.
	^ nodeList 
]

{ #category : 'instance creation' }
StSettingsTree >> newTreeHolder [
	"Set the receiver's collector to gather the system setting pragmas"

	^ self
		acceptableKeywords: { #systemsettings };
		nodeList: self nodeList;
		yourself
]

{ #category : 'accessing' }
StSettingsTree >> nodeList [

	^ nodeList ifNil: [ nodeList := self newSettingTreeBuilderNodes ]
]

{ #category : 'accessing' }
StSettingsTree >> nodeList: aCollection [ 

	nodeList := aCollection
]

{ #category : 'private - tree building' }
StSettingsTree >> nodeNamed: aSymbol [
	^ self nodeNamed: aSymbol ifAbsent: []
]

{ #category : 'private - tree building' }
StSettingsTree >> nodeNamed: aSymbol ifAbsent: aBlock [
	^ self nodeList detect: [:d | d settingDeclaration name = aSymbol] ifNone: aBlock
]

{ #category : 'accessing' }
StSettingsTree >> persistence [
	^ persistence ifNil: [ persistence := SystemSettingsPersistence settingTree: self ]
]

{ #category : 'querying' }
StSettingsTree >> pragmasDo: aBlock [
	^  self collector do: aBlock
]

{ #category : 'private - queries' }
StSettingsTree >> processSearch: aString [
	"Recursively collect the nodes matching aString in the receiver"

	^ self treeRoots 
		flatCollect: [ : settingNode | settingNode matches: aString ]
		as: Set
]

{ #category : 'instance creation' }
StSettingsTree >> retainedNodesFromList: aListOfNodes [
	| retained |
	retained := OrderedCollection new.
	aListOfNodes do: [:n | [n item precondition value ifTrue: [retained add: n]] on: Error do: [retained add: n]].
	^ retained
]

{ #category : 'instance creation' }
StSettingsTree >> settingTreeRoots [
	^ self retainedNodesFromList: ((self nodeList select: [:n | n parentName isNil]) asArray sort: self sortBlock) asOrderedCollection
]

{ #category : 'testing' }
StSettingsTree >> settingsFileReference [
	"Answer a <String> with the name of the file where settings are stored"

	^ self persistence fileReference 
]

{ #category : 'instance creation' }
StSettingsTree >> settingsKeywords [

	^ self class settingsKeywords
]

{ #category : 'accessing' }
StSettingsTree >> sortBlock [
	^ [:a :b | self itemSortBlock value: a declaration value: b declaration ]
]

{ #category : 'persistence' }
StSettingsTree >> storeSettingNodes [
	self persistence storeSettingNodes
]

{ #category : 'instance creation' }
StSettingsTree >> treeRoots [
	"Answer a <Collection> of <StSettingNodePresenter> representing the main setting categories in the system"

	^ self newTreeHolder settingTreeRoots
]

{ #category : 'querying' }
StSettingsTree >> unclassified [
	^ self nodeList select: [:node | node parentName isNotNil and: [node parentNode isNil]]
]

{ #category : 'accessing' }
StSettingsTree >> updateList [
	nodeList := nil
]

{ #category : 'persistence' }
StSettingsTree >> updateSettingNodes [
	self persistence updateSettingNodes
]

{ #category : 'updating' }
StSettingsTree >> whenChangedSend: aSelector to: aTarget [
	self collector whenChangedSend: aSelector to: aTarget.
	self collector whenResetSend: aSelector to: aTarget
]
