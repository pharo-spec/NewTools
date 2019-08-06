Class {
	#name : #StBreakpointInspection,
	#superclass : #StInspection,
	#instVars : [
		'attributeTable',
		'methodsWithBreakpoints',
		'breakpointsInSourceCode'
	],
	#category : #'NewTools-Inspector-View'
}

{ #category : #specs }
StBreakpointInspection class >> defaultSpec [

	^ SpPanedLayout newVertical
		add: #methodsWithBreakpoints;
		add: #breakpointsInSourceCode;
		yourself
]

{ #category : #private }
StBreakpointInspection >> breakpointDataFor: aMethod [
	"Returns a collection of dictionaries containing breakpoint data for the given method."

	| breakpointsForMethod breakpointData |
	breakpointsForMethod := Breakpoint all
		select: [ :b | b link methods includes: aMethod ].
	
	breakpointData := breakpointsForMethod
		collect: [ :b | 
			| data |
			data := Dictionary new.
			data at: #method put: aMethod.
			data at: #type put: 'Breakpoint'.
			data at: #onceOrAlways
				  put:	(b link optionOneShot	ifTrue: [ 'once' ] ifFalse: [ 'always' ]).
			data at: #interval put: (b node start to: b node stop).
			data at: #target put: 'instances of ', aMethod methodClass name.
			data ].
		^breakpointData 
]

{ #category : #private }
StBreakpointInspection >> haltDataFor: aMethod [
	"Returns a collection of dictionaries containing halt data for the given method."

	| messageNodesForMethod haltNodesForMethod breakpointData |
	messageNodesForMethod := aMethod ast allChildren select:[:n| n isMessage].
	haltNodesForMethod := messageNodesForMethod select:[:node| self haltsSelectors includes: node selector].
	
	breakpointData := haltNodesForMethod
		collect: [ :haltNode | 
			| data |
			data := Dictionary new.
			data at: #method put: aMethod.
			data at: #type put: 'Halt'.
			data at: #onceOrAlways
				  put:	(self labelForHaltSelector: haltNode selector).
			data at: #interval put: (haltNode start to: haltNode stop).
			data at: #target put: 'instances of ', aMethod methodClass name.
			data ].
		^breakpointData 
]

{ #category : #private }
StBreakpointInspection >> haltsSelectors [
	^#( halt halt: haltIf: haltIfNil haltOnCount: haltOnce)
]

{ #category : #initialization }
StBreakpointInspection >> initializeWidgets [
	| allMethodsForModel breakpointData |
	
	breakpointData := SortedCollection sortBlock:[ :a :b | (a at: #method) name < (b at: #method) name].
	allMethodsForModel := model class allMethods
		select: [ :m | m hasBreakpoint or: [ m containsHalt ] ].
	breakpointData addAll: (allMethodsForModel
		flatCollect: [ :m | self breakpointDataFor: m ]).
	breakpointData addAll: (allMethodsForModel
		flatCollect: [ :m | self haltDataFor: m ]).
	
	"Source code of methods in which breakpoint are installed"
	breakpointsInSourceCode := self newCode.
	breakpointsInSourceCode behavior: model class.
	breakpointsInSourceCode disable.

	"List of methods in which a breakpoint is installed"
	methodsWithBreakpoints := self newTable.
	methodsWithBreakpoints
		addColumn: (SpStringTableColumn title: 'Type' evaluated: [ :item | item at: #type ]);
		addColumn: (SpStringTableColumn title: 'Method' evaluated: [ :item | (item at: #method) name ]);
		addColumn: (SpStringTableColumn title: 'When' evaluated: [ :item | item at: #onceOrAlways ]);
		addColumn: (SpStringTableColumn title: 'Target(s)' evaluated: [ :item | item at: #target ]).
		
	methodsWithBreakpoints whenSelectionChangedDo: [ :selection | 
		| selectedItem |
		selectedItem := selection selectedItem.
		breakpointsInSourceCode text: (selectedItem at: #method) sourceCode.
		breakpointsInSourceCode setSelection: (selectedItem at: #interval) ].
	
	methodsWithBreakpoints items: breakpointData
]

{ #category : #private }
StBreakpointInspection >> labelForHaltSelector: aSelector [
	(#(haltIf: haltIfNil) includes: aSelector)
		ifTrue: [ ^ 'condition' ].
	(#(haltOnCount:) includes: aSelector)
		ifTrue: [ ^ 'on count' ].
	(#(haltOnce) includes: aSelector)
		ifTrue: [ ^ 'once' ].
	^ 'always'
]
