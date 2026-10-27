Class {
	#name : 'StSettingNode',
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
StSettingNode class >> forSetting: aSetting [

	^ self new
		setting: aSetting;
		yourself
]

{ #category : 'accessing' }
StSettingNode >> allChildren [

	"Answer a <Collection> of the settings for which the receiver is set as parent"

	^ tree
		ifNotNil: [ :settingTree | settingTree childrenOf: self ]
		ifNil: [ OrderedCollection new ]
]

{ #category : 'converting' }
StSettingNode >> asPresenterOn: aPresenter [ 
	^ setting asSettingPresenterWithOwner: aPresenter 
]

{ #category : 'accessing' }
StSettingNode >> description [
	"Answer a <String> representing an human-understandable description"

	^ setting description
]

{ #category : 'testing' }
StSettingNode >> hasChildren [
	
	^ setting isGroup and: [ self allChildren isNotEmpty]
]

{ #category : 'testing' }
StSettingNode >> hasParent [ 

	^ setting hasParent
]

{ #category : 'accessing' }
StSettingNode >> label [
	
	^ setting label
]

{ #category : 'accessing' }
StSettingNode >> level [
	
	^ self path size
]

{ #category : 'accessing' }
StSettingNode >> matchBlock [

	^ matchBlock
		ifNil: [ 
			matchBlock := [ : node : pattern | 
				node label substrings anySatisfy: [ : substr |
					substr asLowercase beginsWith: pattern asLowercase ] ] ]
]

{ #category : 'testing' }
StSettingNode >> matches: aString [
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
StSettingNode >> name [
	
	^ setting name
]

{ #category : 'accessing' }
StSettingNode >> nodeForGroup: aSettingGroup [

	^ tree nodeForSetting: aSettingGroup
]

{ #category : 'accessing' }
StSettingNode >> order [
	^ setting order
]

{ #category : 'accessing' }
StSettingNode >> order: anInteger [ 

	setting order: anInteger.
]

{ #category : 'accessing' }
StSettingNode >> parentName [
	
	^ setting parent ifNotNil: [ :group | group name ]
]

{ #category : 'accessing' }
StSettingNode >> parentNode [
	
	^ setting parent ifNotNil: [ :group | self nodeForGroup: group ]
]

{ #category : 'accessing' }
StSettingNode >> path [

	^ self hasParent
		ifTrue: [ self parentNode path, { self } ]
		ifFalse: [ { self } ]
]

{ #category : 'accessing' }
StSettingNode >> setting [
	^ setting
]

{ #category : 'accessing' }
StSettingNode >> setting: aSetting [

	setting := aSetting
]

{ #category : 'accessing' }
StSettingNode >> settingDeclaration [
	
	^ setting
]

{ #category : 'accessing' }
StSettingNode >> tree: aSettingTree [

	tree := aSettingTree 
]
