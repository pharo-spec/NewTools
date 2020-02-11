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

	^ SpBoxLayout newVertical 
		add: #packageTree;
		yourself
]

{ #category : #initialization }
StSBPackagesPanel >> defaultInputPort [

	^ self inputItemsPort
]

{ #category : #initialization }
StSBPackagesPanel >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : #accessing }
StSBPackagesPanel >> gotoPackage: aPackage [
	| roots packageModel |

	roots := self packageTree roots. 
	packageModel := roots
		detect: [ :each | each package = aPackage ]
		ifNone: [ ^ self ].
		
	self packageTree selectPath: { roots indexOf: packageModel }
]

{ #category : #initialization }
StSBPackagesPanel >> initializePresenters [
	
	packageTree := self newTreeTable
		hideColumnHeaders;
		addColumn: (SpCompositeTableColumn 
			with: (SpImageTableColumn evaluated: #icon) beNotExpandable
			with: (SpStringTableColumn evaluated: #name));
		roots: self model allPackages;
		children: #children;
		yourself
]

{ #category : #initialization }
StSBPackagesPanel >> inputItemsPort [

	^ (SpListItemsPort newPresenter: self) 
		delegateTo: [ self packageTree ];
		yourself
]

{ #category : #initialization }
StSBPackagesPanel >> outputSelectionPort [
	
	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ self packageTree ];
		yourself
]

{ #category : #accessing }
StSBPackagesPanel >> packageTree [
	^ packageTree
]
