"
A MessageBrowser is a UI to browse a list of method, regardless of what they could be.

example: 

MessageBrowser new
	open;
	messages: (SystemNavigation new allSendersOf: #at:)
	yourself
"
Class {
	#name : 'StMessageBrowserPresenter',
	#superclass : 'AbstractMessageCentricBrowserPresenter',
	#instVars : [
		'title',
		'refreshingBlock',
		'textPresenter'
	],
	#category : 'NewTools-MethodBrowsers-Senders',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Senders'
}

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browse: aCollection [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self new
		messages: aCollection;
		open
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browse: aCollection asImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self new
		setRefreshingBlockForImplementorsOf: aSymbol;
		messages: aCollection;
		title: 'Implementors of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browse: aCollection asSendersOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Senders Browser"
	^ self new
		setRefreshingBlockForSendersOf: aSymbol;
		autoSelect: aSymbol;
		messages: aCollection;
		title: 'Senders of ', aSymbol printString;
		open
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browse: aCollection title: aString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self new
		messages: aCollection;
		title: aString;
		open
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browse: aCollection title: aString autoSelect: aSelectString [
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self new
		messages: aCollection;
		title: aString;
		autoSelect: aSelectString;
		open
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browseImplementorsOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self browse: aSymbol implementors asImplementorsOf: aSymbol
]

{ #category : 'instance creation' }
StMessageBrowserPresenter class >> browseSendersOf: aSymbol [ 
	"Special Version that sets the correct refreshing Block for Implentors Browser"
	^ self browse: aSymbol senders asSendersOf: aSymbol
]

{ #category : 'instance creation - old' }
StMessageBrowserPresenter class >> openMessageList: messageList name: aString autoSelect: aSelector refreshingBlockSelector: aRefreshingBlockSelector [
	
	| browser |
	browser := self new
		messages: messageList;
		title: aString;
		autoSelect: aSelector;
		yourself.
		
	aRefreshingBlockSelector ifNotNil:[(browser perform: aRefreshingBlockSelector with: aSelector)].
	^browser open
	
				

]

{ #category : 'tool registration' }
StMessageBrowserPresenter class >> registerToolsOn: registry [

	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #messageList
]

{ #category : 'icons' }
StMessageBrowserPresenter class >> taskbarIconName [
	"Answer the icon for an instance of the receiver in a task bar"

	^#referencesIcon
]

{ #category : 'specs' }
StMessageBrowserPresenter class >> title [
	^ 'Message Browser'
]

{ #category : 'private' }
StMessageBrowserPresenter >> accept: text notifying: notifyer [

	^ self selectedMessage ifNotNil: [ :message | 
		message methodClass 
			compile: text 
			classified: message protocol
			notifying: notifyer ]
]

{ #category : 'text selection' }
StMessageBrowserPresenter >> autoSelect: aSelector [
	textPresenter
		readSelectionBlock:
			[ :text | 
			self selectedMessage ifNotNil:
					[ :msg | (self isMethodDefinition: msg)
						ifFalse: [ self intervalOf: aSelector inCommentText: text ] 
						ifTrue: [ self intervalOf: aSelector inCode: text of: msg ] ] ]
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> classRenamed: anAnnouncement [ 
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleClassRenamed: anAnnouncement ]
]

{ #category : 'initialization' }
StMessageBrowserPresenter >> connectPresenters [
	messageList
		whenSelectionChangedDo: [ :selection | self selectItem: selection selectedItem ];
		whenModelChangedDo: [ self updateTitle ].
	textPresenter whenSubmitDo: [ :text | (self accept: text notifying: nil) notNil ]
]

{ #category : 'layout' }
StMessageBrowserPresenter >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		add: messageList;
		add: (SpBoxLayout newTopToBottom
			add: toolbarPresenter expand: false;
			add: textPresenter;
			yourself);
		yourself
]

{ #category : 'text selection' }
StMessageBrowserPresenter >> findFirstOccurrenceOf: searchedString in: textToSearchIn [
	"Return the first index of aString in textToSearchIn "
	| firstIndex |
	firstIndex := textToSearchIn findString: searchedString startingAt: 1.
	[ (firstIndex > 1) and: [ (textToSearchIn at: (firstIndex - 1)) isAlphaNumeric ] ]
		whileTrue: [
			firstIndex := textToSearchIn findString: searchedString startingAt: firstIndex +1 ].
		
	^ firstIndex
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> handleClassRenamed: anAnnouncement [
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
StMessageBrowserPresenter >> handleMethodAdded: anAnnouncement [
	| item sel text boolean |

	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	
	item := anAnnouncement method.
	
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifFalse: [ ^ self ].
	((item methodClass notNil) and:[item methodClass isObsolete not]) ifFalse: [ ^ self ].
	
	boolean := textPresenter hasUnacceptedEdits.
	boolean ifTrue: [ text := textPresenter pendingText ].
	
	sel := self selectedMessage.
	self messages: (self messages add: item asFullRingDefinition; yourself).
	self selectedMessage: sel.
	
	boolean ifTrue: [ textPresenter pendingText: text ]
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> handleMethodModified: anAnnouncement [
	| item oldItem sel index text list edits |
	self isDisplayed
		ifFalse: [ ^ self ].
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
	edits
		ifTrue: [ text := textPresenter pendingText ].
	index := messageList selectedIndex.
	list := self messages
		remove: sel ifAbsent: [  ];
		add: item asFullRingDefinition;
		"to ensure it's still a RGMethod"
			yourself.
	self messages: list.
	self selectIndex: index.
	edits
		ifFalse: [ ^ self ].
	textPresenter pendingText: text.
	textPresenter hasEditingConflicts: true
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> handleMethodRemoved: anAnnouncement [
	| item selection removeItem |
	self isDisplayed
		ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	self okToChange
		ifFalse: [ ^ self ].

	"Item is a compiled methed, where the list is populated with RGMethod"
	item := anAnnouncement method.
	(item methodClass notNil and: [ item methodClass isObsolete not ])
		ifFalse: [ ^ self ].
	selection := messageList selectedIndex.
	removeItem := self selectedMessage.
	(removeItem notNil
		and: [ removeItem methodClass = item methodClass
				and: [ removeItem selector = item selector ] ])
		ifTrue: [ textPresenter hasUnacceptedEdits: false ].
	self
		messages:
			(self messages
				remove: item asFullRingDefinition ifAbsent: [ nil ];
				yourself).
	self selectIndex: selection
]

{ #category : 'initialization' }
StMessageBrowserPresenter >> initialize [

	super initialize.
	self registerToAnnouncements
]

{ #category : 'initialization' }
StMessageBrowserPresenter >> initializeDropList [

	toolbarPresenter 
		addItemLabeled: 'Source' do: [ self textConverter: SourceMethodConverter new ];
		addItemLabeled: 'Time stamp' do: [ self textConverter: TimeStampMethodConverter new ]
]

{ #category : 'initialization' }
StMessageBrowserPresenter >> initializePresenters [
	super initializePresenters.

	textPresenter := self newCode.
	refreshingBlock := [ :item | true ].

	self initializeDropList
]

{ #category : 'initialization' }
StMessageBrowserPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self title;
		windowIcon: (self application iconNamed: self class taskbarIconName);
		askOkToClose: true
]

{ #category : 'private' }
StMessageBrowserPresenter >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches))"

	(self isMethodDefinition: anItem)
		ifFalse: [ ^ self ].
	
	IconStyler withStaticStylers 
		styleText: textPresenter 
		withAst: anItem ast.
]

{ #category : 'private' }
StMessageBrowserPresenter >> intervalOf: aSelector inCode: aText of: aMethod [
	aMethod compiledMethod ifNil: [  ^ 0 to: 0 ].
	^ (self sourceIntervalOf: aSelector in: aMethod ast) ifEmpty: [ self searchedString: aSelector asString in: aText ]
]

{ #category : 'private' }
StMessageBrowserPresenter >> intervalOf: aSelector inCommentText: aText [
	^ self searchedString: aSelector asString in: aText
]

{ #category : 'api' }
StMessageBrowserPresenter >> messages [
	^ messageList messages
]

{ #category : 'api' }
StMessageBrowserPresenter >> messages: aCollection [
	messageList messages: aCollection
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> methodAdded: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleMethodAdded: anAnnouncement ]
]

{ #category : 'private' }
StMessageBrowserPresenter >> methodClassNameForItem: anItem [
	^ anItem methodClass ifNotNil: [ :class | class name ] ifNil: [ '' ]
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> methodModified: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [	
		self handleMethodModified: anAnnouncement ]
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> methodRemoved: anAnnouncement [
	"this method forces the announcement to be handled in the UI process"
	self defer:  [ 
		self handleMethodRemoved: anAnnouncement ]
]

{ #category : 'private' }
StMessageBrowserPresenter >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'api' }
StMessageBrowserPresenter >> refreshingBlock: aBlock [
	refreshingBlock := aBlock
]

{ #category : 'announcements - registration' }
StMessageBrowserPresenter >> registerToAnnouncements [

	SystemAnnouncer uniqueInstance weak		
		when: MethodAdded send: #methodAdded: to: self;
		when: MethodModified send: #methodModified: to: self;
		when: MethodRemoved send: #methodRemoved: to: self;
		when: ClassRenamed send: #classRenamed: to: self
]

{ #category : 'text selection' }
StMessageBrowserPresenter >> searchedString: searchedString in: aString [
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
StMessageBrowserPresenter >> selectIndex: anIndex [
	messageList selectIndex: anIndex
]

{ #category : 'private' }
StMessageBrowserPresenter >> selectItem: item [

	toolbarPresenter method: item.
	textPresenter beForMethod: item.
	textPresenter text: (self textConverter
		method: item;
		getText).
	self installIconStylerFor: item
]

{ #category : 'accessing' }
StMessageBrowserPresenter >> selectedClass [
	^ self selectedMethod origin
]

{ #category : 'api' }
StMessageBrowserPresenter >> selectedMessage: aMessage [
	messageList selectMessage: aMessage
]

{ #category : 'accessing' }
StMessageBrowserPresenter >> selectedMethod [
	^ messageList selectedMethod
]

{ #category : 'api' }
StMessageBrowserPresenter >> setRefreshingBlockForImplementorsOf: aSelector [
	self refreshingBlock: [ :message | message selector = aSelector ]
]

{ #category : 'api' }
StMessageBrowserPresenter >> setRefreshingBlockForSendersOf: aSelector [
	| specialIndex |
	specialIndex := Smalltalk specialSelectorIndexOrNil: aSelector.
	self refreshingBlock: [:method | 
		method hasSelector: aSelector specialSelectorIndex: specialIndex ]
]

{ #category : 'announcements' }
StMessageBrowserPresenter >> shouldRefreshItem: item fromAnnouncement: anAnnouncement [
	"The refreshing block contains a block that accepts an item of the list, the received announcement and the message browser.
	It will anwer a boolean indicating if the modified item should be refreshed.
	
	Concretely, this is used to know if the contents of the selected message should be refreshed"

	^ refreshingBlock cull: item cull: anAnnouncement cull: self
]

{ #category : 'api' }
StMessageBrowserPresenter >> sortingBlock: aBlock [
	messageList sortingBlock: aBlock
]

{ #category : 'text selection' }
StMessageBrowserPresenter >> sourceIntervalOf: aSelector in: aMethodNode [
    | senderNode |
    senderNode := aMethodNode allChildren detect: [ :x | x isMessage and: [ x selector = aSelector ] ] ifNone: [ ^ #() ].
    ^ senderNode keywordsPositions first to: senderNode keywordsPositions last + senderNode keywords last size - 1 
]

{ #category : 'accessing' }
StMessageBrowserPresenter >> textConverter: aTextConverter [

	super textConverter: aTextConverter.
	textPresenter syntaxHighlight: self textConverter shouldShout .
	textPresenter text: self textConverter getText.
]

{ #category : 'private' }
StMessageBrowserPresenter >> title [

	^ (title ifNil: [ self class title ]), ' [' , messageList numberOfElements printString , ']'
]

{ #category : 'accessing' }
StMessageBrowserPresenter >> title: aString [

	title := aString.
	self updateTitle
]

{ #category : 'accessing' }
StMessageBrowserPresenter >> toolbarPresenter [
	
	^ toolbarPresenter
]

{ #category : 'api' }
StMessageBrowserPresenter >> topologicSort [
	^ messageList topologicSort
]

{ #category : 'api' }
StMessageBrowserPresenter >> topologicSort: aBoolean [
	^ messageList topologicSort: aBoolean
]

{ #category : 'api' }
StMessageBrowserPresenter >> updateTitle [
	self withWindowDo: [ :window | window title: self title ]
]

{ #category : 'api - events' }
StMessageBrowserPresenter >> whenSelectedItemChanged: aBlock [ 
	messageList whenSelectedItemChanged: aBlock 
]

{ #category : 'private' }
StMessageBrowserPresenter >> windowIsClosing [
	
	SystemAnnouncer uniqueInstance unsubscribe: self
]
