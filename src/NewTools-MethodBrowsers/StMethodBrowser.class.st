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
		'textPresenter',
		'highlight',
		'filterPresenter',
		'allMethods',
		'titleChangedCallbacks',
		'acceptBlock'
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

{ #category : 'opening - old' }
StMethodBrowser class >> browse: aCollection [
	"Basic version. Opens a browser on the given collection of methods without setting a title or refreshing block."

	^ self browse: aCollection withInitializationBlock: [ :browser | browser methods: aCollection ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asImplementorsOf: aSymbol [

	^ self browse: aCollection asImplementorsOfAll: { aSymbol }
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asImplementorsOfAll: aCollectionOfSymbols [

	^ self
		  browse: aCollection
		  withInitializationBlock: [ :browser | browser methods: aCollection asImplementorsOfAll: aCollectionOfSymbols ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asReferencesToClass: aCallerClass [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ self
		browse: aCollection
		withInitializationBlock: [ :browser | browser methods: aCollection asReferenceTo: aCallerClass binding ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asReferencesToLiteral: aLiteral [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ self browse: aCollection withInitializationBlock: [ :browser | browser methods: aCollection asReferenceTo: aLiteral ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asReferencesToVariable: aVariable inClass: aClass [
	"Specialized version for better UX feedback for class references and explicit list of methods"

	^ self
		browse: aCollection
		withInitializationBlock: [ :browser | browser methods: aCollection asReferencesToVariable: aVariable inClass: aClass binding ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods asSendersOf: aSymbol [
	"Specialized version for better UX feedback for senders and explicit list of methods"

	^ self
		browse: compiledMethods
		withInitializationBlock: [ :browser | browser methods: compiledMethods asSendersOfAll: { aSymbol } ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: aCollection asSendersOfAll: aCollectionOfSymbols [
	"Specialized version for better UX feedback for senders of all given selectors."

	^ self
		browse: aCollection
		withInitializationBlock: [ :browser | browser methods: aCollection asSendersOfAll: aCollectionOfSymbols ]
]

{ #category : 'opening - old' }
StMethodBrowser class >> browse: aCollection title: aString from: aClass [
	"Basic version with limited UX feedback. Use only if you cannot use the other methods."

	^ self
		browse: aCollection
		withInitializationBlock: [ :browser |
				browser
					methods: aCollection;
					title: aString ]
]

{ #category : 'opening explicit' }
StMethodBrowser class >> browse: compiledMethods withInitializationBlock: aBlock [

	| browser |
	browser := self new.
	aBlock value: browser.
	browser allMethods ifEmpty: [
			StPharoApplication current inform: 'No result found'.
			^ nil ].
	^ StMethodBrowserGroup addOrCreateTab: browser
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

	^ self
		browse: methods
		withInitializationBlock: [ :browser |
				browser
					methods: methods asArray;
					title: 'References to ' , (', ' join: (variables collect: [ :v | v name ])) ]
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

	^ self
		browse: methods
		withInitializationBlock: [ :browser |
				browser
					methods: methods asArray;
					title: 'Users of pool ' , aPoolClass name ]
]

{ #category : 'opening' }
StMethodBrowser class >> browseUsersOfTrait: aTrait [

	| methods classes |
	classes := aTrait traitUsers.
	methods := classes flatCollect: [ :cls | cls methods select: [ :m | m origin = aTrait ] ].

	^ self
		browse: methods
		withInitializationBlock: [ :browser |
				browser
					methods: methods asArray;
					title: 'Users of trait ' , aTrait name ]
]

{ #category : 'opening' }
StMethodBrowser class >> browseWritersOfVariables: variables [

	| methods |
	methods := SystemNavigation default allMethods select: [ :m | variables anySatisfy: [ :var | var isWrittenIn: m ] ].

	^ self
		browse: methods
		withInitializationBlock: [ :browser |
				browser
					methods: methods asArray;
					title: 'Writers to ' , (', ' join: (variables collect: [ :v | v name ])) ]
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
	"Do not use aSymbol senders because it is a disguised global.
	When browsing senders of a trait method we only want to have the method trait itself.
Therefore, we need both checks here because if we just put isFromTrait, we wouldn't have any methods coming from a Trait.
And the second check allows to know whether the method is coming from a trait OR used from a trait."

	| allSenders |
	allSenders := SystemNavigation default allSendersOf: aSymbol.

	^ allSenders reject: [ :sender | sender isFromTrait and: [ sender origin ~= sender methodClass ] ]
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
				  withStamp: DateAndTime now
				  notifying: notifyer
				  logSource: true ]
]

{ #category : 'api' }
StMethodBrowser >> acceptBlock [

	^ acceptBlock
]

{ #category : 'api' }
StMethodBrowser >> acceptBlock: aBlock [
	acceptBlock := aBlock
]

{ #category : 'announcements' }
StMethodBrowser >> acceptsItem: item fromAnnouncement: anAnnouncement [
	"The acceptBlock checks if the argument should be accepted on the browser list"

	^ acceptBlock cull: item cull: anAnnouncement cull: self
]

{ #category : 'private' }
StMethodBrowser >> addHighlightedSegments [

	| message highlightInterval highlights |
	message := self selectedMethod.
	message ifNil: [ ^ self ].

	highlights := (highlight isCollection and: [ highlight isString not ])
		              ifTrue: [ highlight ]
		              ifFalse: [ { highlight } ].

	highlights asArray do: [ :each |
			highlightInterval := (self isMethodDefinition: message)
				                     ifFalse: [ self intervalOf: each inCommentText: textPresenter text ]
				                     ifTrue: [ self intervalOf: each inCode: textPresenter text of: message ].

			textPresenter codePresenter selectionInterval: highlightInterval ]
]

{ #category : 'accessing' }
StMethodBrowser >> allMethods [

	^ allMethods
]

{ #category : 'private - scopes' }
StMethodBrowser >> allScopes [ 
	
	^ methodList allScopes
]

{ #category : 'private - scopes' }
StMethodBrowser >> applyCurrentScopeAndFilter [

	| scopedMethods currentFilter currentScope |
	currentScope := toolbarPresenter currentScope.

	scopedMethods := currentScope ifNil: [ allMethods ] ifNotNil: [ :scope |
			                 | scoped |
			                 scoped := (scope selectMessagesFrom: allMethods) asOrderedCollection.
			                 allMethods select: [ :m | scoped includes: m ] ].
	currentFilter := filterPresenter filterText.
	filterPresenter unfilteredItems: scopedMethods.
	currentFilter isEmpty
		ifTrue: [ methodList methods: scopedMethods ]
		ifFalse: [ filterPresenter applyFilter: currentFilter ].

	self selectIndex: 1
]

{ #category : 'api - private' }
StMethodBrowser >> canHandleAnnouncement [

	^ self isDisplayed and: [ acceptBlock isNotNil ]
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

{ #category : 'tools support' }
StMethodBrowser >> confirmDiscardChanges [

	textPresenter isDirty ifFalse: [ ^ true ].

	^ self application confirm: 'Changes have not been saved. Is it OK to discard changes?'
]

{ #category : 'initialization' }
StMethodBrowser >> connectPresenters [

	| isReverting |
	isReverting := false.

	methodList
		whenSelectionChangedDo: [ :selection |
				isReverting ifFalse: [
							self confirmDiscardChanges
								ifTrue: [ self selectItem: selection selectedItem ]
								ifFalse: [
										| oldIndex |
										oldIndex := self methods indexOf: self codeEditor codePresenter selectedMethod.
										isReverting := true.
										self defer: [
													[
														methodList unselectAll.
														self selectIndex: oldIndex ] ensure: [ isReverting := false ] ] ] ] ];
		whenModelChangedDo: [ self updateTitle ].

	textPresenter
		whenSubmitDo: [ :text | self accept: text notifying: textPresenter interactionModel ];
		whenResetDo: [ self selectItem: methodList selectedMethod ].
	filterPresenter filterInputPresenter whenTextChangedDo: [ :text |
			| currentScope scopedMethods filtered |
			currentScope := toolbarPresenter currentScope.
			scopedMethods := currentScope
				                 ifNil: [ allMethods ]
				                 ifNotNil: [ :scope | (scope selectMessagesFrom: allMethods) asOrderedCollection ].
			text ifEmpty: [ methodList methods: scopedMethods ] ifNotEmpty: [
					filtered := scopedMethods select: [ :m | (filterPresenter display value: m) asLowercase includesSubstring: text asLowercase ].
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

	| addedMethod previouslySelectedMethod previousEditedText |
	self canHandleAnnouncement ifFalse: [ ^ self ].
	addedMethod := anAnnouncement method.
	(self acceptsItem: addedMethod fromAnnouncement: anAnnouncement) ifFalse: [ ^ self ].
	(addedMethod methodClass isNotNil and: [ addedMethod methodClass isObsolete not ]) ifFalse: [ ^ self ].

	previousEditedText := textPresenter isDirty ifTrue: [ textPresenter text ].
	previouslySelectedMethod := self selectedMethod.

	(self itemMatching: addedMethod) ifNil: [ allMethods add: addedMethod ].

	self applyCurrentScopeAndFilter.

	self defer: [
			methodList unselectAll.
			self selectIndex: (self methods indexOf: previouslySelectedMethod ifAbsent: [ 1 ]) ].

	previousEditedText ifNotNil: [
			textPresenter text: previousEditedText.
			textPresenter markDirty ]
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodModified: anAnnouncement [

	| newCompiledMethod oldCompiledMethod existingItem existingItemIndex previousSelectionIndex previousEditedText |
	self canHandleAnnouncement ifFalse: [ ^ self ].

	newCompiledMethod := anAnnouncement newMethod.
	oldCompiledMethod := anAnnouncement oldMethod.

	existingItem := self itemMatching: oldCompiledMethod.

	existingItem ifNil: [
		"Case 1, it's a new method => add it!"
		(self acceptsItem: newCompiledMethod fromAnnouncement: anAnnouncement) ifTrue: [
				allMethods add: newCompiledMethod.
				self applyCurrentScopeAndFilter ].
		^ self ].

	previousEditedText := textPresenter isDirty ifTrue: [ textPresenter text ].
	previousSelectionIndex := methodList selectedIndex.

	existingItemIndex := allMethods indexOf: existingItem .

	"Case 2, the new version of the method is not valid anymore => remove it!"
	(self acceptsItem: newCompiledMethod fromAnnouncement: anAnnouncement) ifFalse: [
			existingItemIndex > 0 ifTrue: [ allMethods removeIndex: existingItemIndex ].
			self applyCurrentScopeAndFilter.
			self defer: [
					methodList unselectAll.
					self selectIndex: (previousSelectionIndex min: self methods size) ].
			^ self ].

	"Case 2, the new version of the method is valid => update it!"
	existingItemIndex > 0
		ifTrue: [ allMethods at: existingItemIndex put: newCompiledMethod ]
		ifFalse: [ allMethods add: newCompiledMethod ].
	self applyCurrentScopeAndFilter.
	self defer: [
			methodList unselectAll.
			self selectIndex: previousSelectionIndex ].

	previousEditedText ifNotNil: [
			textPresenter text: previousEditedText.
			textPresenter markConflict ]
]

{ #category : 'announcements' }
StMethodBrowser >> handleMethodRemoved: anAnnouncement [

	| removedCompiledMethod removedItem previouslySelectedMethod previousSelectionIndex |
	self canHandleAnnouncement ifFalse: [ ^ self ].
	self okToChange ifFalse: [ ^ self ].

	removedCompiledMethod := anAnnouncement method.
	(removedCompiledMethod methodClass isNotNil and: [ removedCompiledMethod methodClass isObsolete not ]) ifFalse: [ ^ self ].

	removedItem := self itemMatching: removedCompiledMethod.
	removedItem ifNil: [ ^ self ].

	previouslySelectedMethod := self selectedMethod.
	previousSelectionIndex := methodList selectedIndex.

	allMethods remove: removedItem ifAbsent: [ ].
	self applyCurrentScopeAndFilter.

	self defer: [
			methodList unselectAll.
			previouslySelectedMethod = removedItem
				ifTrue: [ self selectIndex: (previousSelectionIndex min: self methods size) ]
				ifFalse: [ self selectIndex: (self methods indexOf: previouslySelectedMethod) ] ]
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

	allMethods := OrderedCollection new.
	textPresenter := self newCodeEditor.
	textPresenter codePresenter: methodCodePresenter.
	methodCodePresenter whenTextChangedDo: [ :aString | textPresenter markDirty ].
	acceptBlock := [ :item | true ].
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
	"Icons styler are only supported for method definitions (not nil / not for comment definitions    
     (those may occure for comment or general string searches))"

	(self isMethodDefinition: anItem) ifFalse: [ ^ self ].

	IconStyler withSpecStaticStyler 
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

{ #category : 'testing' }
StMethodBrowser >> isDirty [

	^ textPresenter isDirty
]

{ #category : 'api - private' }
StMethodBrowser >> itemMatching: aCompiledMethod [

	^ allMethods
		  detect: [ :method | method methodClass = aCompiledMethod methodClass and: [ method selector = aCompiledMethod selector ] ]
		  ifNone: [ nil ]
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
	allMethods := aCollection asOrderedCollection.
	currentFilter := filterPresenter filterText.
	filterPresenter unfilteredItems: allMethods.
	methodList methods: allMethods.
	
	"Select the first index when the list is set for the first time"
	self selectIndex: 1.
	
	self toolbarPresenter updatePresenter.
	currentFilter isEmpty ifFalse: [ filterPresenter applyFilter: currentFilter ]
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
StMethodBrowser >> methods: compiledMethods asSendersOfAll: aCollectionOfSymbols [

	self
		setRefreshingBlockForSendersOfAll: aCollectionOfSymbols;
		highlight: aCollectionOfSymbols;
		methods: compiledMethods;
		title: 'Senders of ' , (', ' join: aCollectionOfSymbols)
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

{ #category : 'enumerating' }
StMethodBrowser >> onTitleChangedDo: aBlock [

	titleChangedCallbacks ifNil: [ titleChangedCallbacks := OrderedCollection new ].
	titleChangedCallbacks add: aBlock
]

{ #category : 'private' }
StMethodBrowser >> packageNameForItem: anItem [
	^ anItem package ifNil: [ '' ] ifNotNil: [ :package | package name ]
]

{ #category : 'accessing' }
StMethodBrowser >> refreshingBlock: aFullBlockClosure [ 
	
	self
		deprecated: 'Use acceptBlock: instead'
		transformWith: '`@rcv refreshingBlock: `@arg' -> '`@rcv acceptBlock: `@arg'.

	self acceptBlock: aFullBlockClosure 
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
StMethodBrowser >> setRefreshingBlockForClassReferencesOf: aString [

	self acceptBlock: [ :method | method hasLiteral: aString ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForImplementorsOfAll: aCollectionOfSymbols [

	self acceptBlock: [ :message | aCollectionOfSymbols anySatisfy: [ :sel | message selector = sel ] ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForReferencesToSlot: aSlot [

	self acceptBlock: [ :method | method accessesSlot: aSlot ]
]

{ #category : 'api' }
StMethodBrowser >> setRefreshingBlockForSendersOfAll: aCollectionOfSymbols [

	self acceptBlock: [ :method |
			aCollectionOfSymbols anySatisfy: [ :sym |
					| specialIndex |
					specialIndex := Smalltalk specialSelectorIndexOrNil: sym.
					method hasSelector: sym specialSelectorIndex: specialIndex ] ]
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

{ #category : 'system annoucements' }
StMethodBrowser >> unregisterFromAnnouncements [

	TestCase historyAnnouncer unsubscribe: methodList.
	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'api' }
StMethodBrowser >> updateTitle [
    | newTitle |
    newTitle := self windowTitle.
    self withWindowDo: [ :window | window title: newTitle ].
    titleChangedCallbacks ifNotNil: [
        titleChangedCallbacks do: [ :callback | callback value: newTitle ] ]
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
  
	total := allMethods size.
	msg := methodList ifNil: [ '' ] ifNotNil: [
			       (filterPresenter filterText isEmpty or: [ methodList numberOfElements = total ])
				       ifTrue: [ ' [' , total printString , ']' ]
				       ifFalse: [ ' [' , methodList numberOfElements printString , '/' , total printString , ']' ] ].
	^ (title ifNil: [ 'Message Browser' ]) , msg
]
