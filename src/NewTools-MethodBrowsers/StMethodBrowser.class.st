"
A MethodBrowser is a UI to browse a list of methods.

Example: 

```
StMethodBrowser new
	open;
	methods: (SystemNavigation new allSendersOf: #at:)
	yourself
```
"
Class {
	#name : 'StMethodBrowser',
	#superclass : 'StAbstractMethodCentricBrowserPresenter',
	#instVars : [
		'title',
		'refreshingBlock',
		'textPresenter',
		'highlight',
		'filterPresenter'
	],
	#classVars : [
		'NavigateInPlace',
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

{ #category : 'opening - old' }
StMethodBrowser class >> browse: aCollection [
	"Basic version. Opens a browser on the given collection of methods without setting a title or refreshing block."

	^ (self methods: aCollection) open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asImplementorsOf: aSymbol [
	"Specialized version for better UX feedback"

	^ self new
		  methods: compiledMethods asImplementorsOf: aSymbol;
		  open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asImplementorsOfAll: aCollectionOfSymbols [

	^ self new
		  methods: compiledMethods asImplementorsOfAll: aCollectionOfSymbols;
		  open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asReferencesToClass: aClass [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ (self new methods: compiledMethods asReferenceTo: aClass binding) open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asReferencesToLiteral: aLiteral [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ (self new methods: compiledMethods asReferenceTo: aLiteral) open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asReferencesToVariable: aVariable inClass: aClass [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ (self new methods: compiledMethods asReferencesToVariable: aVariable inClass: aClass binding) open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asSendersOf: aSymbol [
	"Specialized version for better UX feedback for senders and explicit list of methods"

	^ self new
		  methods: compiledMethods asSendersOf: aSymbol;
		  open
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asSendersOfAll: aCollectionOfSymbols [
	"Specialized version for better UX feedback for senders of all given selectors."

	^ self new
		  methods: compiledMethods asSendersOfAll: aCollectionOfSymbols;
		  open
]

{ #category : 'opening - old' }
StMethodBrowser class >> browse: aCollection title: aString [
	"Basic version with limited UX feedback. Use only if you cannot use the other methods."

	^ self new
		  methods: aCollection;
		  title: aString;
		  open
]

{ #category : 'opening - old' }
StMethodBrowser class >> browse: aCollection title: aString highlight: aSelectString [
	"Basic version with limited UX feedback that highlights a specific string in the source code."

	^ self new
		  methods: aCollection;
		  title: aString;
		  highlight: aSelectString;
		  open
]

{ #category : 'opening' }
StMethodBrowser class >> browseImplementorsOf: aSymbol [
	"Opens a browser on all implementors of aSymbol. Sets the refreshing block to keep the list up to date."

	^ self browse: (self implementorsOf: aSymbol) asImplementorsOf: aSymbol
]

{ #category : 'opening' }
StMethodBrowser class >> browseImplementorsOfAll: aCollectionOfSymbols [

	| methods |
	methods := aCollectionOfSymbols flatCollect: [ :sym | self implementorsOf: sym ].
	^ self browse: methods asArray asImplementorsOfAll: aCollectionOfSymbols
]

{ #category : 'opening' }
StMethodBrowser class >> browseMethodsWithSourceString: aString [

	SystemNavigation default browseMethodsWithSourceString: aString matchCase: false
]

{ #category : 'opening' }
StMethodBrowser class >> browseReferencesOf: aClassName [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self referencesOf: aClassName) asReferencesToClass: aClassName
]

{ #category : 'opening' }
StMethodBrowser class >> browseReferencesToClass: aClass [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self referencesToClass: aClass) asReferencesToClass: aClass
]

{ #category : 'opening' }
StMethodBrowser class >> browseReferencesToLiteral: aLiteral [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self referencesToLiteral: aLiteral) asReferencesToLiteral: aLiteral
]

{ #category : 'opening' }
StMethodBrowser class >> browseReferencesToVariable: aVariable inClass: aClass [


	^ self browse: (self referencesToVariable: aVariable inClass: aClass) asReferencesToVariable: aVariable inClass: aClass 
]

{ #category : 'opening' }
StMethodBrowser class >> browseReferencesToVariables: variables [

	| methods |
	methods := SystemNavigation default allMethods select: [ :m | variables anySatisfy: [ :var | var isAccessedIn: m ] ].
	^ self new
		  methods: methods asArray;
		  title: 'References to ' , (', ' join: (variables collect: [ :v | v name ]));
		  open
]

{ #category : 'opening' }
StMethodBrowser class >> browseSendersOf: aSymbol [
	"Special version that sets the correct refreshing block for senders"

	^ self browse: (self sendersOf: aSymbol) asSendersOf: aSymbol
]

{ #category : 'opening' }
StMethodBrowser class >> browseSendersOfAll: aCollectionOfSymbols [
    | methods |
    methods := aCollectionOfSymbols flatCollect: [ :sym | self sendersOf: sym ].
    ^ self browse: methods asArray asSendersOfAll: aCollectionOfSymbols 
]

{ #category : 'opening' }
StMethodBrowser class >> browseUsersOfSharedPool: aPoolClass [

	| methods classes poolVarNames |
	classes := aPoolClass poolUsers.
	poolVarNames := aPoolClass classVarNames.

	methods := classes flatCollect: [ :cls |
		           cls methods select: [ :m | poolVarNames anySatisfy: [ :varName | m ast references: varName ] ] ].

	self new
		methods: methods asArray;
		title: 'Users of pool ' , aPoolClass name;
		open
]

{ #category : 'opening' }
StMethodBrowser class >> browseUsersOfTrait: aTrait [

	| methods classes |
	classes := aTrait traitUsers.
	methods := classes flatCollect: [ :cls | cls methods select: [ :m | m origin = aTrait ] ].

	self new
		methods: methods asArray;
		title: 'Users of trait ' , aTrait name;
		open
]

{ #category : 'opening' }
StMethodBrowser class >> browseWritersOfVariables: variables [

	| methods |
	methods := SystemNavigation default allMethods select: [ :m | variables anySatisfy: [ :var | var isWrittenIn: m ] ].
	^ self new
		  methods: methods asArray;
		  title: 'Writers to ' , (', ' join: (variables collect: [ :v | v name ]));
		  open
]

{ #category : 'private' }
StMethodBrowser class >> implementorsOf: aSymbol [
	"Do not use aSymbol implementors because it is a disguised global"

	^ (SystemNavigation default allImplementorsOf: aSymbol) reject: [ :m | m isFromTrait ]
]

{ #category : 'instance creation' }
StMethodBrowser class >> methods: methods [
	"Create a method browser on the methods argument. Do not open it."
	
	^ self new
		  methods: methods;
		  yourself
]

{ #category : 'private' }
StMethodBrowser class >> navigateInPlace [

	^ NavigateInPlace ifNil: [ NavigateInPlace := false ]  
]

{ #category : 'private' }
StMethodBrowser class >> navigateInPlace: aBoolean [

	NavigateInPlace := aBoolean 
]

{ #category : 'private' }
StMethodBrowser class >> navigateInPlaceSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder setting: #navigateInPlace)
		label: 'Navigate in place in Method Browser';
		description:
			'When browsing senders/implementors/references from a Method Browser, reuse the current window instead of opening a new one';
		target: self;
		parent: #tools
]

{ #category : 'private' }
StMethodBrowser class >> referencesOf: aSymbol [
	"Do not use aSymbol implementors because it is a disguised global"
	
	^ SystemNavigation default allReferencesTo: aSymbol 
]

{ #category : 'private' }
StMethodBrowser class >> referencesToClass: aClass [
	
	^ SystemNavigation default allReferencesTo: aClass binding
]

{ #category : 'private' }
StMethodBrowser class >> referencesToLiteral: aLiteral [
	"Do not use aSymbol implementors because it is a disguised global"

	^ SystemNavigation default allReferencesTo: aLiteral
]

{ #category : 'private' }
StMethodBrowser class >> referencesToVariable: aVariable inClass: aClass [

	^ aClass allMethodsAccessingSlot: aVariable
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

	| message highlightInterval highlights  |
	message := self selectedMethod.
	message ifNil: [ ^ self ].

	highlights := (highlight isCollection and: [ highlight isString not ])
		              ifTrue: [ highlight ]
		              ifFalse: [ { highlight } ].

	highlights asArray do: [ :each |
			highlightInterval := (self isMethodDefinition: message)
				                     ifFalse: [ self intervalOf: each inCommentText: textPresenter text ]
				                     ifTrue: [ self intervalOf: each inCode: textPresenter text of: message ].

			textPresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
					 interval: (highlightInterval first to: highlightInterval last + 1);
					 yourself) ]
]

{ #category : 'private - scopes' }
StMethodBrowser >> allScopes [ 
	
	^ methodList allScopes
]

{ #category : 'announcements' }
StMethodBrowser >> classRenamed: anAnnouncement [ 
	"this method forces the announcement to be handled in the UI process"
	self defer: [ 
		self handleClassRenamed: anAnnouncement ]
]

{ #category : 'accessing' }
StMethodBrowser >> codeEditor [

	^ textPresenter
]

{ #category : 'initialization' }
StMethodBrowser >> connectPresenters [

	methodList
		whenSelectionChangedDo: [ :selection | self selectItem: selection selectedItem ];
		whenModelChangedDo: [ self updateTitle ].
	methodList navigationBlock: [ :type :val | self navigateTo: type value: val ].
	textPresenter
		whenSubmitDo: [ :text | self accept: text notifying: nil ];
		whenResetDo: [ self selectItem: methodList selectedMethod ].

	filterPresenter filterInputPresenter whenTextChangedDo: [ :text |
			| allMethods filtered |
			allMethods := filterPresenter unfilteredItems.
			text ifEmpty: [ methodList methods: allMethods ] ifNotEmpty: [
					filtered := allMethods select: [ :m | (filterPresenter display value: m) asLowercase includesSubstring: text asLowercase ].
					methodList methods: filtered ] ]
]

{ #category : 'api - focus' }
StMethodBrowser >> defaultKeyboardFocus [

	^ methodList
]

{ #category : 'layout' }
StMethodBrowser >> defaultLayout [

	^ self perform: self class usingLayout
]

{ #category : 'accessing' }
StMethodBrowser >> filterPresenter [

	^ filterPresenter
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

	| item selectedMethod editedText |
	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].

	item := anAnnouncement method.
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifFalse: [ ^ self ].
	(item methodClass isNotNil and: [ item methodClass isObsolete not ]) ifFalse: [ ^ self ].

	editedText := textPresenter isDirty ifTrue: [ textPresenter text ].
	selectedMethod := self selectedMethod.
	(filterPresenter unfilteredItems includes: item) ifFalse: [
			self methods: (filterPresenter unfilteredItems asOrderedCollection
					 add: item asFullRingDefinition;
					 yourself) ].

	self defer: [ self selectIndex: ((self methods indexOf: selectedMethod) max: 1) ].
	self selectedMessage: selectedMethod.
	editedText ifNotNil: [
			textPresenter text: editedText.
			textPresenter markDirty ]
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodModified: anAnnouncement [

	| item oldItem matchingItem index editedText list |
	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	item := anAnnouncement newMethod.
	oldItem := anAnnouncement oldMethod.

	matchingItem := self methods
		                detect: [ :m | m methodClass = oldItem methodClass and: [ m selector = oldItem selector ] ]
		                ifNone: [ nil ].
	matchingItem ifNil: [
			(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifTrue: [
					self methods: (self methods
							 add: item asFullRingDefinition;
							 yourself) ].
			^ self ].

	editedText := textPresenter isDirty ifTrue: [ editedText := textPresenter text ].

	index := methodList selectedIndex.

	list := filterPresenter unfilteredItems asOrderedCollection.
	list remove: matchingItem ifAbsent: [ ].
	(self shouldRefreshItem: item fromAnnouncement: anAnnouncement) ifFalse: [
			self methods: list.
			self defer: [ self selectIndex: (index min: self methods size) ].
			^ self ].

	list add: item asFullRingDefinition.
	self methods: list.
	self defer: [ self selectIndex: index ].

	editedText ifNotNil: [
			textPresenter text: editedText.
			textPresenter markConflict ]
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodRemoved: anAnnouncement [

	| item selection matchingItem selectedMethod |
	self isDisplayed ifFalse: [ ^ self ].
	refreshingBlock ifNil: [ ^ self ].
	self okToChange ifFalse: [ ^ self ]. "Item is a compiled methed, where the list is populated with RGMethod"
	item := anAnnouncement method.
	(item methodClass isNotNil and: [ item methodClass isObsolete not ]) ifFalse: [ ^ self ].
	selection := methodList selectedIndex.
	matchingItem := self methods
		                detect: [ :m | m methodClass = item methodClass and: [ m selector = item selector ] ]
		                ifNone: [ ^ self ].
	selectedMethod := self selectedMethod.
	self methods: (self methods asOrderedCollection
			 remove: matchingItem ifAbsent: [ ];
			 yourself).
	self defer: [
			methodList listPresenter selection unselectAll.
			selectedMethod = matchingItem
				ifTrue: [ self selectIndex: (selection min: self methods size) ]
				ifFalse: [ self selectIndex: (self methods indexOf: selectedMethod) ] ]
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
				   add: (SpBoxLayout newTopToBottom
						    add: methodList;
						    add: filterPresenter filterInputPresenter expand: false;
						    yourself);
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

	| methodCodePresenter |
	super initializePresenters.


	methodCodePresenter := self instantiate: StMethodCodePresenter.
	methodCodePresenter methodBrowser: self.

	textPresenter := self newCodeEditor.
	textPresenter codePresenter: methodCodePresenter.
	methodCodePresenter whenTextChangedDo: [ :aString | textPresenter markDirty ].
	refreshingBlock := [ :item | true ].
	filterPresenter := self instantiate: SpFilteringListPresenter.
	filterPresenter matchSubstring.
	filterPresenter display: [ :m | (self methodClassNameForItem: m) , ' >> ' , m selector ].

	self initializeDropList
]

{ #category : 'initialization' }
StMethodBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter whenWillCloseDo: [ :ann |
			textPresenter isDirty ifTrue: [
					(self application confirm: 'Changes have not been saved.
Is it OK to discard changes?') ifFalse: [ ann denyClose ] ] ].
	aWindowPresenter whenClosedDo: [ 
    TestCase historyAnnouncer unsubscribe: methodList.
    self class codeChangeAnnouncer unsubscribe: self ]
]

{ #category : 'private' }
StMethodBrowser >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches))"

	(self isMethodDefinition: anItem)
		ifFalse: [ ^ self ].
	
	IconStyler withStaticStylers 
		styleText: textPresenter codePresenter
		withAst: anItem ast
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

	| currentFilter |
	currentFilter := filterPresenter filterText.
	filterPresenter unfilteredItems: aCollection asOrderedCollection.
	methodList methods: aCollection.
	self toolbarPresenter updatePresenter.
	currentFilter isEmpty ifFalse: [ filterPresenter applyFilter: currentFilter ]
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asImplementorsOf: aSymbol [
	"Create without opening it a method browsers for the implementors of a Symbol"

	self
		setRefreshingBlockForImplementorsOf: aSymbol;
		methods: compiledMethods;
		title: 'Implementors of ' , aSymbol
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asImplementorsOfAll: aCollectionOfSymbols [

	self
		setRefreshingBlockForImplementorsOfAll: aCollectionOfSymbols;
		highlight: aCollectionOfSymbols;
		methods: compiledMethods;
		title: 'Implementors of ' , (', ' join: aCollectionOfSymbols)
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asReferenceTo: aClassName [

	self
		setRefreshingBlockForClassReferencesOf: aClassName;
		highlight: aClassName;
		methods: compiledMethods;
		title: 'References of ' , aClassName printString
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asReferencesToVariable: aVariable inClass: aClass [
	"Configure the browser for references to a variable/slot in a class"

	self
		setRefreshingBlockForReferencesToSlot: aVariable;
		highlight: aVariable name;
		methods: compiledMethods;
		title: 'References to ' , aVariable name , ' in ' , aClass name
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asSendersOf: aSymbol [
	"Create without opening it a method browsers for the reference to a class "

	self
		setRefreshingBlockForSendersOf: aSymbol;
		highlight: aSymbol;
		methods: compiledMethods;
		title: 'Senders of ' , aSymbol
]

{ #category : 'api - instance side' }
StMethodBrowser >> methods: compiledMethods asSendersOfAll: aCollectionOfSymbols [

	self
		setRefreshingBlockForSendersOfAll: aCollectionOfSymbols;
		highlight: aCollectionOfSymbols;
		methods: compiledMethods;
		title: 'Senders of ' , (', ' join: aCollectionOfSymbols)
]

{ #category : 'private' }
StMethodBrowser >> navigateInPlace [

	^ self class navigateInPlace
]

{ #category : 'private' }
StMethodBrowser >> navigateTo: aType value: anObject [

	self navigateInPlace ifFalse: [
			aType == #implementors ifTrue: [ ^ self class browseImplementorsOf: anObject ].
			aType == #implementorsAll ifTrue: [ ^ self class browseImplementorsOfAll: anObject ].
			aType == #senders ifTrue: [ ^ self class browseSendersOf: anObject ].
			aType == #sendersAll ifTrue: [ ^ self class browseSendersOfAll: anObject ].
			aType == #references ifTrue: [ ^ self class browseReferencesOf: anObject ].
			^ self ].

	aType == #implementors ifTrue: [ self methods: (self class implementorsOf: anObject) asImplementorsOf: anObject ].
	aType == #implementorsAll ifTrue: [ self methods: (self class implementorsOf: anObject) asImplementorsOfAll: anObject ].
	aType == #senders ifTrue: [ self methods: (self class sendersOf: anObject) asSendersOf: anObject ].
	aType == #sendersAll ifTrue: [ self methods: (self class sendersOf: anObject) asSendersOfAll: anObject ].
	aType == #references ifTrue: [ self methods: (self class referencesOf: anObject) asReferenceTo: anObject ]
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
StMethodBrowser >> refreshingBlock [

	^ refreshingBlock
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

	| string interval firstIndex lowerString lowerSearch |
	searchedString ifNil: [ ^ 0 to: 0 ].
	aString isEmptyOrNil ifTrue: [ ^ 0 to: 0 ].
	string := aString asString.
	lowerString := string asLowercase.
	lowerSearch := searchedString asLowercase.
	interval := 0 to: 0.

	(lowerSearch includes: $:)
		ifTrue: [
				| list |
				list := lowerSearch substrings: ':'.
				list size = 1
					ifTrue: [
							firstIndex := self findFirstOccurrenceOf: lowerSearch in: lowerString.
							firstIndex isZero ifFalse: [ interval := firstIndex to: firstIndex + searchedString size - 1 ] ]
					ifFalse: [
							| lastIndex |
							firstIndex := self findFirstOccurrenceOf: list first , ':' in: lowerString.
							firstIndex > 0 ifTrue: [
									lastIndex := lowerString findString: list last , ':' startingAt: firstIndex + (list first size - 1).
									interval := firstIndex to: lastIndex + list last size ] ] ]
		ifFalse: [
				firstIndex := self findFirstOccurrenceOf: lowerSearch in: lowerString.
				firstIndex > 0 ifTrue: [ interval := firstIndex to: firstIndex + searchedString size - 1 ] ].
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

	textPresenter codePresenter beForMethod: item.
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

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForClassReferencesOf: aString [

	self refreshingBlock: [ :method | method hasLiteral: aString ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForImplementorsOf: aSelector [

	self refreshingBlock: [ :message | message selector = aSelector ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForImplementorsOfAll: aCollectionOfSymbols [

	self refreshingBlock: [ :message | aCollectionOfSymbols anySatisfy: [ :sel | message selector = sel ] ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForReferencesToSlot: aSlot [

	self refreshingBlock: [ :method | method accessesSlot: aSlot ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForSendersOf: aSelector [
	"Refresh the list of senders taking into account the selectors that are not stored in the literal frame."
	
	| specialIndex |
	specialIndex := Smalltalk specialSelectorIndexOrNil: aSelector.
	self refreshingBlock: [:method | 
		method hasSelector: aSelector specialSelectorIndex: specialIndex ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForSendersOfAll: aCollectionOfSymbols [

	self refreshingBlock: [ :method |
			aCollectionOfSymbols anySatisfy: [ :sym |
					| specialIndex |
					specialIndex := Smalltalk specialSelectorIndexOrNil: sym.
					method hasSelector: sym specialSelectorIndex: specialIndex ] ]
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
	self withWindowDo: [ :window | window title: self windowTitle ]
]

{ #category : 'layout' }
StMethodBrowser >> verticalLayout [

	^ SpBoxLayout newTopToBottom
		  add: toolbarPresenter expand: false;
		  add: (SpPanedLayout newTopToBottom
				   add: (SpBoxLayout newTopToBottom
						    add: methodList;
						    add: filterPresenter filterInputPresenter expand: false;
						    yourself);
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

{ #category : 'accessing' }
StMethodBrowser >> windowTitle [

	| msg total |
	(filterPresenter isNil or: [ methodList isNil ]) ifTrue: [ ^ title ifNil: [ 'Message Browser' ] ].
	(title isNotNil and: [ self methods isEmpty ])  ifTrue: [ ^ title , ' [No Results]' ].
	total := filterPresenter unfilteredItems size.
	msg := methodList ifNil: [ '' ] ifNotNil: [
			       (filterPresenter filterText isEmpty or: [ methodList numberOfElements = total ])
				       ifTrue: [ ' [' , total printString , ']' ]
				       ifFalse: [ ' [' , methodList numberOfElements printString , '/' , total printString , ']' ] ].
	^ (title ifNil: [ 'Message Browser' ]) , msg
]
