Class {
	#name : #RTPatternMatcherTest,
	#superclass : #TestCase,
	#instVars : [
		'patternMatcher'
	],
	#category : #'NewTools-RewriterTools-Backend-Tests'
}

{ #category : #running }
RTPatternMatcherTest >> setUp [
	super setUp.

	patternMatcher := StRewriterPatternMatcher
]

{ #category : #tests }
RTPatternMatcherTest >> testParseCodeASTIsForMethod [

	| code methodCode codeAST |
	code := '| aNumber |
aNumber ifNil: [ ^ self ].
aNumber := 5.'.
	methodCode := 'calculate
| aNumber |
aNumber ifNil: [ ^ self ].
aNumber := 5.'.

	codeAST := patternMatcher parseCodeAST: code isForMethod: false.
	self
		assert: codeAST sourceCode
		equals: code.

	codeAST := patternMatcher parseCodeAST: methodCode isForMethod: true.
	self
		assert: codeAST sourceCode
		equals: methodCode
]

{ #category : #tests }
RTPatternMatcherTest >> testParsePatternASTIsForMethod [

	| rule methodRule ast |
	rule := '| `object |
`object ifNil: [ ^ self ].
`.Statement.'.
	methodRule := '`aMethod
| `object |
`object ifNil: [ ^ self ].
`.Statement.'.

	ast := patternMatcher parsePatternAST: rule isForMethod: false.
	self
		assert: ast sourceCode
		equals: rule.

	ast := patternMatcher parsePatternAST: methodRule isForMethod: true.
	self
		assert: ast sourceCode
		equals: methodRule
]

{ #category : #tests }
RTPatternMatcherTest >> testPerformMatchingPatternIsForMethod [

	| pharoCode patternCode matches |
	pharoCode := 'a = b ifTrue: [ x = y ifTrue: [ aBlock ] ]'.
	patternCode := '`@expression ifTrue: [ `@codeBlock ]'.
	matches := patternMatcher
		performMatching: pharoCode
		pattern: patternCode
		isForMethod: false.

	self assert: matches size equals: 2
]
