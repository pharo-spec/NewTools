"
A MessageBrowser is a UI to browse a list of method, regardless of what they could be.

example: 

MessageBrowser new
	open;
	messages: (SystemNavigation new allSendersOf: #at:)
	yourself
"
Class {
	#name : 'StMessageBrowser',
	#superclass : 'StAbstractMessageCentricBrowserPresenter',
	#instVars : [
		'title',
		'refreshingBlock',
		'textPresenter',
		'highlight'
	],
	#classVars : [
		'UsingLayout'
	],
	#classInstVars : [
		'preferredExtent'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'tools registration' }
StMessageBrowser class >> beDefaultBrowser [
	<script>
	
	self registerToolsOn: self currentApplication tools
]

{ #category : 'instance creation' }
StMessageBrowser class >> browse: aCollection [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self new
		messages: aCollection;
		open
]

{ #category : 'instance creation' }
StMessageBrowser class >> browse: aCollection asImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"

	^ self new
		setRefreshingBlockForImplementorsOf: aSymbol;
		messages: aCollection;
		title: 'Implementors of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMessageBrowser class >> browse: aCollection asSendersOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Senders Browser"

	^ self new
		setRefreshingBlockForSendersOf: aSymbol;
		highlight: aSymbol;
		messages: aCollection;
		title: 'Senders of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMessageBrowser class >> browse: aCollection title: aString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"

	^ self new
		messages: aCollection;
		title: aString;
		open
]

{ #category : 'instance creation' }
StMessageBrowser class >> browse: aCollection title: aString highlight: aSelectString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	
	^ self new
		messages: aCollection;
		title: aString;
		highlight: aSelectString;
		open
]

{ #category : 'instance creation' }
StMessageBrowser class >> browseImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	
	^ self browse: aSymbol implementors asImplementorsOf: aSymbol
]

{ #category : 'instance creation' }
StMessageBrowser class >> browseSendersOf: aSymbol [
	"Special Version that sets the correct refreshing Block for Implentors Browser"

	^ self browse: aSymbol senders asSendersOf: aSymbol
]

{ #category : 'accessing' }
StMessageBrowser class >> defaultPreferredExtent [

	^ 900@600
]

{ #category : 'instance creation - old' }
StMessageBrowser class >> openMessageList: messageList name: aString autoSelect: aSelector refreshingBlockSelector: aRefreshingBlockSelector [
	
	| browser |
	browser := self new
		messages: messageList;
		title: aString;
		autoSelect: aSelector;
		yourself.
		
	aRefreshingBlockSelector ifNotNil:[(browser perform: aRefreshingBlockSelector with: aSelector)].
	^browser open
	
				

]

{ #category : 'accessing' }
StMessageBrowser class >> preferredExtent [

	^ preferredExtent ifNil: [ preferredExtent := self defaultPreferredExtent ]
]

{ #category : 'accessing' }
StMessageBrowser class >> preferredExtent: aPoint [

	preferredExtent := aPoint
]

{ #category : 'tool registration' }
StMessageBrowser class >> registerToolsOn: registry [

	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #messageList
]

{ #category : 'icons' }
StMessageBrowser class >> taskbarIconName [
	"Answer the icon for an instance of the receiver in a task bar"

	^#references
]

{ #category : 'specs' }
StMessageBrowser class >> title [

	^ 'Message Browser'
]

{ #category : 'private' }
StMessageBrowser class >> usingLayout [

	^ UsingLayout ifNil: [ UsingLayout := #horizontalLayout ]
]

{ #category : 'private' }
StMessageBrowser class >> usingLayout: aSymbol [

	UsingLayout := aSymbol
]

{ #category : 'private' }
StMessageBrowser >> accept: text notifying: notifyer [

	^ self selectedMessage ifNotNil: [ :message | 
		message methodClass 
			compile: text 
			classified: message protocol
			notifying: notifyer ]
]

{ #category : 'private' }
StMessageBrowser >> addHighlightedSegments [
	| message highlightInterval |

	message := self selectedMessage.
	message ifNil: [ ^ self ].
	
	highlightInterval := (self isMethodDefinition: message)
		ifFalse: [ self intervalOf: highlight inCommentText: textPresenter text ] 
		ifTrue: [ self intervalOf: highlight inCode: textPresenter text of: message ].
		
	textPresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight 
		interval: (highlightInterval first to: highlightInterval last + 1);
		yourself)
]

{ #category : 'announcements' }
StMessageBrowser >> classRenamed: anAnnouncement [ 
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleClassRenamed: anAnnouncement ]
]

{ #category : 'initialization' }
StMessageBrowser >> connectPresenters [
	
	messageList
		whenSelectionChangedDo: [ :selection | self selectItem: selection selectedItem ];
		whenModelChangedDo: [ self updateTitle ].
		
	textPresenter 
		whenSubmitDo: [ :text | self accept: text notifying: nil ];
		whenResetDo: [ self selectItem: messageList selectedMessage ]	
]

{ #category : 'api - focus' }
StMessageBrowser >> defaultKeyboardFocus [

	^ messageList
]

{ #category : 'layout' }
StMessageBrowser >> defaultLayout [

	^ self perform: self class usingLayout
]

{ #category : 'text selection' }
StMessageBrowser >> findFirstOccurrenceOf: searchedString in: textToSearchIn [
	"Return the first index of aString in textToSearchIn "
	| firstIndex |
	firstIndex := textToSearchIn findString: searchedString startingAt: 1.
	[ (firstIndex > 1) and: [ (textToSearchIn at: (firstIndex - 1)) isAlphaNumeric ] ]
		whileTrue: [
			firstIndex := textToSearchIn findString: searchedString startingAt: firstIndex +1 ].
		
	^ firstIndex
]

{ #category : 'private' }
StMessageBrowser >> flipLayout [

	self class usingLayout: ((self class usingLayout = #horizontalLayout)
		ifTrue: [ #verticalLayout ]
		ifFalse: [ #horizontalLayout ]).
		
	self layout: self defaultLayout
	
]

{ #category : 'announcements' }
StMessageBrowser >> handleClassRenamed: anAnnouncement [
	| items selectedIndex |

	items := self messages
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
	selectedIndex := messageList selectedIndex.
	self messages: items
]

{ #category : 'announcements' }
StMessageBrowser >> handleMethodAdded: anAnnouncement [
	| item sel text boolean |

	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	
	item := anAnnouncement method.
	
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifFalse: [ ^ self ].
	((item methodClass isNotNil) and:[item methodClass isObsolete not]) ifFalse: [ ^ self ].
	
	boolean := textPresenter hasUnacceptedEdits.
	boolean ifTrue: [ text := textPresenter pendingText ].
	
	sel := self selectedMessage.
	self messages: (self messages add: item asFullRingDefinition; yourself).
	self selectedMessage: sel.
	
	boolean ifTrue: [ textPresenter pendingText: text ]
]

{ #category : 'announcements' }
StMessageBrowser >> handleMethodModified: anAnnouncement [
	| item oldItem sel index text list edits |
	
	self isDisplayed ifFalse: [ ^ self ].
	
	refreshingBlock ifNil: [ ^ self ].
	item := anAnnouncement newMethod.
	oldItem := anAnnouncement oldMethod.
	sel := self selectedMessage.
	sel ifNil: [ ^ self ].
	(sel methodClass = oldItem methodClass
		and: [ sel selector = oldItem selector ])
		ifFalse: [ ^ self ].
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement)
		ifFalse: [ ^ self ].
	
	edits := textPresenter hasUnacceptedEdits.
	edits ifTrue: [ 
		text := textPresenter pendingText ].
	index := messageList selectedIndex.
	list := self messages
		remove: sel ifAbsent: [  ];
		add: item asFullRingDefinition;
		"to ensure it's still a RGMethod"
			yourself.
	self messages: list.
	self selectIndex: index.
	edits ifFalse: [ ^ self ].
	
	textPresenter pendingText: text.
	textPresenter hasEditingConflicts: true
]

{ #category : 'announcements' }
StMessageBrowser >> handleMethodRemoved: anAnnouncement [
	| item selection removeItem |

	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	self okToChange ifFalse: [ ^ self ].

	"Item is a compiled methed, where the list is populated with RGMethod"
	item := anAnnouncement method.
	(item methodClass isNotNil and: [ item methodClass isObsolete not ])
		ifFalse: [ ^ self ].
	selection := messageList selectedIndex.
	removeItem := self selectedMessage.

	self messages: (self messages
		remove: item ifAbsent: [ nil ];
		yourself).
	self selectIndex: (selection min: self messages size)
]

{ #category : 'text selection' }
StMessageBrowser >> highlight: aSelector [

	highlight := aSelector.
	self addHighlightedSegments

]

{ #category : 'layout' }
StMessageBrowser >> horizontalLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newLeftToRight
			add: messageList;
			add: (SpBoxLayout newTopToBottom
				add: textPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'initialization' }
StMessageBrowser >> initialize [

	super initialize.
	self registerToAnnouncements
]

{ #category : 'initialization' }
StMessageBrowser >> initializeDropList [

	toolbarPresenter 
		addItemLabeled: 'Source' do: [ self textConverter: SourceMethodConverter new ];
		addItemLabeled: 'Time stamp' do: [ self textConverter: TimeStampMethodConverter new ]
]

{ #category : 'initialization' }
StMessageBrowser >> initializePresenters [

	super initializePresenters.

	textPresenter := self newCode.
	refreshingBlock := [ :item | true ].

	self initializeDropList
]

{ #category : 'initialization' }
StMessageBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self title;
		initialExtent: self class preferredExtent;
		windowIcon: (self iconNamed: self class taskbarIconName);
		whenResizingDo: [ :ann | self class preferredExtent: ann newSize ]
]

{ #category : 'private' }
StMessageBrowser >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches))"

	(self isMethodDefinition: anItem)
		ifFalse: [ ^ self ].
	
	IconStyler withStaticStylers 
		styleText: textPresenter 
		withAst: anItem ast.
]

{ #category : 'private' }
StMessageBrowser >> intervalOf: aSelector inCode: aText of: aMethod [

	aMethod compiledMethod ifNil: [  ^ 0 to: 0 ].
	^ (self sourceIntervalOf: aSelector in: aMethod ast) 
		ifEmpty: [ self searchedString: aSelector asString in: aText ]
]

{ #category : 'private' }
StMessageBrowser >> intervalOf: aSelector inCommentText: aText [
	^ self searchedString: aSelector asString in: aText
]

{ #category : 'api' }
StMessageBrowser >> messages [
	^ messageList messages
]

{ #category : 'api' }
StMessageBrowser >> messages: aCollection [

	messageList messages: aCollection.
	self toolbarPresenter updatePresenter.
]

{ #category : 'announcements' }
StMessageBrowser >> methodAdded: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleMethodAdded: anAnnouncement ]
]

{ #category : 'private' }
StMessageBrowser >> methodClassNameForItem: anItem [
	^ anItem methodClass ifNotNil: [ :class | class name ] ifNil: [ '' ]
]

{ #category : 'announcements' }
StMessageBrowser >> methodModified: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [	
		self handleMethodModified: anAnnouncement ]
]

{ #category : 'announcements' }
StMessageBrowser >> methodRemoved: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [ 
		self handleMethodRemoved: anAnnouncement ]
]

{ #category : 'initialization' }
StMessageBrowser >> newMessageToolbar [

	^ (self instantiate: StMessageToolbarPresenter)
		whenFlipLayoutDo: [ self flipLayout ];
		yourself
]

{ #category : 'private' }
StMessageBrowser >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'api' }
StMessageBrowser >> refreshingBlock: aBlock [
	refreshingBlock := aBlock
]

{ #category : 'announcements - registration' }
StMessageBrowser >> registerToAnnouncements [

	self class codeChangeAnnouncer weak
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodModified: to: self;
		when: MethodRemoved send: #methodRemoved: to: self;
		when: ClassRenamed send: #classRenamed: to: self
]

{ #category : 'text selection' }
StMessageBrowser >> searchedString: searchedString in: aString [
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
StMessageBrowser >> selectIndex: anIndex [
	messageList selectIndex: anIndex
]

{ #category : 'private' }
StMessageBrowser >> selectItem: item [
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
StMessageBrowser >> selectedClass [
	^ self selectedMethod origin
]

{ #category : 'api' }
StMessageBrowser >> selectedMessage: aMessage [
	messageList updateVisitedScopesFrom: aMessage
]

{ #category : 'accessing' }
StMessageBrowser >> selectedMethod [
	^ messageList selectedMethod
]

{ #category : 'api' }
StMessageBrowser >> setRefreshingBlockForImplementorsOf: aSelector [
	self refreshingBlock: [ :message | message selector = aSelector ]
]

{ #category : 'api' }
StMessageBrowser >> setRefreshingBlockForSendersOf: aSelector [
	| specialIndex |
	specialIndex := Smalltalk specialSelectorIndexOrNil: aSelector.
	self refreshingBlock: [:method | 
		method hasSelector: aSelector specialSelectorIndex: specialIndex ]
]

{ #category : 'announcements' }
StMessageBrowser >> shouldRefreshItem: item fromAnnouncement: anAnnouncement [
	"The refreshing block contains a block that accepts an item of the list, the received announcement and the message browser.
	It will anwer a boolean indicating if the modified item should be refreshed.
	
	Concretely, this is used to know if the contents of the selected message should be refreshed"

	^ refreshingBlock cull: item cull: anAnnouncement cull: self
]

{ #category : 'api' }
StMessageBrowser >> sortingBlock: aBlock [
	messageList sortingBlock: aBlock
]

{ #category : 'text selection' }
StMessageBrowser >> sourceIntervalOf: aSelector in: aMethodNode [
    | senderNode |
    senderNode := aMethodNode allChildren detect: [ :x | x isMessage and: [ x selector = aSelector ] ] ifNone: [ ^ #() ].
    ^ senderNode keywordsPositions first to: senderNode keywordsPositions last + senderNode keywords last size - 1 
]

{ #category : 'accessing' }
StMessageBrowser >> textConverter: aTextConverter [

	super textConverter: aTextConverter.
	textPresenter syntaxHighlight: self textConverter shouldShout .
	textPresenter text: self textConverter getText.
]

{ #category : 'private' }
StMessageBrowser >> title [

	^ (title ifNil: [ self class title ]), ' [' , messageList numberOfElements printString , ']'
]

{ #category : 'accessing' }
StMessageBrowser >> title: aString [

	title := aString.
	self updateTitle
]

{ #category : 'accessing' }
StMessageBrowser >> toolbarPresenter [
	
	^ toolbarPresenter
]

{ #category : 'api' }
StMessageBrowser >> topologicSort [
	^ messageList topologicSort
]

{ #category : 'api' }
StMessageBrowser >> topologicSort: aBoolean [
	^ messageList topologicSort: aBoolean
]

{ #category : 'api' }
StMessageBrowser >> updateTitle [
	self withWindowDo: [ :window | window title: self title ]
]

{ #category : 'layout' }
StMessageBrowser >> verticalLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbarPresenter expand: false;
		add: (SpPanedLayout newTopToBottom
			add: messageList;
			add: (SpBoxLayout newTopToBottom
				add: textPresenter;
				yourself);
			yourself);
		yourself
]

{ #category : 'api - events' }
StMessageBrowser >> whenSelectedItemChanged: aBlock [ 
	messageList whenSelectedItemChanged: aBlock 
]

{ #category : 'private' }
StMessageBrowser >> windowIsClosing [

	self class codeChangeAnnouncer unsubscribe: self
]
