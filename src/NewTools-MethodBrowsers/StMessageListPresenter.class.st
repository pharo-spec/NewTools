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
		'listPresenter'
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

{ #category : 'transmission' }
StMessageListPresenter >> defaultOutputPort [

	^ self outputSelectionPort
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseImplementors [
		
	self systemNavigation browseAllImplementorsOf: self selectedMethod selector
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseMethod [
		
	self systemNavigation browse: self selectedMethod
]

{ #category : 'private - actions' }
StMessageListPresenter >> doBrowseSenders [

	self systemNavigation browseAllSendersOf: self selectedMethod selector
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
	topologySort := true

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
			evaluated: [ :item | self packageOf: item ]);
		beResizable.
		
	listPresenter outputActivationPort transmitDo: [ :aMethod | self doBrowseMethod ].
		
	listPresenter 
		contextMenu: self messageListActions asMenuPresenter;
		contextKeyBindings: self messageListActions asKMCategory
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

{ #category : 'private' }
StMessageListPresenter >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'private' }
StMessageListPresenter >> packageOf: anItem [
	^ '[' , (self packageNameForItem: anItem) , ']'
]

{ #category : 'private' }
StMessageListPresenter >> protocolNameForItem: anItem [

	^ anItem protocolName ifNil: [ '' ]
]

{ #category : 'selecting' }
StMessageListPresenter >> selectIndex: anInteger [

	listPresenter selectIndex: anInteger
]

{ #category : 'accessing' }
StMessageListPresenter >> selectMessage: aMessage [

	listPresenter selectItem: aMessage
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

{ #category : 'initialization' }
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

{ #category : 'accessing' }
StMessageListPresenter >> topologicSort [

	^ topologySort
]

{ #category : 'accessing' }
StMessageListPresenter >> topologicSort: anObject [

	topologySort := anObject
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
