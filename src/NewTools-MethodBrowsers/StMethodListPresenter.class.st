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
		'visitedScopes',
		'navigationBlock'
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

{ #category : 'sorting' }
StMethodListPresenter >> buildHierarchyForMessages: messages [

	| result classes |
	self topologicSort ifFalse: [
			result := OrderedIdentityDictionary new.
			messages do: [ :m | result at: m put: {  } ].
			^ result ].

	result := OrderedDictionary new.
	classes := (messages collect: [ :each | each methodClass ]) asSet.
	messages do: [ :message |
			| level class |
			class := message methodClass.
			level := OrderedCollection new.
			class allSuperclassesDo: [ :superClass | (classes includes: superClass) ifTrue: [ level addFirst: superClass ] ].
			level addLast: class.
			level addLast: message selector.
			result at: message put: level ].
	^ result
]

{ #category : 'testing' }
StMethodListPresenter >> cacheHierarchyForClasses: aCollection [
	cachedHierarchy := self buildHierarchyForMessages: aCollection.
]

{ #category : 'accessing' }
StMethodListPresenter >> callerClass [

	^ owner callerClass
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
	"Private - Answer scopes from both the caller class and the currently selected method"

	| scopeSet |
	scopeSet := Set new.

	self callerClass ifNotNil: [ :caller |
			scopeSet
				add: (self packageOrganizer packageOf: caller);
				add: caller;
				add: (RBClassHierarchyEnvironment class: caller) ].


	self selectedMethod ifNotNil: [ :method |
			scopeSet
				add: (self packageOf: method);
				add: (self classOf: method);
				add: (self classHierarchyOf: method) ].

	scopeSet addAll: ScopesManager availableScopes.
	^ scopeSet
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseHistory [

	| browserClass packageName repositoriesWithPackage repository |
	packageName := self selectedMethod package name.
	repositoriesWithPackage := IceRepository registry select: [ :repo | repo includesPackageNamed: packageName ].

	repositoriesWithPackage ifEmpty: [
			self application inform: 'No repositories include package ' , packageName.
			^ self ].

	repository := repositoriesWithPackage size > 1
		              ifTrue: [
				              SpSelectDialog new
					              application: self application;
					              title: 'Choose a repository';
					              message: 'Please select the repository for package ' , packageName;
					              items: repositoriesWithPackage;
					              display: [ :each | each name ];
					              openModal ]
		              ifFalse: [ repositoriesWithPackage anyOne ].

	repository ifNil: [ ^ self ].

	self flag: #pharoTodo.
	browserClass := #IceTipVersionHistoryBrowser asClassInEnvironment: self class environment.
	(browserClass onRepository: repository method: self selectedMethod) open
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseImplementors [

	| selectors |
	selectors := self selectedMethods collect: [ :method | method selector ].

	navigationBlock
		ifNotNil: [ navigationBlock value: #implementorsAll value: selectors ]
		ifNil: [ StMethodBrowser browseImplementorsOfAll: selectors from: self class ]
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseMethod [
		
	self systemNavigation browse: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseSenders [

	| selectors |
	selectors := self selectedMethods collect: [ :method | method selector ].

	navigationBlock
		ifNotNil: [ navigationBlock value: #sendersAll value: selectors ]
		ifNil: [ StMethodBrowser browseSendersOfAll: selectors from: self class]
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseUsers [

	| class |
	class := self selectedMethod methodClass.

	navigationBlock
		ifNotNil: [ navigationBlock value: #references value: class ]
		ifNil: [ StMethodBrowser browseReferencesToClass: class ]
]

{ #category : 'private - actions' }
StMethodListPresenter >> doBrowseVersions [
	
	self systemNavigation browseVersionsOf: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doCopy [

	| text |
	text := (self selectedMethods collect: #displayString) joinUsing: String cr.
	Clipboard clipboardText: text.
	self application inform: 'Copied methods:' , String cr , text
]

{ #category : 'private - actions' }
StMethodListPresenter >> doInspectMethod [
	
	self systemNavigation inspect: self selectedMethod
]

{ #category : 'private - actions' }
StMethodListPresenter >> doRunTests [

	| testMethods |
	testMethods := self methods select: [ :each | each isTestMethod ].

	testMethods ifEmpty: [
			self application inform: 'No test found in the list.'.
			^ self ].
	testMethods do: [ :m | self executeTestFor: m debug: false ]
]

{ #category : 'execution' }
StMethodListPresenter >> executeTestFor: aMethod debug: shouldDebug [

	| selector testClasses suite result |
	aMethod ifNil: [ ^ self ].

	selector := aMethod selector.

	testClasses := aMethod methodClass isAbstract
		               ifTrue: [ aMethod methodClass allSubclasses ]
		               ifFalse: [ { aMethod methodClass } ].

	suite := TestSuite named: selector.

	testClasses do: [ :each | suite addTest: (each selector: selector) ].

	result := shouldDebug
		          ifTrue: [ suite debug ]
		          ifFalse: [ suite run ].
	result updateResultsInHistory.

	self application inform: result printString.

	listPresenter updateItemsKeepingSelection: listPresenter items
]

{ #category : 'initialization' }
StMethodListPresenter >> handleTestResultChanged: anAnnouncement [

	self defer: [ listPresenter updateItemsKeepingSelection: listPresenter items ]
]

{ #category : 'initialization' }
StMethodListPresenter >> initialize [

	super initialize.
	topologySort := true.
	allMessages := Set empty.
	self registerToTestAnnouncements
]

{ #category : 'initialization' }
StMethodListPresenter >> initializePresenters [

	listPresenter := self newEasyColumnView.
	listPresenter beMultipleSelection.
	listPresenter
		addColumn: (SpColumnViewColumn new
				 title: 'Location';
				 bind: [ :p :item | p label: (self locationOf: item) ];
				 yourself);
		addColumn: (StTestIconColumnView new
				 executeBlock: [ :method | self executeTestFor: method debug: true ];
				 cellPresenterClass: StTestIconCellPresenter;
				 width: 20;
				 yourself);
		addColumn: (SpColumnViewColumn new
				 title: 'Selector';
				 sortFunction: #selector ascending;
				 bind: [ :labelPresenter :item |
						 labelPresenter label: (self selectorOf: item).
						 labelPresenter displayStrikethrough: [ item isDeprecated ] ];
				 yourself);
		addColumn: (SpColumnViewColumn new
				 title: 'Package';
				 sortFunction: [ :item | self packageNameOf: item ] ascending;
				 bind: [ :p :item | p label: (self packageNameOf: item) ];
				 yourself);
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
				   register: (StRunMethodTestCommand forSpecContext: self);
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
				   register: (StRemoveMethodsCommand forSpecContext: self);
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
	listPresenter items:
		(cachedHierarchy keys asSortedCollection: [ :method :otherMethod | self should: method havePriorityOver: otherMethod ]) asOrderedCollection.
	allMessages := listPresenter items.


]

{ #category : 'accessing' }
StMethodListPresenter >> navigationBlock: aBlock [

	navigationBlock := aBlock
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

{ #category : 'initialization' }
StMethodListPresenter >> registerToTestAnnouncements [

	TestCase historyAnnouncer weak when: TestSuiteEnded send: #handleTestResultChanged: to: self
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

{ #category : 'api - accessing' }
StMethodListPresenter >> selectedMethods [

	^ listPresenter selection selectedItems
]

{ #category : 'accessing' }
StMethodListPresenter >> selectorOf: anItem [

	^ anItem selector
]

{ #category : 'accessing - model' }
StMethodListPresenter >> setModelBeforeInitialization: aMethod [
]

{ #category : 'sorting' }
StMethodListPresenter >> should: aMethodDefinition havePriorityOver: anotherMethodDefinition [

	| hierarchyA hierarchyB minSize answer |
	hierarchyA := cachedHierarchy at: aMethodDefinition ifAbsent: [ #(  ) ].
	hierarchyB := cachedHierarchy at: anotherMethodDefinition ifAbsent: [ #(  ) ].

	minSize := (hierarchyA size min: hierarchyB size) - 1.

	1 to: minSize do: [ :i |
		answer ifNil: [
			(hierarchyA at: i) == (hierarchyB at: i) ifFalse: [ answer := (hierarchyA at: i) name < (hierarchyB at: i) name ] ] ].

	^ answer ifNil: [ hierarchyA size <= hierarchyB size ]
]

{ #category : 'api' }
StMethodListPresenter >> sortingBlock: aBlock [

	listPresenter sortingBlock: aBlock
]

{ #category : 'private - scopes' }
StMethodListPresenter >> switchScopeTo: aRBBrowserEnvironment [
	"Private - Callback to scope selection from the user"

	| scoped source |
	source := (owner allMethods ifNil: [ allMessages ]) ifEmpty: [ allMessages ].
	scoped := aRBBrowserEnvironment selectMessagesFrom: source.
	self methods: (source select: [ :m | scoped includes: m ]).

]

{ #category : 'accessing' }
StMethodListPresenter >> topologicSort [

	^ topologySort
]

{ #category : 'accessing' }
StMethodListPresenter >> topologicSort: anObject [

	topologySort := anObject
]

{ #category : 'api - selection' }
StMethodListPresenter >> unselectAll [

	listPresenter selection unselectAll
]

{ #category : 'private - scopes' }
StMethodListPresenter >> updateVisitedScopesFrom: aCompiledMethod [
	"Private - Update the list of visited scopes from both the caller class and the selected method"

	visitedScopes := Set new.

	self callerClass ifNotNil: [ :caller |
			visitedScopes
				add: (self packageOrganizer packageOf: caller);
				add: caller;
				add: (RBClassHierarchyEnvironment class: caller) ].

	aCompiledMethod ifNil: [ ^ self ].
	visitedScopes
		add: (self packageOf: aCompiledMethod);
		add: (self classOf: aCompiledMethod);
		add: (self classHierarchyOf: aCompiledMethod)
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
