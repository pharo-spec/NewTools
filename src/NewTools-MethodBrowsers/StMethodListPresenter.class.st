"
I am a presenter listing messages. 

I am used by more complexe browsers such as MessageBrowser or VersionBrowser.
	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	cachedHierarchy:		<aDictionary>	 	A cache keeping info about the level of a class in the list.
	listModel:				<aListPresenter>	A list presenter to show all the messages.
	model:						<aTool>				A model grouping generic methods for managing packages/classes/groups/methods from a browser
	topologySort:			<aBoolean>		 	A boolean to know if we should use a topology sort or not.

"
Class {
	#name : 'StMethodListPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'cachedHierarchy',
		'topologySort',
		'listPresenter',
		'scopes',
		'allMessages',
		'visitedScopes'
	],
	#category : 'NewTools-MethodBrowsers-Base',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Base'
}

{ #category : 'layout' }
StMethodListPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #listPresenter;
		yourself
]

{ #category : 'private - scopes' }
StMethodListPresenter >> allScopes [

	^ OrderedCollection new
		add: self browserEnvironment;
		addAll: self packageEnvironments;
		addAll: self classesEnvironments;		
		addAll: self compositeEnvironments;
		yourself
]

{ #category : 'private - scopes' }
StMethodListPresenter >> browserEnvironment [

	^ RBBrowserEnvironment default label: 'current image'
]

{ #category : 'testing' }
StMethodListPresenter >> buildHierarchyForMessages: messages [
	| result classes |
	self topologicSort ifFalse: [ 
		result := IdentityDictionary new.
		messages do: [:m | result at: m put: {} ].
		^ result ].
	
	result := Dictionary new.	
	classes := (messages collect: [ :each | each methodClass ]) asSet.
	messages do: [:message || level class |
		class := message methodClass.
		level := OrderedCollection new.
		class allSuperclassesDo: [:superClass |
			(classes includes: superClass)
				ifTrue: [ level addFirst: superClass ]].
		level addLast: class.
		level addLast: message selector.
		result at: message put: level ].
	^ result
]

{ #category : 'testing' }
StMethodListPresenter >> cacheHierarchyForClasses: aCollection [
	cachedHierarchy := self buildHierarchyForMessages: aCollection.
]

{ #category : 'private - scopes' }
StMethodListPresenter >> classEnvironmentFor: aClass [
	"Answer a <RBClassEnvironment> for aClass"

	^ RBBrowserEnvironment default forClasses: { aClass }


]

{ #category : 'private - scopes' }
StMethodListPresenter >> classHierarchyEnvironmentFor: aClass [
	"Answer a <RBClassEnvironment> for aClass"

	^ RBBrowserEnvironment default forClassHierarchy: aClass


]

{ #category : 'private - scopes' }
StMethodListPresenter >> classHierarchyEnvironments [
	"Answer a <Collection> of <RBClassEnvironment> for the receiver's selected classes"
	
	^ self visitedScopes 
		select: [ : anObject | anObject isClass ]
		thenCollect: [ : aClass | self classHierarchyEnvironmentFor: aClass  ]
]

{ #category : 'private' }
StMethodListPresenter >> classHierarchyOf: aCompiledMethod [
	"Answer a <Collection> of superclasses of aCompiledMethod method class"

	^ RBClassHierarchyEnvironment class: aCompiledMethod methodClass
]

{ #category : 'private' }
StMethodListPresenter >> classOf: aCompiledMethod [
	"Answer the <Class> of aCompiledMethod"

	^ aCompiledMethod methodClass
]

{ #category : 'private - scopes' }
StMethodListPresenter >> classesEnvironments [
	"Answer a <Collection> of <RBClassEnvironment> for the receiver's selected classes"
	
	^ self visitedScopes 
		select: [ : anObject | anObject isClass ]
		thenCollect: [ : aClass | self classEnvironmentFor: aClass  ]
]

{ #category : 'private - scopes' }
StMethodListPresenter >> compositeEnvironments [

	^ self visitedScopes reject: [ : anObject | anObject isClass or: [ anObject isPackage ] ]


]

{ #category : 'transmission' }
StMethodListPresenter >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : 'private - scopes' }
StMethodListPresenter >> defaultScopes [
	"Private - By default we answer the <Package> of the currently selected item"

	^ self selectedMethod
		ifNil: [ Set empty ]
		ifNotNil: [ 
			Set new
				add: (self packageOf: self selectedMethod);
				add: (self classOf: self selectedMethod);
				add: (self classHierarchyOf: self selectedMethod);
				addAll: ScopesManager availableScopes;
				yourself ]
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseImplementors [
		
	StMethodBrowser browseImplementorsOf: self selectedMethod selector
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseMethod [
		
	self systemNavigation browse: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseSenders [

	StMethodBrowser browseSendersOf: self selectedMethod selector
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseUsers [
		
	self systemNavigation browseAllUsersOfClassOrTrait: self selectedMethod methodClass
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseVersions [
	
	self systemNavigation browseVersionsOf: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doInspectMethod [
	
	self systemNavigation inspect: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doRemoveMethod [

	self selectedMethod ifNotNil: [ :aMethod |
		SystemNavigation new 
			removeMethod: aMethod 
			inClass: aMethod methodClass ]
]

{ #category : 'initialization' }
StMethodListPresenter >> initialize [

	super initialize.
	topologySort := true.
	allMessages := Set empty.
]

{ #category : 'initialization' }
StMethodListPresenter >> initializePresenters [

	listPresenter := self newTable.
	listPresenter
		sortingBlock: [ :a :b | self sortClassesInCachedHierarchy: a b: b ];
		addColumn: (SpStringTableColumn 
			title: 'Location' 
			evaluated: [ :item | self locationOf: item ]);
		addColumn: (SpStringTableColumn 
			title: 'Selector' 
			evaluated: [ :item | self selectorOf: item ]);
		addColumn: (SpStringTableColumn 
			title: 'Package' 
			evaluated: [ :item | self packageNameOf: item ]);
		beResizable.

	listPresenter outputActivationPort transmitDo: [ :aMethod | self doBrowseMethod ].
	listPresenter actions: self methodListActions
]

{ #category : 'accessing' }
StMethodListPresenter >> listPresenter [

	^ listPresenter
]

{ #category : 'accessing' }
StMethodListPresenter >> locationOf: anItem [

	^ String streamContents: [ :aStream | 
		3 to: (cachedHierarchy at: anItem) size do: [ :i | aStream << '    ' ].
		aStream << (self methodClassNameForItem: anItem) << ' ('.
		anItem isFromTrait
			ifTrue: [ aStream
					<< anItem compiledMethod origin name;
					space ].
		aStream << (self protocolNameForItem: anItem) << ')' ]
]

{ #category : 'private' }
StMethodListPresenter >> methodClassNameForItem: anItem [
	^ anItem methodClass ifNotNil: [ :class | class name ] ifNil: [ '' ]
]

{ #category : 'private' }
StMethodListPresenter >> methodListActions [
	
	^ CmCommandGroup forSpec
		beRoot;
		register: ((CmCommandGroup forSpecNamed: 'View')
			beDisplayedAsGroup;
			register: (StMethodBrowseFullCommand forSpecContext: self);
			register: (StInspectMethodCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'Navigation')
			beDisplayedAsGroup;
			register: (StMessageSendersCommand forSpecContext: self);
			register: (StImplementorsCommand forSpecContext: self);
			register: (StClassReferencesCommand forSpecContext: self);
			register: (StMethodVersionsCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StRemoveMethodCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : 'accessing' }
StMethodListPresenter >> methods [

	^ listPresenter items
]

{ #category : 'accessing' }
StMethodListPresenter >> methods: aCollection [

	self cacheHierarchyForClasses: aCollection.
	listPresenter items: cachedHierarchy keys asOrderedCollection.
	allMessages := listPresenter items.
	listPresenter listSize > 0 ifTrue: [ 
		listPresenter selectIndex: 1 ]
]

{ #category : 'accessing' }
StMethodListPresenter >> numberOfElements [

	^ listPresenter listSize
]

{ #category : 'transmission' }
StMethodListPresenter >> outputActivationPort [

	^ (SpActivationPort newPresenter: self)
		delegateTo: [ listPresenter ];
		yourself
]

{ #category : 'transmission' }
StMethodListPresenter >> outputSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ listPresenter ];
		yourself
]

{ #category : 'private - scopes' }
StMethodListPresenter >> packageEnvironmentFor: aPackage [
	"Answer a <RBPackageEnvironment> for the selected packages"

	^ RBBrowserEnvironment default forPackages: { aPackage }


]

{ #category : 'private - scopes' }
StMethodListPresenter >> packageEnvironments [
	"Answer a <Collection> of <RBPackageEnvironment> for the receiver's selected packages"

	^ self visitedScopes 
		select: [ : anObject | anObject isPackage ]
		thenCollect: [ : aPackage | self packageEnvironmentFor: aPackage ]


]

{ #category : 'private' }
StMethodListPresenter >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'private' }
StMethodListPresenter >> packageNameOf: anItem [
	"Answer a <String> matching anItem"

	^ '[' , (self packageNameForItem: anItem) , ']'
]

{ #category : 'private' }
StMethodListPresenter >> packageOf: aCompiledMethod [
	"Answer the <Package> of aCompiledMethod"

	^ self packageOrganizer packageOf: aCompiledMethod methodClass
]

{ #category : 'private' }
StMethodListPresenter >> protocolNameForItem: anItem [

	^ anItem protocolName ifNil: [ '' ]
]

{ #category : 'private - scopes' }
StMethodListPresenter >> scopes [
	"Answer a <Collection> of the receiver's message list scopes"
	
	^ scopes
		ifNil: [ scopes := self allScopes ]
]

{ #category : 'selecting' }
StMethodListPresenter >> selectIndex: anInteger [

	listPresenter selectIndex: anInteger
]

{ #category : 'selecting' }
StMethodListPresenter >> selectedIndex [

	^ listPresenter selection selectedIndex
]

{ #category : 'accessing' }
StMethodListPresenter >> selectedMethod [

	^ listPresenter selection selectedItem
]

{ #category : 'accessing' }
StMethodListPresenter >> selectorOf: anItem [

	^ anItem selector
]

{ #category : 'accessing - model' }
StMethodListPresenter >> setModelBeforeInitialization: aMethod [
]

{ #category : 'sorting' }
StMethodListPresenter >> sortClassesInCachedHierarchy: aMethodDefinition b: otherMethodDefinition [
	"This method checks wether the cached inheritance hierarchy of a method should be before than the one of another method.
	It compares alphabetically the hierarchy using #compare:
	If both are alphabetically equals, it uses the size the hierarchy.
	We do not know why this is done like this."
	| aMethodHierarchy otherMethodHierarchy minSize|
	aMethodHierarchy := cachedHierarchy at: aMethodDefinition.
	otherMethodHierarchy := cachedHierarchy at: otherMethodDefinition.
	
	minSize := aMethodHierarchy size min: otherMethodHierarchy size.
	
	1 to: minSize do: [ :i | |compare|
		compare := (aMethodHierarchy at: i) printString compare: (otherMethodHierarchy at: i) printString.
		compare ~~ 2
			ifTrue: [  ^ compare == 1 ]].
	^  aMethodHierarchy size < otherMethodHierarchy size
]

{ #category : 'api' }
StMethodListPresenter >> sortingBlock: aBlock [

	listPresenter sortingBlock: aBlock
]

{ #category : 'private - scopes' }
StMethodListPresenter >> switchScopeTo: aRBBrowserEnvironment [ 
	"Private - Callback to scope selection from the user"

	listPresenter items: (aRBBrowserEnvironment selectMessagesFrom: allMessages)

]

{ #category : 'accessing' }
StMethodListPresenter >> topologicSort [

	^ topologySort
]

{ #category : 'accessing' }
StMethodListPresenter >> topologicSort: anObject [

	topologySort := anObject
]

{ #category : 'private - scopes' }
StMethodListPresenter >> updateVisitedScopesFrom: aCompiledMethod [
	"Private - Update the list of the visited scopes"

	visitedScopes 
		ifNotNil: [ 
			visitedScopes 
				add: (self packageOf: aCompiledMethod);
				add: (self classOf: aCompiledMethod);
				add: (self classHierarchyOf: aCompiledMethod) ]
]

{ #category : 'private - scopes' }
StMethodListPresenter >> visitedScopes [
	"Answer a <Collection> of <Package> which has been selected in the receiver"
	
	^ visitedScopes
		ifNil: [ visitedScopes := self defaultScopes ]


]

{ #category : 'api - events' }
StMethodListPresenter >> whenModelChangedDo: aBlock [
	listPresenter whenModelChangedDo: aBlock
]

{ #category : 'api - events' }
StMethodListPresenter >> whenSelectedDo: aBlock [

	listPresenter whenSelectedDo: aBlock
]

{ #category : 'api - events' }
StMethodListPresenter >> whenSelectionChangedDo: aBlock [

	listPresenter whenSelectionChangedDo: aBlock
]
