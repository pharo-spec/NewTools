"
I am a builder for getting a tree of StWorldMenuBuilderItems.
These items describe the configuration of the world menu. 
The configuration is collected from all the method having the pragma #worldMenu.

You can obtain all items configured by doing: 

```
StWorldMenuBuilder new collectMenuItems
```
"
Class {
	#name : 'StWorldMenuBuilder',
	#superclass : 'Object',
	#instVars : [
		'collector',
		'currentParent',
		'currentElement',
		'root'
	],
	#category : 'NewTools-WorldMenu-Model',
	#package : 'NewTools-WorldMenu',
	#tag : 'Model'
}

{ #category : 'building' }
StWorldMenuBuilder >> buildMenuBarPresenterFor: anOwner [

	| aPresenter |
	
	aPresenter := anOwner newMenuBar.

	StWorldMenuPresenterVisitor new 
		presenter: aPresenter;
		owner: anOwner;
		visit: self collectMenuItems.
		
	^ aPresenter
]

{ #category : 'building' }
StWorldMenuBuilder >> collectMenuItems [
			
	| allElements |
	
	self pragmas collect: [ :pragma | 
			pragma methodClass instanceSide
						perform: pragma methodSelector
						with: self ].
	
	allElements := self root allChildren. 
	allElements do: [ :anElement | anElement fixParentsFrom: allElements ].
	
	self root fixSubElements.
	self root reorderSubElements.
	
	^ self root

]

{ #category : 'accessing' }
StWorldMenuBuilder >> collector [
	
	^ collector ifNil: [ collector := (PragmaCollector selectors: #(worldMenu)) ]
]

{ #category : 'building' }
StWorldMenuBuilder >> currentParent: anItem while: aFullBlockClosure [ 
	
	| old |
	
	old := currentParent.
	currentParent := anItem.
	
	aFullBlockClosure ensure: [ currentParent := old ]
]

{ #category : 'accessing' }
StWorldMenuBuilder >> group: aString [

	^ self newElement: aString ofClass: StWorldMenuBuilderGroup
]

{ #category : 'initialization' }
StWorldMenuBuilder >> initialize [

	super initialize.
	currentParent := self newElement: #'root' ofClass: StWorldMenuBuilderRoot.
	root := currentParent 
]

{ #category : 'accessing' }
StWorldMenuBuilder >> item: aString [ 
		
	^ self newElement: aString ofClass: StWorldMenuBuilderItem
]

{ #category : 'accessing' }
StWorldMenuBuilder >> newElement: aString ofClass: aClass [
	
	| element |
	element := aClass new
		builder: self;
		parent: currentParent;
		name: aString;
		yourself.
		
	currentParent ifNotNil: [ currentParent addSubElement: element ].
	currentElement := element.
		
	^ element
]

{ #category : 'accessing - pragmas & properties' }
StWorldMenuBuilder >> pragmas [
	
	^ self collector pragmas
]

{ #category : 'accessing' }
StWorldMenuBuilder >> root [
	
	^ root
]

{ #category : 'menu protocol' }
StWorldMenuBuilder >> withSeparatorAfter [
	
	currentElement withSeparatorAfter 
]
