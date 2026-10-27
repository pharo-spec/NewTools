"
I am the model of the settings browser: I build the settings declared with <systemsettings> with a SettingsManager and wrap each of them in a StNewSettingNode.
"
Class {
	#name : 'StNewSettingsTree',
	#superclass : 'Object',
	#instVars : [
		'manager',
		'nodeList'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'accessing' }
StNewSettingsTree >> childrenOf: aNode [
	"Answer the nodes of the settings of the group of aNode"

	| children |
	children := self nodeList select: [ :each | each setting parent == aNode setting ].
	self completeOrdersOf: children.
	^ children
]

{ #category : 'private' }
StNewSettingsTree >> completeOrdersOf: nodes [
	"Give an order to the nodes without one, so that they keep their position among the nodes with an order"

	| firstOrderedIndex |
	firstOrderedIndex := nodes findFirst: [ :each | each order isNotNil ].
	firstOrderedIndex = 0 ifTrue: [ ^ self ].

	self orderNodesBefore: firstOrderedIndex in: nodes.
	self orderUnorderedNodesAfter: firstOrderedIndex in: nodes
]

{ #category : 'accessing' }
StNewSettingsTree >> defaultCategories [
	"Answer a <Collection> of <StSettingNode> representing the default main setting categories in the system"

	^ self treeRoots
]

{ #category : 'testing' }
StNewSettingsTree >> hasSettingsFile [ 

	^ manager isNotNil
		and: [ manager settingsFile isNotNil
		and: [ manager settingsFile exists ] ]
]

{ #category : 'instance creation' }
StNewSettingsTree >> newSettingTreeBuilderNodes [
	"Walk over the receiver's pragmas. Build and answer an <Array> of <StSettingNode>, each one representing a specific setting"

	manager := SettingsManager forPragmaNamed: #systemsettings.
	manager useDefaultPreferencesFile.

	nodeList := manager settings collect: [ :setting | setting asSettingNode ].
	nodeList do: [: node | node tree: self ].
	^ nodeList 
]

{ #category : 'accessing' }
StNewSettingsTree >> nodeForSetting: aSetting [

	^ nodeList detect: [ :node | node setting == aSetting ]
]

{ #category : 'accessing' }
StNewSettingsTree >> nodeList [

	^ nodeList ifNil: [ nodeList := self newSettingTreeBuilderNodes ]
]

{ #category : 'accessing' }
StNewSettingsTree >> nodeList: aCollection [ 

	nodeList := aCollection
]

{ #category : 'private' }
StNewSettingsTree >> orderNodesBefore: anIndex in: nodes [
	"Each node before the one at anIndex gets the order of the node after it, minus 1"

	anIndex - 1 to: 1 by: -1 do: [ :index |
		(nodes at: index) order: (nodes at: index + 1) order - 1 ]
]

{ #category : 'private' }
StNewSettingsTree >> orderUnorderedNodesAfter: anIndex in: nodes [
	"Each node after the one at anIndex without an order gets the order of the node before it, plus 1"

	anIndex + 1 to: nodes size do: [ :index |
		(nodes at: index) order ifNil: [
			(nodes at: index) order: (nodes at: index - 1) order + 1 ] ]
]

{ #category : 'accessing' }
StNewSettingsTree >> persistence [

	^ manager
]

{ #category : 'private - queries' }
StNewSettingsTree >> processSearch: aString [
	"Recursively collect the nodes matching aString in the receiver"

	^ self treeRoots 
		flatCollect: [ : settingNode | settingNode matches: aString ]
		as: Set
]

{ #category : 'accessing' }
StNewSettingsTree >> settingsFileDirectory [

	^ manager settingsFile parent
]

{ #category : 'testing' }
StNewSettingsTree >> settingsFileReference [
	"Answer a <String> with the name of the file where settings are stored"

	^ manager settingsFile 
]

{ #category : 'accessing' }
StNewSettingsTree >> sortBlock [
	"Sort nodes by setting order, then by label. Nodes with an order come first"

	^ [ :a :b |
	  | orderA orderB |
	  orderA := a setting order.
	  orderB := b setting order.
	  (orderA isNotNil and: [ orderB isNotNil and: [ orderA ~= orderB ] ])
		  ifTrue: [ orderA < orderB ]
		  ifFalse: [
			  orderA = orderB
				  ifTrue: [ a setting label < b setting label ]
				  ifFalse: [ orderA isNotNil ] ] ]
]

{ #category : 'instance creation' }
StNewSettingsTree >> treeRoots [
	"Answer an array of <StSettingNode> representing the main setting categories in the system"

	^ (self nodeList reject: #hasParent) asArray sort: self sortBlock
]
