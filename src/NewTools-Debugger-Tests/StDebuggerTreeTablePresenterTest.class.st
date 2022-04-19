Class {
	#name : #StDebuggerTreeTablePresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'presenter',
		'inspectorNodes'
	],
	#category : #'NewTools-Debugger-Tests-Presenters'
}

{ #category : #running }
StDebuggerTreeTablePresenterTest >> setUp [

	| node |
	super setUp.

	presenter := StDebuggerTreeTablePresenter new.
	inspectorNodes := OrderedCollection new.

	node := StInspectorDynamicNode basicNew variableTag: 'toto'.
	node rawValue: node; hostObject: 'toto'.
	inspectorNodes add: (node rawValue: node).

	node := StInspectorDynamicNode basicNew variableTag: 'tata'.
	node rawValue: node; hostObject: 'tata'.
	inspectorNodes add: node.
	
	presenter roots: inspectorNodes.
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testApplyFilterDoesFilterWhenHasActiveFilterIsTrueAndFilterIsNotNil [

	| rejectedItems filteredItems |
	rejectedItems := inspectorNodes reject: [ :item | 
		                 item variableTag = 'toto' ].
	presenter filter: 'toto'.
	presenter isFiltered: true.

	filteredItems := presenter applyFilter.

	filteredItems do: [ :filteredItem | 
		self
			deny: (rejectedItems includes: filteredItem);
			assert: filteredItem variableTag equals: 'toto' ].
	self
		assert: filteredItems size + rejectedItems size
		equals: inspectorNodes size
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testApplyFilterDoesntFilterAndRemovesFilterWhenHasActiveFilterIsFalse [

	presenter filter: 'toto'.
	presenter applyFilter.
	self 	assert: presenter roots equals: inspectorNodes;
			assert: presenter filter isNil
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testApplyFilterDoesntFilterWhenFilterIsNil [

	presenter isFiltered: true.
	presenter applyFilter.
	self assert: presenter roots equals: inspectorNodes
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testInitialization [

	self deny: presenter hasActiveFilter.
	self assert: presenter filter isNil.
	self assert: presenter roots equals: inspectorNodes
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testRootsActualisesRootsByApplyingFilter [

	| filteredItems |
	presenter isFiltered: true.
	presenter filter: 'tata'.
	filteredItems := presenter applyFilter.

	presenter roots: presenter roots.

	self assert: presenter roots equals: filteredItems
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testToggleDoesNotFilterWhenFilteredButFilterIsNil [

	presenter toggleFilter: nil.
	self assert: presenter roots equals: inspectorNodes;
		assert: presenter hasActiveFilter
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testToggleFiltersWhenFilteredAndFilterIsNotNil [

	| rejectedItems |
	rejectedItems := inspectorNodes reject: [:item | item variableTag = 'toto'].
	presenter toggleFilter: 'toto'.

	presenter roots do: [ :filteredItem | 
		self 	deny: (rejectedItems includes: filteredItem);
				assert: filteredItem variableTag equals: 'toto' ].
	self
		assert: presenter roots size + rejectedItems size equals: inspectorNodes size;
		assert: presenter filter equals: 'toto';
		assert: presenter hasActiveFilter
]

{ #category : #tests }
StDebuggerTreeTablePresenterTest >> testToggleUnFiltersWhenToggledTwice [

	| rejectedItems |
	rejectedItems := inspectorNodes reject: [ :item | 
		                 item variableTag = 'toto' ].
	presenter toggleFilter: 'toto'.
	presenter toggleFilter: 'toto'.

	self
		assert: presenter roots equals: inspectorNodes;
		assert: presenter filter isNil;
		deny: presenter hasActiveFilter
]
