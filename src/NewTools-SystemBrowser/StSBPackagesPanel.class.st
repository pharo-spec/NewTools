Class {
	#name : #StSBPackagesPanel,
	#superclass : #StSBPanel,
	#instVars : [
		'packageTree'
	],
	#category : #'NewTools-SystemBrowser-View'
}

{ #category : #specs }
StSBPackagesPanel class >> defaultSpec [

	^ SpecBoxLayout newVertical 
		add: #packageTree;
		yourself
]

{ #category : #initialization }
StSBPackagesPanel >> defineInputPorts [ 

	^ { ItemsPresenterPort newDelegate: [ self packageTree ] }
]

{ #category : #initialization }
StSBPackagesPanel >> defineOutputPorts [ 

	^ { ListSelectionPresenterPort newDelegate: [ self packageTree ] }
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
