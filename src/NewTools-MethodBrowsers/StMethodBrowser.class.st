"
A MessageBrowser is a UI to browse a list of method, regardless of what they could be.

example: 

MessageBrowser new
	open;
	messages: (SystemNavigation new allSendersOf: #at:)
	yourself
"
Class {
	#name : 'StMethodBrowser',
	#superclass : 'StAbstractMethodCentricBrowserPresenter',
	#instVars : [
		'title',
		'refreshingBlock',
		'textPresenter',
		'highlight'
	],
	#classVars : [
		'UsingLayout'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'tool registration' }
StMethodBrowser class >> beDefaultBrowser [
	<script>
	
	self registerToolsOn: Smalltalk tools
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection [

	^ self new
		methods: aCollection;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection asImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implementors Browser"

	^ self new
		setRefreshingBlockForImplementorsOf: aSymbol;
		methods: aCollection;
		title: 'Implementors of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection asReferencesTo: aClassName [ 
	"Special Version that sets the correct refreshing Block for class references"

	^ self new
		setRefreshingBlockForClassReferencesOf: aClassName;
		highlight: aClassName;
		methods: aCollection;
		title: 'References of ', aClassName printString;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection asSendersOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Senders Browser"

	^ self new
		setRefreshingBlockForSendersOf: aSymbol;
		highlight: aSymbol;
		methods: aCollection;
		title: 'Senders of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection title: aString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"

	^ self new
		methods: aCollection;
		title: aString;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browse: aCollection title: aString highlight: aSelectString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	
	^ self new
		methods: aCollection;
		title: aString;
		highlight: aSelectString;
		open
]

{ #category : 'instance creation' }
StMethodBrowser class >> browseImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	
	^ self browse: (self implementorsOf: aSymbol) asImplementorsOf: aSymbol
]

{ #category : 'instance creation' }
StMethodBrowser class >> browseReferencesOf: aClassName [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self referencesOf: aClassName) asReferencesTo: aClassName
]

{ #category : 'instance creation' }
StMethodBrowser class >> browseSendersOf: aSymbol [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self sendersOf: aSymbol) asSendersOf: aSymbol
]

{ #category : 'private' }
StMethodBrowser class >> implementorsOf: aSymbol [
	"Do not use aSymbol implementors because it is a disguised global"
	
	^ SystemNavigation new allImplementorsOf: aSymbol 
]

{ #category : 'instance creation - old' }
StMethodBrowser class >> openMessageList: messageList name: aString autoSelect: aSelector refreshingBlockSelector: aRefreshingBlockSelector [
	
	| browser |
	browser := self new
		methods: messageList;
		title: aString;
		autoSelect: aSelector;
		yourself.
		
	aRefreshingBlockSelector ifNotNil:[(browser perform: aRefreshingBlockSelector with: aSelector)].
	^browser open
	
				

]

{ #category : 'private' }
StMethodBrowser class >> referencesOf: aSymbol [
	"Do not use aSymbol implementors because it is a disguised global"
	
	^ SystemNavigation new allReferencesTo: aSymbol 
]

{ #category : 'tool registration' }
StMethodBrowser class >> registerToolsOn: registry [

	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #messageList
]

{ #category : 'private' }
StMethodBrowser class >> sendersOf: aSymbol [
	"Do not use aSymbol senders because it is a disguised global"

	^ SystemNavigation default allSendersOf: aSymbol
	
]

{ #category : 'icons' }
StMethodBrowser class >> taskbarIconName [
	"Answer the icon for an instance of the receiver in a task bar"

	^#references
]

{ #category : 'private' }
StMethodBrowser class >> usingLayout [

	^ UsingLayout ifNil: [ UsingLayout := #horizontalLayout ]
]

{ #category : 'private' }
StMethodBrowser class >> usingLayout: aSymbol [

	UsingLayout := aSymbol
]

{ #category : 'private' }
StMethodBrowser >> accept: text notifying: notifyer [

	^ self selectedMethod ifNotNil: [ :message | 
		message methodClass 
			compile: text 
			classified: message protocol
			notifying: notifyer ]
]

{ #category : 'private' }
StMethodBrowser >> addHighlightedSegments [
	| message highlightInterval |

	message := self selectedMethod.
	message ifNil: [ ^ self ].
	
	highlightInterval := (self isMethodDefinition: message)
		ifFalse: [ self intervalOf: highlight inCommentText: textPresenter text ] 
		ifTrue: [ self intervalOf: highlight inCode: textPresenter text of: message ].
		
	textPresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight 
		interval: (highlightInterval first to: highlightInterval last + 1);
		yourself)
]

{ #category : 'to remove' }
StMethodBrowser >> autoSelect: aString [
	"this is just to absorb system navigation for now"
	"once we remove the old message browser we should remove this empty method."
]

{ #category : 'announcements' }
StMethodBrowser >> classRenamed: anAnnouncement [ 
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleClassRenamed: anAnnouncement ]
]

{ #category : 'initialization' }
StMethodBrowser >> connectPresenters [
	
	methodList
		whenSelectionChangedDo: [ :selection | self selectItem: selection selectedItem ];
		whenModelChangedDo: [ self updateTitle ].
		
	textPresenter 
		whenSubmitDo: [ :text | self accept: text notifying: nil ];
		whenResetDo: [ self selectItem: methodList selectedMethod ]	
]

{ #category : 'api - focus' }
StMethodBrowser >> defaultKeyboardFocus [

	^ methodList
]

{ #category : 'layout' }
StMethodBrowser >> defaultLayout [

	^ self perform: self class usingLayout
]

{ #category : 'text selection' }
StMethodBrowser >> findFirstOccurrenceOf: searchedString in: textToSearchIn [
	"Return the first index of aString in textToSearchIn "
	| firstIndex |
	firstIndex := textToSearchIn findString: searchedString startingAt: 1.
	[ (firstIndex > 1) and: [ (textToSearchIn at: (firstIndex - 1)) isAlphaNumeric ] ]
		whileTrue: [
			firstIndex := textToSearchIn findString: searchedString startingAt: firstIndex +1 ].
		
	^ firstIndex
]

{ #category : 'private' }
StMethodBrowser >> flipLayout [

	self class usingLayout: ((self class usingLayout = #horizontalLayout)
		ifTrue: [ #verticalLayout ]
		ifFalse: [ #horizontalLayout ]).
		
	self layout: self defaultLayout
	
]

{ #category : 'announcements' }
StMethodBrowser >> handleClassRenamed: anAnnouncement [
	| items selectedIndex |

	items := self methods
		collect: [ :method | 
			| interestedClassName interestedClass |
			interestedClassName := anAnnouncement oldName.
			interestedClass := anAnnouncement classRenamed.
			method  methodClass isClassSide
				ifTrue: [ interestedClassName := interestedClassName , ' class'.
					interestedClass := interestedClass classSide ].
			method methodClass name = interestedClassName
				ifTrue: [ interestedClass >> method selector ]
				ifFalse: [ method ] ].
	selectedIndex := methodList selectedIndex.
	self methods: items
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodAdded: anAnnouncement [
	| item sel text boolean |

	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	
	item := anAnnouncement method.
	
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifFalse: [ ^ self ].
	((item methodClass isNotNil) and:[item methodClass isObsolete not]) ifFalse: [ ^ self ].
	
	boolean := textPresenter hasUnacceptedEdits.
	boolean ifTrue: [ text := textPresenter pendingText ].
	
	sel := self selectedMethod.
	self methods: (self methods add: item asFullRingDefinition; yourself).
	self selectedMessage: sel.
	
	boolean ifTrue: [ textPresenter pendingText: text ]
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodModified: anAnnouncement [
	| item oldItem sel index text list edits |
	
	self isDisplayed ifFalse: [ ^ self ].
	
	refreshingBlock ifNil: [ ^ self ].
	item := anAnnouncement newMethod.
	oldItem := anAnnouncement oldMethod.
	sel := self selectedMethod.
	sel ifNil: [ ^ self ].
	(sel methodClass = oldItem methodClass
		and: [ sel selector = oldItem selector ])
		ifFalse: [ ^ self ].
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement)
		ifFalse: [ ^ self ].
	
	edits := textPresenter hasUnacceptedEdits.
	edits ifTrue: [ 
		text := textPresenter pendingText ].
	index := methodList selectedIndex.
	list := self methods
		remove: sel ifAbsent: [  ];
		add: item asFullRingDefinition;
		"to ensure it's still a RGMethod"
			yourself.
	self methods: list.
	self selectIndex: index.
	edits ifFalse: [ ^ self ].
	
	textPresenter pendingText: text.
	textPresenter hasEditingConflicts: true
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodRemoved: anAnnouncement [
	| item selection removeItem |

	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	self okToChange ifFalse: [ ^ self ].

	"Item is a compiled methed, where the list is populated with RGMethod"
	item := anAnnouncement method.
	(item methodClass isNotNil and: [ item methodClass isObsolete not ])
		ifFalse: [ ^ self ].
	selection := methodList selectedIndex.
	removeItem := self selectedMethod.

	self methods: (self methods
		remove: item ifAbsent: [ nil ];
		yourself).
	self selectIndex: (selection min: self methods size)
]

{ #category : 'text selection' }
StMethodBrowser >> highlight: aSelector [

	highlight := aSelector.
	self addHighlightedSegments

]

{ #category : 'layout' }
StMethodBrowser >> horizontalLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newLeftToRight
			add: methodList;
			add: (SpBoxLayout newTopToBottom
				add: textPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
StMethodBrowser >> initialize [

	super initialize.
	self registerToAnnouncements
]

{ #category : 'initialization' }
StMethodBrowser >> initializeDropList [

	toolbarPresenter 
		addItemLabeled: 'Source' do: [ self textConverter: SourceMethodConverter new ];
		addItemLabeled: 'Time stamp' do: [ self textConverter: TimeStampMethodConverter new ]
]

{ #category : 'initialization' }
StMethodBrowser >> initializePresenters [

	super initializePresenters.

	textPresenter := self newCode.
	refreshingBlock := [ :item | true ].

	self initializeDropList
]

{ #category : 'private' }
StMethodBrowser >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches))"

	(self isMethodDefinition: anItem)
		ifFalse: [ ^ self ].
	
	IconStyler withStaticStylers 
		styleText: textPresenter 
		withAst: anItem ast.
]

{ #category : 'private' }
StMethodBrowser >> intervalOf: aSelector inCode: aText of: aMethod [

	aMethod compiledMethod ifNil: [  ^ 0 to: 0 ].
	^ (self sourceIntervalOf: aSelector in: aMethod ast) 
		ifEmpty: [ self searchedString: aSelector asString in: aText ]
]

{ #category : 'private' }
StMethodBrowser >> intervalOf: aSelector inCommentText: aText [
	^ self searchedString: aSelector asString in: aText
]

{ #category : 'announcements' }
StMethodBrowser >> methodAdded: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleMethodAdded: anAnnouncement ]
]

{ #category : 'private' }
StMethodBrowser >> methodClassNameForItem: anItem [
	^ anItem methodClass ifNotNil: [ :class | class name ] ifNil: [ '' ]
]

{ #category : 'announcements' }
StMethodBrowser >> methodModified: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [	
		self handleMethodModified: anAnnouncement ]
]

{ #category : 'announcements' }
StMethodBrowser >> methodRemoved: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [ 
		self handleMethodRemoved: anAnnouncement ]
]

{ #category : 'api' }
StMethodBrowser >> methods [
	^ methodList methods
]

{ #category : 'api' }
StMethodBrowser >> methods: aCollection [

	methodList methods: aCollection.
	self toolbarPresenter updatePresenter.
]

{ #category : 'initialization' }
StMethodBrowser >> newMethodToolbar [

	^ (self instantiate: StMethodBrowserToolbarPresenter)
		whenFlipLayoutDo: [ self flipLayout ];
		yourself
]

{ #category : 'private' }
StMethodBrowser >> numberOfElements [ 
	
	^ methodList ifNil: [ 0 ] ifNotNil: [ methodList numberOfElements ]
]

{ #category : 'private' }
StMethodBrowser >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'api' }
StMethodBrowser >> refreshingBlock: aBlock [
	refreshingBlock := aBlock
]

{ #category : 'announcements - registration' }
StMethodBrowser >> registerToAnnouncements [

	self class codeChangeAnnouncer weak
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodModified: to: self;
		when: MethodRemoved send: #methodRemoved: to: self;
		when: ClassRenamed send: #classRenamed: to: self
]

{ #category : 'text selection' }
StMethodBrowser >> searchedString: searchedString in: aString [
	"Return the interval that corresponds to the portion of aString "
	"This method takes care of finding complete match to searchedString. "
	| string interval firstIndex |
	
	searchedString ifNil: [ ^ 0 to: 0 ].
	aString isEmptyOrNil ifTrue: [ ^0 to: 0 ].
	string := aString asString.
	interval := 0 to: 0.
	
	(searchedString includes: $:)
		ifTrue: [ | list |
			list := searchedString substrings: ':'.
			list size = 1
				ifTrue: [" binary selector "
					firstIndex := self findFirstOccurrenceOf: searchedString in: string.
					firstIndex isZero
						ifFalse: [ interval := firstIndex to: (firstIndex+searchedString size-1) ] ] 
					
				ifFalse: [
					| lastIndex |
					firstIndex := self findFirstOccurrenceOf: list first, ':' in: string. 
					firstIndex >0 ifTrue: [ 
								lastIndex := string findString: list last,':' startingAt: firstIndex+ (list first size -1).
								interval := firstIndex to: (lastIndex + list last size) ] ] ]
		ifFalse: [
			" unary selector "
			firstIndex := self findFirstOccurrenceOf: searchedString in: string.
			 firstIndex > 0
						ifTrue: [ interval := firstIndex to: (firstIndex+searchedString size - 1) ] ].
	^ interval
]

{ #category : 'api' }
StMethodBrowser >> selectIndex: anIndex [
	methodList selectIndex: anIndex
]

{ #category : 'private' }
StMethodBrowser >> selectItem: item [
	| text |

	toolbarPresenter method: item.
	textPresenter beForMethod: item.
	text := (self textConverter
		method: item;
		getText).
	textPresenter text: text.

	highlight ifNotNil: [ self addHighlightedSegments ].
		
	self installIconStylerFor: item
]

{ #category : 'backstops' }
StMethodBrowser >> selectedClass [
	^ self selectedMethod origin
]

{ #category : 'api' }
StMethodBrowser >> selectedMessage: aMessage [
	methodList updateVisitedScopesFrom: aMessage
]

{ #category : 'accessing' }
StMethodBrowser >> selectedMethod [
	^ methodList selectedMethod
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForClassReferencesOf: aString [
	
	self refreshingBlock: [ :method | 
		method accessesRef: (self class environment at: aString asSymbol) ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForImplementorsOf: aSelector [

	self refreshingBlock: [ :message | message selector = aSelector ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForSendersOf: aSelector [
	"Refresh the list of senders taking into account the selectors that are not stored in the literal frame."
	
	| specialIndex |
	specialIndex := Smalltalk specialSelectorIndexOrNil: aSelector.
	self refreshingBlock: [:method | 
		method hasSelector: aSelector specialSelectorIndex: specialIndex ]
]

{ #category : 'announcements' }
StMethodBrowser >> shouldRefreshItem: item fromAnnouncement: anAnnouncement [
	"The refreshing block contains a block that accepts an item of the list, the received announcement and the message browser.
	It will anwer a boolean indicating if the modified item should be refreshed.
	
	Concretely, this is used to know if the contents of the selected message should be refreshed"

	^ refreshingBlock cull: item cull: anAnnouncement cull: self
]

{ #category : 'api' }
StMethodBrowser >> sortingBlock: aBlock [
	methodList sortingBlock: aBlock
]

{ #category : 'text selection' }
StMethodBrowser >> sourceIntervalOf: aSelector in: aMethodNode [
    | senderNode |
    senderNode := aMethodNode allChildren detect: [ :x | x isMessage and: [ x selector = aSelector ] ] ifNone: [ ^ #() ].
    ^ senderNode keywordsPositions first to: senderNode keywordsPositions last + senderNode keywords last size - 1 
]

{ #category : 'accessing' }
StMethodBrowser >> textConverter: aTextConverter [

	super textConverter: aTextConverter.
	textPresenter syntaxHighlight: self textConverter shouldShout .
	textPresenter text: self textConverter getText.
]

{ #category : 'accessing' }
StMethodBrowser >> title: aString [

	title := aString.
	self updateTitle
]

{ #category : 'accessing' }
StMethodBrowser >> toolbarPresenter [
	
	^ toolbarPresenter
]

{ #category : 'api' }
StMethodBrowser >> topologicSort [
	^ methodList topologicSort
]

{ #category : 'api' }
StMethodBrowser >> topologicSort: aBoolean [
	^ methodList topologicSort: aBoolean
]

{ #category : 'api' }
StMethodBrowser >> updateTitle [
	self withWindowDo: [ :window | window title: self title ]
]

{ #category : 'layout' }
StMethodBrowser >> verticalLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newTopToBottom
			add: methodList;
			add: (SpBoxLayout newTopToBottom
				add: textPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'api - events' }
StMethodBrowser >> whenSelectedItemChanged: aBlock [ 
	methodList whenSelectedItemChanged: aBlock 
]

{ #category : 'initialization' }
StMethodBrowser >> windowIcon [

	^ self iconNamed: self class taskbarIconName
		
]

{ #category : 'private' }
StMethodBrowser >> windowIsClosing [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'private' }
StMethodBrowser >> windowTitle [

	| msg |
	msg := methodList ifNil: [ '' ] ifNotNil: [ ' [' , methodList numberOfElements printString , ']' ].
	^ (title ifNil: [ 'Message Browser' ]), msg 
	
]
