"
I cache all message nodes that are halts in the system. 
There is already a breakpoint cache in the Breakpoint class.

The cache is built when I am initialized,  then I register to the method changes system announcement to update the cache each time a method is added, modified or removed.

I associate the selector of methods in which I found halts to a set holding the AST nodes of those halts.

For now it is a simple cache that does not require as much functionality than AbstractCache provides, so it does not subclass it.
However, it might be interesting if I evolve later, or if I need safe concurrent access (which AbstractCache provides).
"
Class {
	#name : #StHaltCache,
	#superclass : #Object,
	#instVars : [
		'methodsWithHalts',
		'shouldNotifyCacheChanges'
	],
	#classVars : [
		'DefaultCache'
	],
	#category : #'NewTools-Debugger-Model'
}

{ #category : #'accessing - cache' }
StHaltCache class >> defaultCache [
	^ DefaultCache ifNil: [ DefaultCache := self new ]
]

{ #category : #'accessing - cache' }
StHaltCache class >> reset [
	<script>
	DefaultCache
		ifNotNil: [ DefaultCache removeSubscriptions.
			DefaultCache := nil ]
]

{ #category : #cache }
StHaltCache >> buildCache [
	SystemNavigation new allHalts
		do: [ :compiledMethod | self buildCacheForMethod: compiledMethod ]
]

{ #category : #cache }
StHaltCache >> buildCacheForMethod: aCompiledMethod [
	"- extract all halt nodes from the method's ast
	- extract all nodes with installed breakpoints from the method's ast
	- cache all extracted nodes into the methodsWithHalts dictionary"

	| ast haltNodes |
	(self shouldConsiderMethod: aCompiledMethod)
		ifFalse: [ ^ self ].
	ast := aCompiledMethod ast.
	haltNodes := ast sendNodes
		select: [ :node | '*halt*' match: node selector ].
	haltNodes
		ifEmpty: [ self uncacheMethod: aCompiledMethod selector.
			^ self ].
	self setNodeCache: haltNodes forSelector: aCompiledMethod selector.
	self cacheChanged
]

{ #category : #notifying }
StHaltCache >> cacheChanged [
	self shouldNotifyCacheChanges ifFalse:[^self].
	SystemAnnouncer uniqueInstance announce: StHaltCacheChanged
]

{ #category : #cache }
StHaltCache >> cacheNode: aNode forSelector: aMethodSelector [
	(methodsWithHalts at: aMethodSelector ifAbsentPut: IdentitySet new)
		add: aNode
]

{ #category : #initialization }
StHaltCache >> initialize [
	methodsWithHalts := Dictionary new.
	self buildCache.
	SystemAnnouncer uniqueInstance weak when: MethodModified send: #methodChanged: to: self.
	SystemAnnouncer uniqueInstance weak when: MethodRemoved send: #methodRemoved: to: self.
	SystemAnnouncer uniqueInstance weak when: MethodAdded send: #methodAdded: to: self
]

{ #category : #notifying }
StHaltCache >> methodAdded: methodAddedAnnouncement [
	self buildCacheForMethod: methodAddedAnnouncement methodAdded
]

{ #category : #notifying }
StHaltCache >> methodChanged: methodCModifiedAnnouncement [
	self buildCacheForMethod: methodCModifiedAnnouncement newMethod
]

{ #category : #notifying }
StHaltCache >> methodRemoved: methodRemovedAnnouncement [
	self uncacheMethod: methodRemovedAnnouncement methodRemoved selector
]

{ #category : #accessing }
StHaltCache >> methodsWithHalts [
	^ methodsWithHalts
]

{ #category : #cache }
StHaltCache >> nodeCacheForSelector: aMethodSelector [
	^ methodsWithHalts at: aMethodSelector ifAbsent: #()
]

{ #category : #subscription }
StHaltCache >> removeSubscriptions [
	SystemAnnouncer uniqueInstance unsubscribe: self
]

{ #category : #cache }
StHaltCache >> setNodeCache: haltAndBreakpointNodes forSelector: aSelector [
	methodsWithHalts at: aSelector put: haltAndBreakpointNodes
]

{ #category : #testing }
StHaltCache >> shouldConsiderMethod: aCompiledMethod [
	"We do not consider test methods"

	^ (('test*' match: aCompiledMethod selector)
		"or: [ '*test*' match: aCompiledMethod methodClass name asLowercase ]")
		not
]

{ #category : #accessing }
StHaltCache >> shouldNotifyCacheChanges [
	^ shouldNotifyCacheChanges ifNil:[true]
]

{ #category : #accessing }
StHaltCache >> shouldNotifyCacheChanges: anObject [
	shouldNotifyCacheChanges := anObject
]

{ #category : #cache }
StHaltCache >> uncacheMethod: aMethodSelector [
	"Methods not in the cache are irrelevant, so we don't care if they are absent from the dictionary"

	(methodsWithHalts keys includes: aMethodSelector)
		ifFalse: [ ^ self ].
	methodsWithHalts removeKey: aMethodSelector.
	self cacheChanged
]
