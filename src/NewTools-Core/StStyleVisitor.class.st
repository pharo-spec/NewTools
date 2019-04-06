Class {
	#name : #StStyleVisitor,
	#superclass : #Object,
	#instVars : [
		'parentheseLevel',
		'bracketLevel',
		'contextClass',
		'tags'
	],
	#category : #'NewTools-Core'
}

{ #category : #private }
StStyleVisitor >> addStyle: style from: start to: end [ 
	
	tags add: (StStyleTag newName: style from: start to: end)
]

{ #category : #accessing }
StStyleVisitor >> contextClass: aClass [

	contextClass := aClass
]

{ #category : #private }
StStyleVisitor >> currentClosedBracketStyleName [
	
	bracketLevel isZero ifTrue: [ ^ #blockEnd ].
	^ (#blockEnd asString, bracketLevel asString) asSymbol
]

{ #category : #private }
StStyleVisitor >> currentClosedParenthesisStyleName [

	parentheseLevel isZero ifTrue: [ ^ #rightParenthesis ].
	^ (#rightParenthesis asString, parentheseLevel asString) asSymbol
]

{ #category : #private }
StStyleVisitor >> currentOpenedBracketStyleName [

	bracketLevel isZero ifTrue: [ ^ #blockStart ].
	^ (#blockStart asString, bracketLevel asString) asSymbol
]

{ #category : #private }
StStyleVisitor >> currentOpenedParenthesisStyleName [

	parentheseLevel isZero ifTrue: [ ^ #leftParenthesis ].
	^ (#leftParenthesis asString, parentheseLevel asString) asSymbol
]

{ #category : #private }
StStyleVisitor >> literalStyleSymbol: aValue [

	aValue isSymbol 		ifTrue: [ ^ #symbol ].
	aValue isString 		ifTrue: [ ^ #string ].
	aValue isCharacter 	ifTrue: [ ^ #character ].
	aValue isNumber 		ifTrue: [ ^ #number ].
	aValue == true 			ifTrue: [ ^ #true ].
	aValue == false 		ifTrue: [ ^ #false ].
	aValue isNil 			ifTrue: [ ^ #nil ].

	^ #default
]

{ #category : #private }
StStyleVisitor >> methodOrBlockArgStyleFor: aRBArgumentNode [ 
	
	^ aRBArgumentNode isBlockVar
		ifTrue: [ #blockArg ]
		ifFalse: [ #methodArg ]
]

{ #category : #private }
StStyleVisitor >> methodOrBlockTempDeclStyleFor: aSequenceNode [
	
	^ aSequenceNode scope isBlockScope
		ifTrue: [ #blockPatternTempVar ]
		ifFalse: [ #patternTempVar ]
]

{ #category : #private }
StStyleVisitor >> methodOrBlockTempStyleFor: aRBTemporaryNode [ 
	
	^ aRBTemporaryNode isBlockVar
		ifTrue: [ #blockTempVar ]
		ifFalse: [ #tempVar ]
]

{ #category : #private }
StStyleVisitor >> reset [
	
	tags := OrderedCollection new.
	parentheseLevel := 0.
	bracketLevel := 0
]

{ #category : #private }
StStyleVisitor >> resolveStyleFor: aRBVariableNode [ 

	aRBVariableNode binding ifNil: [^#default].
	aRBVariableNode isArg ifTrue: [ ^#methodArg].
	aRBVariableNode isTemp ifTrue: [ ^#tempVar].
	aRBVariableNode isGlobal ifTrue: [ ^#globalVar].
	aRBVariableNode isInstance ifTrue: [ ^#instVar]. 
	aRBVariableNode hasIncompleteIdentifier ifTrue:[ ^#incompleteIdentifier].
	
	^#invalid.
]

{ #category : #private }
StStyleVisitor >> styleCloseBracket: aRBBlockNode [ 
	
	bracketLevel := bracketLevel - 1.
	(aRBBlockNode right isZero or: [ aRBBlockNode value isNil ]) ifTrue:[ ^ self ].
	self 
		addStyle: self currentClosedBracketStyleName 
		from: aRBBlockNode right 
		to: aRBBlockNode right
]

{ #category : #private }
StStyleVisitor >> styleCloseParenthese: aMessageNode [
	
	aMessageNode parentheses ifNotEmpty: [ 
		aMessageNode parentheses reverseDo: [ :interval | 
			| pos |
			pos := interval last.
			parentheseLevel := parentheseLevel - 1.
			self addStyle: self currentClosedParenthesisStyleName from: pos to: pos ] ]
]

{ #category : #private }
StStyleVisitor >> styleOpenBracket: aRBBlockNode [
	| style |

	style := aRBBlockNode isFaulty
		ifTrue: [ #invalid ]
		ifFalse: [ self currentOpenedBracketStyleName ].
	self addStyle: style from: aRBBlockNode left to: aRBBlockNode left.
	bracketLevel := bracketLevel + 1
]

{ #category : #private }
StStyleVisitor >> styleOpenParenthese: aMessageNode [
	
	aMessageNode parentheses ifNotEmpty: [ 
		aMessageNode parentheses
			do: [ :interval | 
				| pos |
				pos := interval first.
				self addStyle:  self currentOpenedParenthesisStyleName from: pos to: pos.
				parentheseLevel := parentheseLevel + 1 ] ]
]

{ #category : #private }
StStyleVisitor >> styleTempBars: aRBSequenceNode [ 
	| tempBarAttribute |

	tempBarAttribute := aRBSequenceNode scope isMethodScope
		ifTrue: [ #methodTempBar ]
		ifFalse: [ #blockTempBar ].
	aRBSequenceNode leftBar ifNotNil: [ :pos | 
		self addStyle: tempBarAttribute from: pos to: pos ].
	aRBSequenceNode rightBar ifNotNil: [ :pos | 
		self addStyle: tempBarAttribute from: pos to: pos ]
]

{ #category : #accessing }
StStyleVisitor >> tags [

	^ tags
]

{ #category : #'private visiting' }
StStyleVisitor >> visitAST: ast [
	| context |

	self reset.
	context := (Smalltalk compiler compilationContextClass new
		class: contextClass;
		forSyntaxHighlighting: true;
		requestor: nil;
		yourself).
	ast methodNode compilationContext: context.
	ast doSemanticAnalysis.

	ast acceptVisitor: self
]

{ #category : #'private visiting' }
StStyleVisitor >> visitArgumentNode: aRBArgumentNode [ 
	| blockOrMethodArgStyle |
	
	blockOrMethodArgStyle := self methodOrBlockArgStyleFor: aRBArgumentNode.
	self 
		addStyle: blockOrMethodArgStyle 
		from: aRBArgumentNode start
		to: aRBArgumentNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitAssignmentNode: aRBAssignmentNode [

	self visitNode: aRBAssignmentNode variable.
	self visitNode: aRBAssignmentNode value.
	aRBAssignmentNode variable binding isWritable
		ifFalse: [ self addStyle: #invalid forNode: aRBAssignmentNode ]
]

{ #category : #'private visiting' }
StStyleVisitor >> visitBlockNode: aRBBlockNode [ 

	aRBBlockNode comments do: [ :comment | self addStyle: #comment from: comment start to: comment stop ].
	aRBBlockNode arguments do: [ :argument | self addStyle: #blockPatternArg from: argument start to: argument stop ].
	aRBBlockNode bar ifNotNil: [ :pos | self addStyle: #blockArgsBar from: pos to: pos ].
	aRBBlockNode colons do: [ :pos | self addStyle: #blockArgColon from: pos to: pos ].
	
	self styleOpenBracket: aRBBlockNode.
	self visitNode: aRBBlockNode body.
	self styleCloseBracket: aRBBlockNode
]

{ #category : #'private visiting' }
StStyleVisitor >> visitCascadeNode: aRBCascadeNode [

	aRBCascadeNode messages do: [ :each | self visitNode: each ].
	aRBCascadeNode semicolons do: [ :pos | self addStyle: #cascadeSeparator from: pos to: pos ]
]

{ #category : #visiting }
StStyleVisitor >> visitExpression: aString [

	self visitAST: (RBParser parseFaultyExpression: aString).
	^ self tags
]

{ #category : #'private visiting' }
StStyleVisitor >> visitGlobalNode: aRBGlobalNode [

	self 
		addStyle: #global 
		from: aRBGlobalNode start 
		to: aRBGlobalNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitLiteralArrayNode: aRBLiteralArrayNode [
	"in a (valid) byte array all elements are of the same type, style the whole 
	 contents at once, but for ordinary literal arrays, style every node"

	(aRBLiteralArrayNode isForByteArray 
		and: [ aRBLiteralArrayNode isFaulty not 
		and: [ aRBLiteralArrayNode contents isNotEmpty ] ]) 
		ifTrue: [ 
			self addStyle: #number 
				from: aRBLiteralArrayNode start + 2 
				to: aRBLiteralArrayNode stop - 1 ]
		ifFalse: [ 
			aRBLiteralArrayNode contents do: [ :each | self visitNode: each ] ]
]

{ #category : #'private visiting' }
StStyleVisitor >> visitLiteralNode: aRBLiteralValueNode [ 
	| value |
	
	value := aRBLiteralValueNode value.
	self 
		addStyle: (self literalStyleSymbol: value)
		from: aRBLiteralValueNode start
		to: aRBLiteralValueNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitMessageNode: aRBMessageNode [ 
	| style link |
	
	style := #keyword.
	(Symbol findInternedSelector: aRBMessageNode selector asString) 
		ifNil: [ 
			style := (Symbol selectorThatStartsCaseSensitive: aRBMessageNode selector asString skipping: nil) isNil
				ifTrue: [ #undefinedKeyword ]
				ifFalse: [ #incompleteKeyword ] ].

	self styleOpenParenthese: aRBMessageNode.
	aRBMessageNode selectorParts
		with: aRBMessageNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: style
				from: position
				to: position + keyword size - 1 ].
	(aRBMessageNode isCascaded not or: [ aRBMessageNode isFirstCascaded ])
		ifTrue: [ self visitNode: aRBMessageNode receiver ].
	aRBMessageNode arguments do: [ :each | self visitNode: each ].
	self styleCloseParenthese: aRBMessageNode
]

{ #category : #visiting }
StStyleVisitor >> visitMethod: aString [

	self visitAST: (RBParser parseFaultyMethod: aString).
	^ self tags
]

{ #category : #'private visiting' }
StStyleVisitor >> visitMethodComments: comments [

	comments do: [ :comment | self addStyle: #comment from: comment start to: comment stop ].
	"PharoDocCommentNode docCommentEnabled
		ifTrue: [ comments do: [ :comment | self styleDocComment: comment ] ]"
]

{ #category : #'private visiting' }
StStyleVisitor >> visitMethodNode: aRBMethodNode [ 
	
	self visitMethodComments: aRBMethodNode comments.
	
	"aMethodNode arguments do: [ :argument | self addStyle: #patternArg forNode: argument ].
	link := TextMethodLink selector: aMethodNode selector."
	aRBMethodNode selectorParts
		with: aRBMethodNode keywordsPositions
		do: [ :keyword :position | 
			self
				addStyle: #patternKeyword
				from: position
				to: position + keyword size - 1 ].
	aRBMethodNode pragmas do: [ :each | self visitNode: each ].	
	
	self visitNode: aRBMethodNode body
]

{ #category : #'private visiting' }
StStyleVisitor >> visitNode: aRBNode [ 
	
	aRBNode comments do: [ :comment |
		self 
			addStyle: #comment
			from: comment start
			to: comment stop ].

	^ aRBNode acceptVisitor: self
]

{ #category : #'private visiting' }
StStyleVisitor >> visitParseErrorNode: aRBParseErrorNode [ 
	
	self 
		addStyle: #invalid
		from: aRBParseErrorNode  start 
		to: aRBParseErrorNode  stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitPragmaNode: aRBPragmaNode [ 

	aRBPragmaNode selectorParts 
		with: aRBPragmaNode keywordsPositions 
		do: [ :keyword : position |
			self 
				addStyle: #pragmaKeyword
				from: position
				to: position + keyword size ].
	
	aRBPragmaNode arguments do: [ :each | self visitNode: each ]	
]

{ #category : #'private visiting' }
StStyleVisitor >> visitReturnNode: aRBReturnNode [ 
	
	self 
		addStyle: #return
		from: aRBReturnNode start
		to: aRBReturnNode stop.
		
	self visitNode: aRBReturnNode value
]

{ #category : #'private visiting' }
StStyleVisitor >> visitSelfNode: aRBSelfNode [
	
	self 
		addStyle: #self
		from: aRBSelfNode start
		to: aRBSelfNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitSequenceNode: aRBSequenceNode [ 
	| patternTempStyle |
	
	patternTempStyle := self methodOrBlockTempDeclStyleFor: aRBSequenceNode.
	self styleTempBars: aRBSequenceNode.
	aRBSequenceNode temporaries do: [ :temporary | 
		self 
			addStyle: patternTempStyle 
			from: temporary start
			to: temporary stop ].
	aRBSequenceNode statements do: [ :each | self visitNode: each ].
	aRBSequenceNode periods do: [ :pos | 
		self 
			addStyle: #statementSeparator 
			from: pos 
			to: pos ]
]

{ #category : #'private visiting' }
StStyleVisitor >> visitSuperNode: aRBSuperNode [ 

	self 
		addStyle: #super 
		from: aRBSuperNode start
		to: aRBSuperNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitTemporaryNode: aRBTemporaryNode [ 
	| methodOrBlockTempStyle |
		
	methodOrBlockTempStyle := self methodOrBlockTempStyleFor: aRBTemporaryNode.
	self 
		addStyle: methodOrBlockTempStyle 
		from: aRBTemporaryNode start
		to: aRBTemporaryNode stop
]

{ #category : #'private visiting' }
StStyleVisitor >> visitVariableNode: aRBVariableNode [ 
	
	self 
		addStyle: (self resolveStyleFor: aRBVariableNode) 
		from: aRBVariableNode start
		to: aRBVariableNode stop.
	
	
]
