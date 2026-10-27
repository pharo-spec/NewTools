"
I test StNewSettingsTree, the model of the settings browser.
"
Class {
	#name : 'StNewSettingsTreeTest',
	#superclass : 'TestCase',
	#category : 'NewTools-SettingsBrowser-Tests',
	#package : 'NewTools-SettingsBrowser-Tests'
}

{ #category : 'helpers' }
StNewSettingsTreeTest >> nodeNamed: aSymbol label: aString order: aNumberOrNil [

	^ StNewSettingNode forSetting: (Setting new
			   name: aSymbol;
			   label: aString;
			   order: aNumberOrNil;
			   yourself)
]

{ #category : 'tests' }
StNewSettingsTreeTest >> testChildrenOfGroupAreItsSettings [

	| tree group |
	tree := StNewSettingsTree new.
	group := tree nodeList detect: [ :each | each name = #'Syntax Highlighting' ].

	self
		assertCollection: ((tree childrenOf: group) collect: [ :each | each name ])
		includesAll: #( #formatIncompleteIdentifiers #activeStyleTable #'Edit Custom Style' )
]

{ #category : 'tests' }
StNewSettingsTreeTest >> testChildrenWithoutOrderAreOrderedAroundOrderedChildren [

	| group tree children |
	group := SettingsGroup new
		         name: #group;
		         yourself.
	tree := StNewSettingsTree new.
	tree nodeList: ({ group } , (#( nil nil 5 nil 9 nil ) withIndexCollect: [ :order :index |
			   Setting new
				   name: ('setting' , index printString) asSymbol;
				   order: order;
				   parentGroup: group;
				   yourself ]) collect: [ :each | StNewSettingNode forSetting: each ]).

	children := tree childrenOf: tree nodeList first.

	self assert: (children collect: [ :each | each order ]) asArray equals: #( 3 4 5 6 9 10 )
]

{ #category : 'tests' }
StNewSettingsTreeTest >> testSortBlockSortsByOrderThenByLabel [

	| nodes |
	nodes := {
		         (self nodeNamed: #a label: 'a' order: 2).
		         (self nodeNamed: #b label: 'b' order: 1).
		         (self nodeNamed: #c label: 'z' order: nil).
		         (self nodeNamed: #d label: 'y' order: nil) }.

	self
		assert: ((nodes asSortedCollection: StNewSettingsTree new sortBlock) collect: [ :each | each name ]) asArray
		equals: #( #b #a #d #c )
]

{ #category : 'tests' }
StNewSettingsTreeTest >> testTreeRootsHaveNoParent [

	| roots |
	roots := StNewSettingsTree new treeRoots.

	self denyEmpty: roots.
	self assert: (roots noneSatisfy: [ :each | each hasParent ])
]
