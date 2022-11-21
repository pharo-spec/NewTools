Extension { #name : #CompiledCode }

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> hasPragmas [

	^ self pragmas notEmpty
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inpectionIr [
	<inspectorPresentationOrder: 35 title: 'IR'>

	^ SpTextPresenter new 
		text: (self ir longPrintString trimmed);
		yourself

]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionAST [
	<inspectorPresentationOrder: 35 title: 'AST'>

	^ SpTreePresenter new 
		roots: { self ast };
		children: [ :aNode | aNode children ];
		display: [ :each | 
			String
				streamContents: [ :stream | 
					stream
						nextPutAll: each class name;
						nextPut: $(;
						nextPutAll: ((each formattedCode truncateTo: 50) copyReplaceAll: String cr with: String space);
						nextPut: $)
			 ] ];
		yourself
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
CompiledCode >> inspectionPragmas [
	<inspectorPresentationOrder: 50 title: 'Pragmas'> 

	^ SpListPresenter new
		items: self pragmas;
		display: [ :aPragma | aPragma printString ];
		yourself
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionPragmasContext: aContext [ 
	
	aContext active: self hasPragmas
]

{ #category : #'*NewTools-Inspector-Extensions' }
CompiledCode >> inspectionSource [
	<inspectorPresentationOrder: 20 title: 'Source'>
	
	^ SpCodePresenter new 
		beForMethod: self method;
		text: self sourceCode;
		contextMenu: (SpMenuPresenter new addGroup: [ :group | group 
			addItem: [ :item | item 
				name: 'Browse method class'; 
				action: [ self methodClass browse ] ] ]);
		whenSubmitDo: [ :text | 
			self isInstalled 
				ifFalse: [ self inform: 'can not edit methods that are not installed' ]
				ifTrue: [ self methodClass compile: text ]];
		yourself
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
