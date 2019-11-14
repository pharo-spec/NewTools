"
I cache all message nodes that:
- are halts
- have a breakpoint on them

The cache is built when I am initialized,  then I register to the method changes system announcement to update the cache each time a method is added, modified or removed.

I associate the selector of methods in which I found halts and breakpoints to a set holding the AST nodes of those halts and breakpoints.
"
Class {
	#name : #StBreakpointCache,
	#superclass : #Object,
	#instVars : [
		'methodsWithHalts'
	],
	#classVars : [
		'DefaultCache'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'accessing - cache' }
StBreakpointCache class >> defaultCache [
	^ DefaultCache ifNil: [ DefaultCache := self new ]
]

{ #category : #cache }
StBreakpointCache >> buildCache [
	SystemNavigation new allHalts
		do: [ :compiledMethod | self buildCacheForMethod: compiledMethod ].
	Breakpoint all do:[:bp| self buildCacheForBreakpoint: bp]
]

{ #category : #cache }
StBreakpointCache >> buildCacheForBreakpoint: aBreakpoint [
	(self nodeCacheForSelector: aBreakpoint node methodNode selector)
		add: aBreakpoint node
]

{ #category : #cache }
StBreakpointCache >> buildCacheForMethod: aCompiledMethod [
	"- extract all halt nodes from the method's ast
	- extract all nodes with installed breakpoints from the method's ast
	- cache all extracted nodes into the methodsWithHalts dictionary"

	| ast haltAndBreakpointNodes |
	ast := aCompiledMethod ast.
	haltAndBreakpointNodes := ast sendNodes
		select: [ :node | '*halt*' match: node selector ].
	haltAndBreakpointNodes
		addAll: (ast allChildren select: [ :node | node hasBreakpoint ]).
	haltAndBreakpointNodes
		ifEmpty: [ self uncacheMethod: aCompiledMethod selector.
			^ self ].
	self
		setNodeCache: haltAndBreakpointNodes
		forSelector: aCompiledMethod selector
]

{ #category : #initialization }
StBreakpointCache >> initialize [
	methodsWithHalts := Dictionary new.
	self buildCache.
	SystemAnnouncer uniqueInstance weak when: MethodModified send: #methodChanged: to: self.
	SystemAnnouncer uniqueInstance weak when: MethodRemoved send: #methodRemoved: to: self.
	SystemAnnouncer uniqueInstance weak when: MethodAdded send: #methodAdded: to: self
]

{ #category : #notifying }
StBreakpointCache >> methodAdded: methodAddedAnnouncement [
	self buildCacheForMethod: methodAddedAnnouncement methodAdded
]

{ #category : #notifying }
StBreakpointCache >> methodChanged: methodCModifiedAnnouncement [
	self buildCacheForMethod: methodCModifiedAnnouncement newMethod
]

{ #category : #notifying }
StBreakpointCache >> methodRemoved: methodRemovedAnnouncement [
	self uncacheMethod: methodRemovedAnnouncement methodRemoved selector
]

{ #category : #accessing }
StBreakpointCache >> methodsWithHalts [
	^ methodsWithHalts
]

{ #category : #cache }
StBreakpointCache >> nodeCacheForSelector: aMethodSelector [
	^ methodsWithHalts
		at: aMethodSelector
		ifAbsentPut: IdentitySet new
]

{ #category : #cache }
StBreakpointCache >> setNodeCache: haltAndBreakpointNodes forSelector: aSelector [
	methodsWithHalts at: aSelector put: haltAndBreakpointNodes
]

{ #category : #cache }
StBreakpointCache >> uncacheMethod: aMethodSelector [
	"Methods not in the cache are irrelevant, so we don't care if they are absent from the dictionary"

	methodsWithHalts removeKey: aMethodSelector ifAbsent: [  ]
]
