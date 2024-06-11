Class {
	#name : 'StSettingsTree',
	#superclass : 'SettingTree',
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'opening' }
StSettingsTree class >> settingsKeywords [

	^ (Pragma allNamed: #systemsettings) collect: [: p | p method selector ]
]

{ #category : 'accessing' }
StSettingsTree >> defaultCategories [
	"Answer a <Collection> of <StSettingNode> representing the default main setting categories in the system"

	^ self treeRoots.
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
		nodeList: self newSettingTreeBuilderNodes;
		yourself
]

{ #category : 'accessing' }
StSettingsTree >> nodeList: aCollection [ 

	nodeList := aCollection
]

{ #category : 'private - queries' }
StSettingsTree >> processSearch: aString on: aStSettingsToolbarPresenter [ 

	^ self treeRoots select: [ : settingNode |
		settingNode matches: aString ]
]

{ #category : 'instance creation' }
StSettingsTree >> settingsKeywords [

	^ self class settingsKeywords
]

{ #category : 'accessing' }
StSettingsTree >> sortBlock [
	^ [:a :b | self itemSortBlock value: a declaration value: b declaration ]
]

{ #category : 'instance creation' }
StSettingsTree >> treeRoots [
	"Answer a <Collection> of <StSettingNodePresenter> representing the main setting categories in the system"

	^ self newTreeHolder settingTreeRoots
]
