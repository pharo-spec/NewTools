"
Used to build nodes from the settings framework
"
Class {
	#name : 'StSettingNodeBuilder',
	#superclass : 'Object',
	#instVars : [
		'node',
		'builder',
		'callback'
	],
	#category : 'NewTools-SettingsBrowser',
	#package : 'NewTools-SettingsBrowser'
}

{ #category : 'private - tree building' }
StSettingNodeBuilder >> asParentWhile: aBlock [
	builder parent: self while: aBlock
]

{ #category : 'accessing' }
StSettingNodeBuilder >> builder: aTreeBuilder [
	builder := aTreeBuilder
]

{ #category : 'accessing' }
StSettingNodeBuilder >> buttonLabel: aString [ 
	"Set the current's node declaration button label to aString"

	node item actionLabel: aString
]

{ #category : 'accessing' }
StSettingNodeBuilder >> callback: aFullBlockClosure [ 

	callback := aFullBlockClosure 
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> default: anObject [
	node item  default: anObject
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> description: aText [
	node item description: aText
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> dialog: aSymbol [
	node item dialog: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> domainValues: aCollection [
	node item domainValues: aCollection
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> getSelector: aSymbol [
	node item getSelector: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> ghostHelp: aString [
	node item ghostHelp: aString
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> icon: aForm [
	node item icon: aForm
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> iconName: aSymbol [
	self icon: (self iconNamed: aSymbol)
]

{ #category : 'accessing' }
StSettingNodeBuilder >> isTransient: aBoolean [

	node item isTransient: aBoolean
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> label: aString [
	node item label: aString
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> name [
	^ node item name
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> name: aString [
	node item name: aString
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> noOrdering [
	node item noOrdering
]

{ #category : 'accessing' }
StSettingNodeBuilder >> node [
	^ node
]

{ #category : 'accessing' }
StSettingNodeBuilder >> node: aSettingTreeNode [
	node := aSettingTreeNode
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> order: aNumber [
	node item order: aNumber
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> parent: aSymbol [
	node parentName: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> parentName [
	^ node parentName
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> parentName: aSymbol [
	node parentName: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> precondition: aValuable [
	node item precondition: aValuable
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> range: anInterval [
	node item range: anInterval
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> script: aSymbol [
	node item script: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> selector: aSymbol [
	node item selector: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> setSelector: aSymbol [
	node item setSelector: aSymbol
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> target: anObject [
	node item target: anObject
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> targetSelector: aSelector [
	node item targetSelector: aSelector
]

{ #category : 'declaration accessing' }
StSettingNodeBuilder >> type: anObject [
	node item type: anObject
]

{ #category : 'tree building' }
StSettingNodeBuilder >> with: aBlock [
	self asParentWhile: aBlock
]
