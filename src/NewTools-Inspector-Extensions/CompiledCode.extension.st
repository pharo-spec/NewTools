Extension { #name : 'CompiledCode' }

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> hasPragmas [

	^ self pragmas notEmpty
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inpectionIr: aBuilder [
	<inspectorPresentationOrder: 35 title: 'IR'>

	^ self ir inpectionIr: aBuilder
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectBytes: specBuilder [
	<inspectorPresentationOrder: 30 title: 'Bytes'>

	^ self size > 1000 
		ifTrue: [
			(StSimpleInspectorBuilder on: specBuilder)
				key: 'error' value: 'too many bytes, size is ' , self size asString;
				table ]
		ifFalse: [
			(StSimpleInspectorBuilder on: specBuilder)
				key: 'hex string bytecode' value: (String streamContents: [ :out | 
					self bytecodes do: [ :each | each printOn: out base: 16 nDigits: 2 ] ]);
				key: 'hex lines bytecode' value: (String streamContents: [ :out |
					self bytecodes withIndexDo: [ :each :index |
						index = 1 ifFalse: [ 
							index - 1 \\ 8 = 0 ifTrue: [ out cr ] ifFalse: [ out space ] ].
						each printOn: out base: 16 nDigits: 2 ] ]);
				table ]
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionAST: aBuilder [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ self sourceNode inspectionAST: aBuilder
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionBytecode: aBuilder [
	<inspectorPresentationOrder: 30 title: 'Bytecode'>

	^ aBuilder newList
		addStyle: 'stList';
		items: self symbolicBytecodes;
		display: [ :aBytecode | aBytecode printString ];
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionHeader: aBuilder [
	<inspectorPresentationOrder: 40 title: 'Header'> 
	
	^ aBuilder newText 
		text: self headerDescription;
		yourself
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionItemsContext: aContext [

	"Disable items view on compiled code"
	aContext active: false
]

{ #category : '*NewTools-Inspector-Extensions' }
CompiledCode >> inspectorNodes [
	"Answer a list of attributes as nodes"
	| nodes |

	nodes := OrderedCollection new.
	nodes add: (StInspectorDynamicNode 
				hostObject: self 
				label: 'literal0'
				value: self header).
	
	nodes addAll: (self allLiterals 
		collectWithIndex: [ :aLiteral :anIndex | 
			StInspectorDynamicNode 
				hostObject: self 
				label: ('literal', anIndex asString) 
				value: aLiteral ]).
	
	self initialPC to: self size do: [ :index |
		nodes add: (StInspectorDynamicNode 
			hostObject: self 
			label: ('bc ', index asString) 
			value: (self at: index) ) ] .
	
	^ nodes
]
