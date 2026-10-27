Class {
	#name : 'StNewSettingsTree',
	#superclass : 'SettingTree',
	#instVars : [
		'manager'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'opening' }
StNewSettingsTree class >> settingsKeywords [

	^ (Pragma allNamed: #systemsettings) collect: [: p | p method selector ]
]

{ #category : 'checking' }
StNewSettingsTree >> checkForUnknownTarget [
	"check only root because other nodes with unknown target inherits it from its parent"

	self treeRoots do: [ :node |
		node item target ifNil: [ node item target: (node pragma ifNotNil: [ :prg | prg methodClass instanceSide ]) ] ].
	self treeRoots do: [ :node | node checkForUnknownTarget ]
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

{ #category : 'instance creation' }
StNewSettingsTree >> newTreeHolder [
	"Set the receiver's collector to gather the system setting pragmas"

	^ self
		acceptableKeywords: { #systemsettings };
		nodeList: self nodeList;
		yourself
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

{ #category : 'instance creation' }
StNewSettingsTree >> settingsKeywords [

	^ self class settingsKeywords
]

{ #category : 'accessing' }
StNewSettingsTree >> sortBlock [
	^ [:a :b | self itemSortBlock value: a setting value: b setting ]
]

{ #category : 'instance creation' }
StNewSettingsTree >> treeRoots [
	"Answer an array of <StSettingNode> representing the main setting categories in the system"

	^ (self nodeList reject: #hasParent) asArray sort: self sortBlock
]
