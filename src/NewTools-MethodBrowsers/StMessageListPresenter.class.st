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
	#name : 'StMessageListPresenter',
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
StMessageListPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #listPresenter;
		yourself
]

{ #category : 'private - scopes' }
StMessageListPresenter >> allScopes [

	^ OrderedCollection new
		add: self browserEnvironment;
		addAll: self packageEnvironments;
		addAll: self classesEnvironments;		
		addAll: self compositeEnvironments;
		yourself
]

{ #category : 'private - scopes' }
StMessageListPresenter >> browserEnvironment [

	^ RBBrowserEnvironment default label: 'current image'
]

{ #category : 'testing' }
StMessageListPresenter >> buildHierarchyForMessages: messages [
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
StMessageListPresenter >> cacheHierarchyForClasses: aCollection [
	cachedHierarchy := self buildHierarchyForMessages: aCollection.
]

{ #category : 'private - scopes' }
StMessageListPresenter >> classEnvironmentFor: aClass [
	"Answer a <RBClassEnvironment> for aClass"

	^ RBBrowserEnvironment default forClasses: { aClass }


]

{ #category : 'private - scopes' }
StMessageListPresenter >> classHierarchyEnvironmentFor: aClass [
	"Answer a <RBClassEnvironment> for aClass"

	^ RBBrowserEnvironment default forClassHierarchy: aClass


]

{ #category : 'private - scopes' }
StMessageListPresenter >> classHierarchyEnvironments [
	"Answer a <Collection> of <RBClassEnvironment> for the receiver's selected classes"
	
	^ self visitedScopes 
		select: [ : anObject | anObject isClass ]
		thenCollect: [ : aClass | self classHierarchyEnvironmentFor: aClass  ]
]

{ #category : 'private' }
StMessageListPresenter >> classHierarchyOf: aCompiledMethod [
	"Answer a <Collection> of superclasses of aCompiledMethod method class"

	^ RBClassHierarchyEnvironment class: aCompiledMethod methodClass
]

{ #category : 'private' }
StMessageListPresenter >> classOf: aCompiledMethod [
	"Answer the <Class> of aCompiledMethod"

	^ aCompiledMethod methodClass
]

{ #category : 'private - scopes' }
StMessageListPresenter >> classesEnvironments [
	"Answer a <Collection> of <RBClassEnvironment> for the receiver's selected classes"
	
	^ self visitedScopes 
		select: [ : anObject | anObject isClass ]
		thenCollect: [ : aClass | self classEnvironmentFor: aClass  ]
]

{ #category : 'private - scopes' }
StMessageListPresenter >> compositeEnvironments [

	^ self visitedScopes reject: [ : anObject | anObject isClass or: [ anObject isPackage ] ]


]

{ #category : 'transmission' }
StMessageListPresenter >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : 'private - scopes' }
StMessageListPresenter >> defaultScopes [
	"Private - By default we answer the <Package> of the currently selected item"

	^ self selectedMessage
		ifNil: [ Set empty ]
		ifNotNil: [ 
			Set new
				add: (self packageOf: self selectedMessage);
				add: (self classOf: self selectedMessage);
				add: (self classHierarchyOf: self selectedMessage);
				addAll: ScopesManager availableScopes;
				yourself ]
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseImplementors [
		
	StMessageBrowser browseImplementorsOf: self selectedMethod selector
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseMethod [
		
	self systemNavigation browse: self selectedMethod
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseSenders [

	StMessageBrowser browseSendersOf: self selectedMethod selector
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseUsers [
		
	self systemNavigation browseAllUsersOfClassOrTrait: self selectedMethod methodClass
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseVersions [
	
	self systemNavigation browseVersionsOf: self selectedMethod
]

{ #category : 'private - actions' }
StMessageListPresenter >> doInspectMethod [
	
	self systemNavigation inspect: self selectedMethod
]

{ #category : 'private - actions' }
StMessageListPresenter >> doRemoveMethod [

	self selectedMessage ifNotNil: [ :aMethod |
		SystemNavigation new 
			removeMethod: aMethod 
			inClass: aMethod methodClass ]
]

{ #category : 'initialization' }
StMessageListPresenter >> initialize [

	super initialize.
	topologySort := true.
	allMessages := Set empty.
]

{ #category : 'initialization' }
StMessageListPresenter >> initializePresenters [

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
	listPresenter actions: self messageListActions
]

{ #category : 'accessing' }
StMessageListPresenter >> listPresenter [

	^ listPresenter
]

{ #category : 'accessing' }
StMessageListPresenter >> locationOf: anItem [

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
StMessageListPresenter >> messageListActions [
	
	^ CmCommandGroup forSpec
		beRoot;
		register: ((CmCommandGroup forSpecNamed: 'View')
			beDisplayedAsGroup;
			register: (StMessageBrowseFullCommand forSpecContext: self);
			register: (StMessageInspectMethodCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'Navigation')
			beDisplayedAsGroup;
			register: (StMessageSendersCommand forSpecContext: self);
			register: (StMessageImplementorsCommand forSpecContext: self);
			register: (StMessageUsersCommand forSpecContext: self);
			register: (StMessageVersionsCommand forSpecContext: self);
			yourself);
		register: ((CmCommandGroup forSpecNamed: 'CRITICAL')
			beDisplayedAsGroup;
			register: (StMessageRemoveMethodCommand forSpecContext: self);
			yourself);
		yourself
]

{ #category : 'accessing' }
StMessageListPresenter >> messages [

	^ listPresenter items
]

{ #category : 'accessing' }
StMessageListPresenter >> messages: aCollection [

	self cacheHierarchyForClasses: aCollection.
	listPresenter items: cachedHierarchy keys asOrderedCollection.
	allMessages := listPresenter items.
	listPresenter listSize > 0 ifTrue: [ 
		listPresenter selectIndex: 1 ]
]

{ #category : 'private' }
StMessageListPresenter >> methodClassNameForItem: anItem [
	^ anItem methodClass ifNotNil: [ :class | class name ] ifNil: [ '' ]
]

{ #category : 'accessing' }
StMessageListPresenter >> numberOfElements [

	^ listPresenter listSize
]

{ #category : 'transmission' }
StMessageListPresenter >> outputActivationPort [

	^ (SpActivationPort newPresenter: self)
		delegateTo: [ listPresenter ];
		yourself
]

{ #category : 'transmission' }
StMessageListPresenter >> outputSelectionPort [

	^ (SpSelectionPort newPresenter: self)
		delegateTo: [ listPresenter ];
		yourself
]

{ #category : 'private - scopes' }
StMessageListPresenter >> packageEnvironmentFor: aPackage [
	"Answer a <RBPackageEnvironment> for the selected packages"

	^ RBBrowserEnvironment default forPackages: { aPackage }


]

{ #category : 'private - scopes' }
StMessageListPresenter >> packageEnvironments [
	"Answer a <Collection> of <RBPackageEnvironment> for the receiver's selected packages"

	^ self visitedScopes 
		select: [ : anObject | anObject isPackage ]
		thenCollect: [ : aPackage | self packageEnvironmentFor: aPackage ]


]

{ #category : 'private' }
StMessageListPresenter >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'private' }
StMessageListPresenter >> packageNameOf: anItem [
	"Answer a <String> matching anItem"

	^ '[' , (self packageNameForItem: anItem) , ']'
]

{ #category : 'private' }
StMessageListPresenter >> packageOf: aCompiledMethod [
	"Answer the <Package> of aCompiledMethod"

	^ self packageOrganizer packageOf: aCompiledMethod methodClass
]

{ #category : 'private' }
StMessageListPresenter >> protocolNameForItem: anItem [

	^ anItem protocolName ifNil: [ '' ]
]

{ #category : 'private - scopes' }
StMessageListPresenter >> scopes [
	"Answer a <Collection> of the receiver's message list scopes"
	
	^ scopes
		ifNil: [ scopes := self allScopes ]
]

{ #category : 'selecting' }
StMessageListPresenter >> selectIndex: anInteger [

	listPresenter selectIndex: anInteger
]

{ #category : 'selecting' }
StMessageListPresenter >> selectedIndex [

	^ listPresenter selection selectedIndex
]

{ #category : 'accessing' }
StMessageListPresenter >> selectedMessage [

	^ listPresenter selection selectedItem
]

{ #category : 'accessing' }
StMessageListPresenter >> selectedMethod [

	self selectedMessage ifNil: [ ^ nil ].
	^ self selectedMessage compiledMethod
]

{ #category : 'accessing' }
StMessageListPresenter >> selectorOf: anItem [

	^ anItem selector
]

{ #category : 'accessing - model' }
StMessageListPresenter >> setModelBeforeInitialization: aMethod [
]

{ #category : 'sorting' }
StMessageListPresenter >> sortClassesInCachedHierarchy: aMethodDefinition b: otherMethodDefinition [
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
StMessageListPresenter >> sortingBlock: aBlock [

	listPresenter sortingBlock: aBlock
]

{ #category : 'private - scopes' }
StMessageListPresenter >> switchScopeTo: aRBBrowserEnvironment [ 
	"Private - Callback to scope selection from the user"

	listPresenter items: (aRBBrowserEnvironment selectMessagesFrom: allMessages)

]

{ #category : 'accessing' }
StMessageListPresenter >> topologicSort [

	^ topologySort
]

{ #category : 'accessing' }
StMessageListPresenter >> topologicSort: anObject [

	topologySort := anObject
]

{ #category : 'private - scopes' }
StMessageListPresenter >> updateVisitedScopesFrom: aCompiledMethod [
	"Private - Update the list of the visited scopes"

	visitedScopes 
		ifNotNil: [ 
			visitedScopes 
				add: (self packageOf: aCompiledMethod);
				add: (self classOf: aCompiledMethod);
				add: (self classHierarchyOf: aCompiledMethod) ]
]

{ #category : 'private - scopes' }
StMessageListPresenter >> visitedScopes [
	"Answer a <Collection> of <Package> which has been selected in the receiver"
	
	^ visitedScopes
		ifNil: [ visitedScopes := self defaultScopes ]


]

{ #category : 'api - events' }
StMessageListPresenter >> whenModelChangedDo: aBlock [
	listPresenter whenModelChangedDo: aBlock
]

{ #category : 'api - events' }
StMessageListPresenter >> whenSelectedDo: aBlock [

	listPresenter whenSelectedDo: aBlock
]

{ #category : 'api - events' }
StMessageListPresenter >> whenSelectionChangedDo: aBlock [

	listPresenter whenSelectionChangedDo: aBlock
]
