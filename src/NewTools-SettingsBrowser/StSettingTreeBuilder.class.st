"
A builder for the settings tree
"
Class {
	#name : 'StSettingTreeBuilder',
	#superclass : 'Object',
	#instVars : [
		'nodeList',
		'currentParent',
		'currentPragma'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StSettingTreeBuilder class >> acceptableKeywords: aCollectionOfRegExps [
	^ self new acceptableKeywords: aCollectionOfRegExps
]

{ #category : 'accessing' }
StSettingTreeBuilder >> buildPragma: aPragma [
	currentPragma := aPragma.
	self perform: aPragma selector withArguments: aPragma arguments.
	^ nodeList
]

{ #category : 'accessing - structure variables' }
StSettingTreeBuilder >> button: aSymbol [

	^ self nodeClass: ActionSettingDeclaration name: aSymbol
]

{ #category : 'tree building' }
StSettingTreeBuilder >> group: aSymbol [
	^ self nodeClass: PragmaSetting name: aSymbol
]

{ #category : 'accessing' }
StSettingTreeBuilder >> nodeClass [

	^ StSettingNode
]

{ #category : 'private - tree building' }
StSettingTreeBuilder >> nodeClass: aClass name: aSymbol [
	| node |
	node := self nodeClass with: aClass new.
	node item name: aSymbol.
	node pragma: currentPragma.
	node parentName: (currentParent ifNotNil: [currentParent name]).
	self nodeList add: node.
	^ (StSettingNodeBuilder new) node: node; builder: self; yourself
]

{ #category : 'accessing' }
StSettingTreeBuilder >> nodeList [
	^ nodeList ifNil: [nodeList := OrderedCollection new]
]

{ #category : 'private - tree building' }
StSettingTreeBuilder >> parent: aNode while: aBlock [
	| oldParent |
	oldParent := currentParent.
	currentParent := aNode.
	aBlock value.
	currentParent := oldParent
]

{ #category : 'tree building' }
StSettingTreeBuilder >> pickOne: aSymbol [
	^ self nodeClass: PickOneSettingDeclaration name: aSymbol
]

{ #category : 'tree building' }
StSettingTreeBuilder >> range: aSymbol [
	^ self nodeClass: RangeSettingDeclaration name: aSymbol
]

{ #category : 'tree building' }
StSettingTreeBuilder >> setting: aSymbol [
	^ self nodeClass: SettingDeclaration name: aSymbol
]

{ #category : 'pragmas' }
StSettingTreeBuilder >> systemsettings [
	"Process a <systemsettings> pragma"

	<settingPragmaProcessor>
	currentPragma methodClass instanceSide
		perform: currentPragma methodSelector
		with: self
]
