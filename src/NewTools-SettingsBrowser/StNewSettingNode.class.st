Class {
	#name : 'StNewSettingNode',
	#superclass : 'Object',
	#instVars : [
		'setting',
		'tree',
		'matchBlock'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StNewSettingNode class >> forSetting: aSetting [

	^ self new
		setting: aSetting;
		yourself
]

{ #category : 'accessing' }
StNewSettingNode >> allChildren [

	"Answer a <Collection> of the settings for which the receiver is set as parent"

	^ tree
		ifNotNil: [ :settingTree | settingTree childrenOf: self ]
		ifNil: [ OrderedCollection new ]
]

{ #category : 'converting' }
StNewSettingNode >> asPresenterOn: aPresenter [ 
	^ setting asSettingPresenterWithOwner: aPresenter 
]

{ #category : 'accessing' }
StNewSettingNode >> description [
	"Answer a <String> representing an human-understandable description"

	^ setting description
]

{ #category : 'testing' }
StNewSettingNode >> hasChildren [
	
	^ setting isGroup and: [ self allChildren isNotEmpty]
]

{ #category : 'testing' }
StNewSettingNode >> hasParent [ 

	^ setting hasParent
]

{ #category : 'accessing' }
StNewSettingNode >> label [
	
	^ setting label
]

{ #category : 'accessing' }
StNewSettingNode >> level [
	
	^ self path size
]

{ #category : 'accessing' }
StNewSettingNode >> matchBlock [

	^ matchBlock
		ifNil: [ 
			matchBlock := [ : node : pattern | 
				node label substrings anySatisfy: [ : substr |
					substr asLowercase beginsWith: pattern asLowercase ] ] ]
]

{ #category : 'testing' }
StNewSettingNode >> matches: aString [
	"Recursive search the receiver for aString in its label"

	| result |
	result := OrderedCollection new.
	self allChildren do: [ :node |
		(self matchBlock value: node value: aString) ifTrue: [ 
			result add: node ].

		node hasChildren ifTrue: [
			result addAll: (node matches: aString) ] ].

	^ result
]

{ #category : 'accessing' }
StNewSettingNode >> name [
	
	^ setting name
]

{ #category : 'accessing' }
StNewSettingNode >> nodeForGroup: aSettingGroup [

	^ tree nodeForSetting: aSettingGroup
]

{ #category : 'accessing' }
StNewSettingNode >> order [
	^ setting order
]

{ #category : 'accessing' }
StNewSettingNode >> order: anInteger [ 

	setting order: anInteger.
]

{ #category : 'accessing' }
StNewSettingNode >> parentName [
	
	^ setting parent ifNotNil: [ :group | group name ]
]

{ #category : 'accessing' }
StNewSettingNode >> parentNode [
	
	^ setting parent ifNotNil: [ :group | self nodeForGroup: group ]
]

{ #category : 'accessing' }
StNewSettingNode >> path [

	^ self hasParent
		ifTrue: [ self parentNode path, { self } ]
		ifFalse: [ { self } ]
]

{ #category : 'accessing' }
StNewSettingNode >> setting [
	^ setting
]

{ #category : 'accessing' }
StNewSettingNode >> setting: aSetting [

	setting := aSetting
]

{ #category : 'accessing' }
StNewSettingNode >> settingDeclaration [
	
	^ setting
]

{ #category : 'accessing' }
StNewSettingNode >> tree: aSettingTree [

	tree := aSettingTree 
]
