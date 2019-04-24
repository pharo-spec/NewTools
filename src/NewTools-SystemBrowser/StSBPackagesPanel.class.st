Class {
	#name : #StSBPackagesPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'packageTree'
	],
	#category : #'NewTools-SystemBrowser'
}

{ #category : #specs }
StSBPackagesPanel class >> defaultSpec [

	^ SpecBoxLayout newVertical 
		add: #packageTree;
		yourself
]

{ #category : #initialization }
StSBPackagesPanel >> initializePorts [

	self addOutputPort: (ListSelectionPresenterPort new
		delegateTo: [ self packageTree ];
		yourself).
	self addInputPort: (ItemsPresenterPort new
		delegateTo: [ self packageTree ];
		yourself)
]

{ #category : #initialization }
StSBPackagesPanel >> initializeWidgets [
	
	packageTree := self newTreeTable
		hideColumnHeaders;
		addColumn: (CompositeTableColumn 
			with: (ImageTableColumn evaluated: #icon)
			with: (StringTableColumn evaluated: #name));
		roots: self model allPackages;
		children: #children;
		yourself
]

{ #category : #accessing }
StSBPackagesPanel >> packageTree [
	^ packageTree
]
