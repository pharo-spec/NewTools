"
I represent an entry in the world menu
"
Class {
	#name : 'StWorldMenuBuilderItem',
	#superclass : 'Object',
	#instVars : [
		'name',
		'subelements',
		'label',
		'parent',
		'order',
		'action',
		'help',
		'iconName',
		'builder',
		'withSeparatorAfter',
		'target',
		'selector',
		'keyText',
		'icon',
		'enabled'
	],
	#category : 'NewTools-WorldMenu-Model',
	#package : 'NewTools-WorldMenu',
	#tag : 'Model'
}

{ #category : 'visiting' }
StWorldMenuBuilderItem >> acceptVisitor: aVisitor [

	^ aVisitor visitItem: self
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> action [
	^ action
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> action: aFullBlockClosure [ 
	
	action := aFullBlockClosure
	
]

{ #category : 'adding' }
StWorldMenuBuilderItem >> addSubElement: aStWorldMenuBuilderSpec [ 
	
	subelements add: aStWorldMenuBuilderSpec
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> allChildren [
	
	^ subelements , (subelements flatCollect: [ :e | e allChildren ])
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> builder: aStWorldMenuBuilder [ 
	builder := aStWorldMenuBuilder
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> enabled: aFullBlockClosure [ 
	
	enabled := aFullBlockClosure
]

{ #category : 'private' }
StWorldMenuBuilderItem >> fixParentsFrom: aCollection [ 
	
	| newParent |
	parent isSymbol ifFalse: [ ^ self ].
	
	newParent := aCollection detect: [ :e | e name = self parent ].
	newParent addSubElement: self.
	parent := newParent.
]

{ #category : 'private' }
StWorldMenuBuilderItem >> fixSubElements [	
	
	self assert: (subelements noneSatisfy: [:e | e parent isSymbol ]).
	subelements := subelements select: [ :e | e parent = self ]
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> help [
	^ help
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> help: aString [ 
	
	help := aString 
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> icon [
	^ icon
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> icon: aForm [ 
	
	icon := aForm
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> iconName [
	^ iconName
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> iconName: aString [ 
	
	iconName := aString
]

{ #category : 'initialization' }
StWorldMenuBuilderItem >> initialize [ 
	
	super initialize.
	subelements := OrderedCollection new
]

{ #category : 'inspector' }
StWorldMenuBuilderItem >> inspectionTree: aBuilder [
	<inspectorPresentationOrder: 1 title: 'Tree'>

	^ aBuilder newTree
		roots: { self };
		children: [ :each | each subelements ];
		expandRoots;
		yourself

]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> keyText [
	^ keyText
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> keyText: aString [ 
	
	keyText := aString
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> label [
	^ label
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> label: aString [ 
	
	label := aString
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> name [
	^ name
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> name: aString [ 
	name := aString
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> order [

	^ order ifNil: [ 0 ]
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> order: anInteger [ 
	
	order := anInteger
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> parent [
	^ parent
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> parent: aString [ 
	
	parent := aString
]

{ #category : 'printing' }
StWorldMenuBuilderItem >> printOn: aStream [

	aStream 
		nextPutAll: self class name;
		space;
		print: name 
]

{ #category : 'private' }
StWorldMenuBuilderItem >> reorderSubElements [

	subelements sort: [ :a :b | a order < b order ].
	subelements do: [ :e | e reorderSubElements ]
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> selector [
	^ selector
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> selector: aString [ 
	
	selector := aString
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> subelements [

	^ subelements
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> target [
	^ target
]

{ #category : 'accessing' }
StWorldMenuBuilderItem >> target: aMetaclass [ 
	
	target := aMetaclass 

]

{ #category : 'instance creation' }
StWorldMenuBuilderItem >> with: aFullBlockClosure [ 
	
	builder currentParent: self while: aFullBlockClosure
]

{ #category : 'menu protocol' }
StWorldMenuBuilderItem >> withSeparatorAfter [
	
	withSeparatorAfter := true
 
]
