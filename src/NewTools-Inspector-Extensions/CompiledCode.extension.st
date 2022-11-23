Extension { #name : #CompiledCode }

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> hasPragmas [

	^ self pragmas notEmpty
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inpectionIr [
	<inspectorPresentationOrder: 35 title: 'IR'>

	^ self ir inpectionIr
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionAST [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ self sourceNode inspectionAST
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionBytecode [
	<inspectorPresentationOrder: 30 title: 'Bytecode'>

	^ SpListPresenter new 
		items: self symbolicBytecodes;
		display: [ :aBytecode | aBytecode printString ];
		yourself

]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionHeader [
	<inspectorPresentationOrder: 40 title: 'Header'> 
	
	^ SpTextPresenter new 
		text: self headerDescription;
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionItemsContext: aContext [

	"Disable items view on compiled code"
	aContext active: false
]

{ #category : #'*NewTools-Inspector-Extensions' }
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
