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
StObjectBreakpointInspection >> breakpointDataFor: aMethod [
	"Returns a collection of dictionaries containing breakpoint data for the given method."

	| breakpointsForMethod breakpointData |
	breakpointsForMethod := Breakpoint all
		select: [ :b | b link methods includes: aMethod compiledMethod].
	
	breakpointData := breakpointsForMethod
		collect: [ :b | 
			| data |
			data := Dictionary new.
			data at: #node put: b node.
			data at: #method put: aMethod.
			data at: #type put: 'Breakpoint'.
			data at: #interval put: (b node start to: b node stop).
			data ].
		^breakpointData 
]

{ #category : #private }
StObjectBreakpointInspection >> buildBreakpointData [
	^ (model class allMethods select: [ :m | m hasBreakpoint ])
		flatCollect: [ :m | self breakpointDataFor: m ]
]

{ #category : #private }
StObjectBreakpointInspection >> buildHaltAndBreakpointData [
	| breakpointData |
	breakpointData := SortedCollection
		sortBlock: [ :a :b | (a at: #method) name < (b at: #method) name ].
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
				evaluated: [ :item | breakpointController areHaltsAndBreakpoinsEnabledFor: (item at: #node) ])
				onActivation: [ :item | breakpointController enableHaltOrBreakpointFor: (item at: #node)  ];
				onDesactivation: [ :item | breakpointController disableHaltOrBreakpointFor: (item at: #node)  ];
				width: 20;
				yourself);
		addColumn:
			(SpStringTableColumn
				title: 'Type'
				evaluated: [ :item | item at: #type ]);
		addColumn:
			(SpStringTableColumn
				title: 'Method'
				evaluated: [ :item | (item at: #method) name ]).
	methodsWithBreakpoints
		whenSelectionChangedDo: [ :selection | 
			| selectedItem |
			selectedItem := selection selectedItem.
			breakpointsInSourceCode text: (selectedItem at: #method) sourceCode.
			breakpointsInSourceCode selection: (selectedItem at: #interval) ]
]

{ #category : #private }
StObjectBreakpointInspection >> buildHaltData [
	| selectors |
	selectors := model class allMethods collect: [ :m | m selector ].	
	^ (selectors
		flatCollect: [ :s | StHaltCache defaultCache nodeCacheForSelector: s ])
		collect: [ :node | self haltDataFor: node ]
]

{ #category : #presenters }
StObjectBreakpointInspection >> buildSourceCode [
	"Source code of methods in which breakpoint are installed"

	breakpointsInSourceCode := self newCode.
	breakpointsInSourceCode behavior: model class.
	breakpointsInSourceCode disable
]

{ #category : #presenters }
StObjectBreakpointInspection >> buildTableData [
	methodsWithBreakpoints items: self buildHaltAndBreakpointData
]

{ #category : #private }
StObjectBreakpointInspection >> haltDataFor: aNode [
	"Returns a dictionary containing halt data for the given halt node."

	| data |
	data := Dictionary new.
	data at: #node put: aNode.
	data at: #method put: aNode methodNode method.
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
