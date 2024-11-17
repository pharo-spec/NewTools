"
Represents a single setting

"
Class {
	#name : 'StSettingNode',
	#superclass : 'Object',
	#instVars : [
		'declaration',
		'pragma',
		'parentName',
		'model',
		'matchBlock',
		'parentNode'
	],
	#category : 'NewTools-SettingsBrowser-Model',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StSettingNode class >> with: aPragmaSetting [ 

	^ self new declaration: aPragmaSetting
]

{ #category : 'accessing' }
StSettingNode >> allChildren [
	"Answer a <Collection> of the settings for which the receiver is set as parent"

	^ self model 
		ifNotNil: [ : m | m childrenOf: self ]
		ifNil: [ OrderedCollection new ]
]

{ #category : 'converting' }
StSettingNode >> asPresenter [
	"Answer a <SpPresenter> for the receiver's setting type"

	^ self declaration asSettingPresenter
]

{ #category : 'checking' }
StSettingNode >> checkForUnknownTarget [

	self parentNode 
		ifNotNil: [:p | 
			self declarationTarget 
				ifNil: [ self declarationTarget: p declaration target ].
			self declaration targetSelector 
				ifNil: [ self declaration targetSelector: p declaration targetSelector ] ].
	self allChildren do: [: c | c checkForUnknownTarget ]
]

{ #category : 'accessing' }
StSettingNode >> declaration [

	^ declaration
]

{ #category : 'initialization' }
StSettingNode >> declaration: aPragmaSetting [ 

	declaration := aPragmaSetting
]

{ #category : 'private' }
StSettingNode >> declarationDescriptions [
	"Answer a <Collection> of <String> each one a word in the receiver's description"
	
	^ self declaration description substrings collect: #asLowercase.
]

{ #category : 'accessing' }
StSettingNode >> declarationTarget [

	^ self declaration target
]

{ #category : 'accessing' }
StSettingNode >> declarationTarget: anObject [

	self declaration target: anObject
]

{ #category : 'private' }
StSettingNode >> description [ 
	"Answer a <String> representing an human-understandable description"
	
	^ self declaration description
]

{ #category : 'private' }
StSettingNode >> descriptors [
	"Answer a <Collection> of <String> each representing a receiver's textual description or identifier"
	
	^ (OrderedCollection withAll: self declarationDescriptions)
		add: self label asLowercase;
		yourself
]

{ #category : 'testing' }
StSettingNode >> hasChildren [

	^ self allChildren notEmpty
]

{ #category : 'testing' }
StSettingNode >> hasParent [

	^ parentName notNil
]

{ #category : 'accessing' }
StSettingNode >> item [

	^ declaration
]

{ #category : 'accessing' }
StSettingNode >> label [

	^ self declaration label
]

{ #category : 'accessing' }
StSettingNode >> label: aString [

	declaration label: aString.
]

{ #category : 'accessing' }
StSettingNode >> matchBlock [

	^ matchBlock
		ifNil: [ 
			matchBlock := [ : node : pattern | 
				node label substrings anySatisfy: [ : substr |
					substr asLowercase beginsWith: pattern asLowercase ] ] ]
]

{ #category : 'enumerating' }
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
StSettingNode >> model [

	^ model
]

{ #category : 'accessing' }
StSettingNode >> model: aStSettingsTree [ 

	model := aStSettingsTree
]

{ #category : 'accessing' }
StSettingNode >> name [

	^ self declaration name
]

{ #category : 'accessing' }
StSettingNode >> order [

	^ self declaration order
]

{ #category : 'accessing' }
StSettingNode >> order: anObject [

	self declaration order: anObject
]

{ #category : 'accessing' }
StSettingNode >> parentName [
	^ parentName
]

{ #category : 'accessing' }
StSettingNode >> parentName: aSymbol [
	parentName := aSymbol
]

{ #category : 'accessing' }
StSettingNode >> parentNode [

	^ self model nodeNamed: self parentName
]

{ #category : 'accessing' }
StSettingNode >> pragma [
	^ pragma
]

{ #category : 'initialization' }
StSettingNode >> pragma: aPragma [

	pragma := aPragma
]

{ #category : 'converting' }
StSettingNode >> presenterClass [

	^ self hasChildren
		ifTrue: [ StSettingSectionPresenter ]
		ifFalse: [ StSettingNodePresenter ]
]

{ #category : 'printing' }
StSettingNode >> printOn: aStream [
	"Private - See superimplementor's comment"
	
	super printOn: aStream.
	aStream
		nextPutAll: ' [';
		nextPutAll: self parentName asString;
		nextPutAll: '] '.
	self declaration ifNotNil: [ : decl | decl printOn: aStream ].
	aStream
		nextPutAll: ' (';
		nextPutAll: self allChildren size asString;
		nextPutAll: ') '

]

{ #category : 'accessing' }
StSettingNode >> settingDeclaration [

	^ declaration
]

{ #category : 'printing' }
StSettingNode >> settingNodeIdentifier [
	^ String streamContents: [ :aStream |
			self settingNodeIdentifierOn: aStream ]
]

{ #category : 'printing' }
StSettingNode >> settingNodeIdentifierOn: aWriteStream [

	parentNode
		ifNotNil: [ parentName settingNodeIdentifierOn: aWriteStream ]
		ifNil: [ parentName ifNotNil: [ aWriteStream print: parentName ] ].
	aWriteStream print: self settingDeclaration name
]
