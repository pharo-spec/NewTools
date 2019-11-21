"
I am an inspection for halts and breakpoints, my scope is the inspected object.
"
Class {
	#name : #StObjectBreakpointInspection,
	#superclass : #StInspection,
	#instVars : [
		'attributeTable',
		'methodsWithBreakpoints',
		'breakpointsInSourceCode',
		'breakpointController'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StObjectBreakpointInspection class >> defaultSpec [

	^ SpPanedLayout newVertical
		add: #methodsWithBreakpoints;
		add: #breakpointsInSourceCode;
		yourself
]

{ #category : #private }
StObjectBreakpointInspection >> breakPointsForModel [
	| methodsWithBreakpoint |
	methodsWithBreakpoint := model class allMethods
		select: [ :m | m hasBreakpoint ].
	^ methodsWithBreakpoint
		flatCollect: [ :m | Breakpoint all select: [ :b | b link methods includes: m ] ]
]

{ #category : #private }
StObjectBreakpointInspection >> breakpointDataFor: aBreakpoint [
	"Returns a dictionary containing breakpoint data for the given breakpoint."

	| data |
	data := Dictionary new.
	data at: #node put: aBreakpoint node.
	data at: #type put: 'Breakpoint'.
	data at: #interval put: (aBreakpoint node start to: aBreakpoint node stop).
	^ data
]

{ #category : #private }
StObjectBreakpointInspection >> buildBreakpointData [
	^ self breakPointsForModel
		collect: [ :b | self breakpointDataFor: b ]
]

{ #category : #private }
StObjectBreakpointInspection >> buildHaltAndBreakpointData [
	| breakpointData |
	breakpointData := SortedCollection
		sortBlock: [ :a :b | (a at: #node) methodNode selector < (b at: #node) methodNode selector ].
	breakpointData addAll: self buildBreakpointData.
	breakpointData addAll: self buildHaltData.
	^ breakpointData
]

{ #category : #presenters }
StObjectBreakpointInspection >> buildHaltAndBreakpointTable [
	"List of methods in which a breakpoint is installed"

	methodsWithBreakpoints := self newTable.
	methodsWithBreakpoints
		addColumn:
			((SpCheckBoxTableColumn
				title: ' '
				evaluated:
					[ :item | breakpointController areHaltsAndBreakpoinsEnabledFor: (item at: #node) ])
				onActivation:
						[ :item | breakpointController enableHaltOrBreakpointFor: (item at: #node) ];
				onDesactivation:
						[ :item | breakpointController disableHaltOrBreakpointFor: (item at: #node) ];
				width: 20;
				yourself);
		addColumn:
			((SpStringTableColumn
				title: 'Type'
				evaluated: [ :item | item at: #type ])
				width: 65;
				yourself);
		addColumn:
			(SpStringTableColumn
				title: 'Method'
				evaluated: [ :item | 
					(item at: #node) methodNode methodClass name , '>>'
						, (item at: #node) methodNode selector ]).
	
]

{ #category : #private }
StObjectBreakpointInspection >> buildHaltData [
	^ (model class allMethods
		flatCollect: [ :m | StHaltCache defaultCache nodeCacheForSelector: m printString ])
		collect: [ :node | self haltDataFor: node ]
]

{ #category : #presenters }
StObjectBreakpointInspection >> buildSourceCode [
	"Source code of methods in which breakpoint are installed"

	breakpointsInSourceCode := self newCode.
	breakpointsInSourceCode disable
]

{ #category : #presenters }
StObjectBreakpointInspection >> buildTableData [
	methodsWithBreakpoints items: self buildHaltAndBreakpointData
]

{ #category : #presenters }
StObjectBreakpointInspection >> configureSourceCodeUpdate [
	methodsWithBreakpoints
		whenSelectionChangedDo: [ :selection | 
			| selectedItem node |
			selectedItem := selection selectedItem.
			node := selectedItem at: #node.
			breakpointsInSourceCode text: node methodNode source.
			breakpointsInSourceCode selection: (selectedItem at: #interval).
			self updateSourceCodeBehaviorFor: node ]
]

{ #category : #private }
StObjectBreakpointInspection >> haltDataFor: aNode [
	"Returns a dictionary containing halt data for the given halt node."

	| data |
	data := Dictionary new.
	data at: #node put: aNode.
	data at: #type put: 'Halt'.
	data at: #interval put: (aNode start to: aNode stop).
	^ data
]

{ #category : #private }
StObjectBreakpointInspection >> haltsSelectors [
	^#( halt halt: haltIf: haltIfNil haltOnCount: haltOnce)
]

{ #category : #initialization }
StObjectBreakpointInspection >> initialize [
	breakpointController := StHaltAndBreakpointController new.
	super initialize
]

{ #category : #initialization }
StObjectBreakpointInspection >> initializePresenters [
	self buildSourceCode.
	self buildHaltAndBreakpointTable.
	self configureSourceCodeUpdate.
	self buildTableData.
	SystemAnnouncer uniqueInstance weak when: StHaltCacheChanged send: #buildTableData to: self.
	SystemAnnouncer uniqueInstance weak when: MetalinkChanged send: #buildTableData to: self
]

{ #category : #initialization }
StObjectBreakpointInspection >> initializeWindow: aWindowPresenter [
	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		whenClosedDo: [ SystemAnnouncer uniqueInstance unsubscribe: self ]
]

{ #category : #presenters }
StObjectBreakpointInspection >> labelForHaltSelector: aSelector [
	(#(haltIf: haltIfNil) includes: aSelector)
		ifTrue: [ ^ 'condition' ].
	(#(haltOnCount:) includes: aSelector)
		ifTrue: [ ^ 'on count' ].
	(#(haltOnce) includes: aSelector)
		ifTrue: [ ^ 'once' ].
	^ 'always'
]

{ #category : #'system subscription' }
StObjectBreakpointInspection >> unsubscribeFromCacheChanges [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #presenters }
StObjectBreakpointInspection >> updateSourceCodeBehaviorFor: node [
	breakpointsInSourceCode behavior: model class
]
