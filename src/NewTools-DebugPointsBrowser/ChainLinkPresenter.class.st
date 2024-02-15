"
I am the UI element for the ChainLinkBehavior of DebugPoints and am added to the DebugPointEditor.
"
Class {
	#name : 'ChainLinkPresenter',
	#superclass : 'DebugPointBehaviorPresenter',
	#instVars : [
		'chain'
	],
	#category : 'NewTools-DebugPointsBrowser',
	#package : 'NewTools-DebugPointsBrowser'
}

{ #category : 'accessing' }
ChainLinkPresenter >> debugPoint: aDebugPoint [

	super debugPoint: aDebugPoint.
	behavior := self debugPoint getBehavior: ChainBehavior.
	checkBox state: behavior isNotNil.
	behavior ifNotNil: [
		chain roots:
			{ (ChainBehavior rootFor: aDebugPoint) } asOrderedCollection.
		chain children: [ :dp |
			(ChainBehavior childFor: dp)
				ifNil: [ OrderedCollection new ]
				ifNotNil: [ :dp2 | { dp2 } ] ].
		"chain expandAll."
		"since selectItem does not work after expanding this requires a different solution to clarify which chainlink is currently selected"
		chain selectItem: aDebugPoint ]
]

{ #category : 'layout' }
ChainLinkPresenter >> defaultLayout [ 
	| newLayout |
	
	newLayout := SpBoxLayout newTopToBottom 
		
		add: checkBox expand: false;
		yourself.
		
	self behavior ifNotNil: [
		newLayout add: ( SpBoxLayout newTopToBottom borderWidth: 5;
			add: (self newButton label: 'Reset Chain State'; action: [self resetChain.]) expand: false;
			add: chain "height: 100" ;
			yourself) expand: true;
		
		yourself].
		
	^newLayout
	

		

]

{ #category : 'expanding-collapsing' }
ChainLinkPresenter >> expand [
	^true
]

{ #category : 'initialization' }
ChainLinkPresenter >> initializePresenters [

	chain := self newTreeTable beResizable.
	chain
		addColumn:
			(SpStringTableColumn title: 'Type' evaluated: [ :item | item name ])
				yourself;
		addColumn: (SpStringTableColumn
				 title: 'Target'
				 evaluated: [ :item | item targetString ]) yourself.
	checkBox := self newCheckBox label:
		            'Chain: Each debug point is hit once in sequential order'.
	checkBox whenActivatedDo: [
		self behavior ifNil: [ debugPoint addBehavior: ChainBehavior new ] ].
	checkBox whenDeactivatedDo: [
		self debugPoint removeBehavior: ChainBehavior.
		self behavior: nil ]
]

{ #category : 'API' }
ChainLinkPresenter >> resetChain [

	self behavior resetChain.
]
