Class {
	#name : 'StSettingTreeBuilder',
	#superclass : 'SettingTreeBuilder',
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

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
	^ (SettingNodeBuilder new) node: node; builder: self; yourself
]
