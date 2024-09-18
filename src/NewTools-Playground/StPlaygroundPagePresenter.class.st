"
The content of a playground page. 
Since `StPlayground` is in fact a miller list that allows users to navigate, the actual ""playground"" resides here.
"
Class {
	#name : 'StPlaygroundPagePresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'text',
		'toolbar',
		'statusbar',
		'lineLabel',
		'toggleLineNumberButton',
		'page',
		'activationBlock',
		'loading'
	],
	#classVars : [
		'CacheDirectory'
	],
	#category : 'NewTools-Playground-View',
	#package : 'NewTools-Playground',
	#tag : 'View'
}

{ #category : 'private commands' }
StPlaygroundPagePresenter class >> baseToolbarCommands [

	^ { 
		StPlaygroundDoItCommand.
		StPlaygroundPublishCommand.
		StPlaygroundBindingsCommand.				
		StPlaygroundVersionsCommand.
		StPlaygroundPagesCommand.
	}
]

{ #category : 'accessing' }
StPlaygroundPagePresenter class >> cacheDirectory [
	
	^ CacheDirectory ifNil: [ self defaultCacheDirectory ]
]

{ #category : 'accessing' }
StPlaygroundPagePresenter class >> cacheDirectory: aDirectory [
	
	self flag: #TODO. "This go to settings"
	CacheDirectory := aDirectory ensureCreateDirectory
]

{ #category : 'private' }
StPlaygroundPagePresenter class >> defaultCacheDirectory [
	
	^ (FileLocator localDirectory / 'play-cache') ensureCreateDirectory
]

{ #category : 'layout' }
StPlaygroundPagePresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 3;
		add: #toolbar expand: false;
		add: #text;
		add: #statusbar expand: false;
		yourself
]

{ #category : 'accessing' }
StPlaygroundPagePresenter class >> defaultTitle [ 

	^ 'Playground'
]

{ #category : 'private commands' }
StPlaygroundPagePresenter class >> extendedMenuCommands [

	^ StPlaygroundMenuExtensionCommand allCommands
]

{ #category : 'private commands' }
StPlaygroundPagePresenter class >> extendedToolbarCommands [

	^ StPlaygroundToolbarExtensionCommand allCommands
]

{ #category : 'instance creation' }
StPlaygroundPagePresenter class >> open [ 
	<script>
	
	^ (self on: StPlaygroundPage new) open
]

{ #category : 'instance creation' }
StPlaygroundPagePresenter class >> openContents: aString [
	"Open a new workspace with the given contents. It looks better when aString is code since the style is applied"

	^ self new
		contents: aString;
		open
]

{ #category : 'tools registry' }
StPlaygroundPagePresenter class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]" 

	registry register: self as: #workspace

]

{ #category : 'private commands' }
StPlaygroundPagePresenter class >> toolbarCommands [

	^ (self baseToolbarCommands, self extendedToolbarCommands) sorted: #order ascending
]

{ #category : 'api' }
StPlaygroundPagePresenter >> activateOnDoubleClick [
	"For compatibility, playground will not activate on single or double click (but in <meta+g>)"
]

{ #category : 'api' }
StPlaygroundPagePresenter >> activateOnSingleClick [
	"For compatibility, playground will not activate on single or double click (but in <meta+g>)"
]

{ #category : 'private' }
StPlaygroundPagePresenter >> addMenuCommandsTo: aGroup [

	self class extendedMenuCommands 
		do: [ :each | aGroup register: (each forSpecContext: self) ]	
]

{ #category : 'private' }
StPlaygroundPagePresenter >> addMenuEditionCommandsTo: aCommandGroup presenter: aCodePresenter [

	aCodePresenter backendIncludesEditionMenu ifTrue: [ ^ self ].
	aCommandGroup register: (aCodePresenter editionCommandsGroup name: 'Edition')
]

{ #category : 'private' }
StPlaygroundPagePresenter >> addToolbarCommandsTo: aGroup [

	self class toolbarCommands do: [ :each | 
		aGroup register: (each forSpecContext: self) ]
]

{ #category : 'private' }
StPlaygroundPagePresenter >> basicPage: aPage [ 

	page := aPage
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> contents: aString [

	text text: aString
]

{ #category : 'api - focus' }
StPlaygroundPagePresenter >> defaultKeyboardFocus [

	^ text
]

{ #category : 'commands' }
StPlaygroundPagePresenter >> doEvaluateAllAndGo [

	self selectAll.
	self doEvaluateAndGo
]

{ #category : 'commands' }
StPlaygroundPagePresenter >> doEvaluateAndGo [
	| value |

	activationBlock ifNil: [ ^ self ].

	value := text
		evaluate: text selectedTextOrLine
		onCompileError: [ ^ self ]
		onError: [ :e | e pass ].

	activationBlock value: value
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> ensureContentsFlushed [

	self page ensureContentsFlushed
]

{ #category : 'testing' }
StPlaygroundPagePresenter >> hasOutputActivationPort [
	
	^ true
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> initialize [

	loading := false.
	super initialize
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> initializePresenters [

	self initializeToolbar.
	self initializeStatusbar.

	(text := self newCode)
		interactionModel: StPlaygroundInteractionModel new;
		lineNumbers: self showLineNumbers;
		overridingContextMenu;
		withEditionContextMenu;
		actions: (self menuActionsFor: text);
		whenTextChangedDo: [ :aString | self updateContents: aString ].

	text announcer
		when: SpCodeWillBeEvaluatedAnnouncement
		send: #ensureContentsFlushed
		to: self.

	text eventHandler
		whenKeyUpDo: [ :event | self updateLineNumber ];
		whenMouseUpDo: [ :event | self updateLineNumber ];
		"before taking focus position will be nil, ensure I have the correct one"
		whenFocusReceivedDo: [ self updateLineNumber ]
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> initializeStatusbar [ 

	(statusbar := self instantiate: SpPresenter)
		layout: (SpBoxLayout newLeftToRight
			borderWidth: 3;
			vAlignCenter;
			add: (lineLabel := statusbar newLabel) expand: false;
			addLast: (toggleLineNumberButton := statusbar newToggleButton) expand: false;
			yourself).

	lineLabel addStyle: 'dim'.

	toggleLineNumberButton
		label: (StShowLineNumbersCommand iconLabelFor: self showLineNumbers);
		help: StShowLineNumbersCommand defaultDescription;
		state: self showLineNumbers;
		whenChangedDo: [ :state | self showLineNumbers: state ]
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> initializeToolbar [

	toolbar := self newToolbar
		displayMode: self application toolbarDisplayMode;
		addStyle: 'stToolbar';
		fillWith: self toolbarActions;
		yourself
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self class defaultTitle;
		windowIcon: self windowIcon;
		whenOpenedDo: [ text takeKeyboardFocus ]
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> interactionModel [

	^ text interactionModel
]

{ #category : 'actions' }
StPlaygroundPagePresenter >> loadPage: aPage [

	loading := true.
	
	[
		self basicPage: aPage.
		aPage onFlush: [
			self announce: (StPlaygroundPageFlushed newPage: aPage) ].
		self announce: (StPlaygroundPageLoaded newPage: aPage).
		self updatePresenter ]
	ensure: [ 
		loading := false ].
	
	^ page
]

{ #category : 'private' }
StPlaygroundPagePresenter >> menuActionsFor: aCodePresenter [

	^ CmCommandGroup forSpec
		beRoot;
		register: ((CmCommandGroup named: 'Extra') asSpecGroup
			beDisplayedAsGroup;
			register: (StEvaluateCommand forSpecContext: self);
			yourself);
		register: (aCodePresenter rootCommandsGroup name: 'Code');
		in: [ :this | self addMenuEditionCommandsTo: this presenter: aCodePresenter ];
		in: [ :this | self addMenuCommandsTo: this ];
		register: ((CmCommandGroup named: 'Playground') asSpecGroup
			register: ((CmCommandGroup named: 'Base options') asSpecGroup
				beDisplayedAsGroup;
				in: [ :this | self addToolbarCommandsTo: this ];
				yourself);
			register: ((CmCommandGroup named: 'Miscelaneous options') asSpecGroup
				beDisplayedAsGroup;
				register: (StShowLineNumbersCommand forSpecContext: self);
				yourself);
			yourself);
		yourself
]

{ #category : 'transmission' }
StPlaygroundPagePresenter >> outputActivationPort [

	^ SpActivationPort newPresenter: self
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> page [

	^ page
]

{ #category : 'private' }
StPlaygroundPagePresenter >> preferredExtent: aSize [

	(self window isMaximized 
		or: [ self window isMinimized ])
		ifTrue: [ ^ self ].
	self class preferredExtent: aSize
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> selectAll [
	
	^ text selectAll
]

{ #category : 'inspector compatibility' }
StPlaygroundPagePresenter >> selectedPageName [
	"Since the playground can be the starting point of an inspection (using <meta+g>), the 
	 page presenter (which is the playground itself) needs to respond to which kind of page 
	 is selected."

	^ self class defaultTitle
]

{ #category : 'accessing' }
StPlaygroundPagePresenter >> selectedTextOrLine [
	
	^ text selectedTextOrLine
]

{ #category : 'accessing - model' }
StPlaygroundPagePresenter >> setModelBeforeInitialization: aPage [

	page := aPage
]

{ #category : 'private' }
StPlaygroundPagePresenter >> showLineNumbers [

	^ StPharoSettings codeShowLineNumbers
]

{ #category : 'private - actions' }
StPlaygroundPagePresenter >> showLineNumbers: aBoolean [

	StPharoSettings codeShowLineNumbers: aBoolean.
	text lineNumbers: aBoolean.
	toggleLineNumberButton label: (StShowLineNumbersCommand iconLabelFor: self showLineNumbers)
]

{ #category : 'private' }
StPlaygroundPagePresenter >> text [

	^ text
]

{ #category : 'actions' }
StPlaygroundPagePresenter >> toggleShowLineNumbers [

	self showLineNumbers: self showLineNumbers not
]

{ #category : 'private' }
StPlaygroundPagePresenter >> toolbarActions [

	^ CmCommandGroup forSpec
		in: [ :this | self addToolbarCommandsTo: this ];
		yourself
]

{ #category : 'private - updating' }
StPlaygroundPagePresenter >> updateContents: aString [

	loading ifTrue: [ ^ self ].
	self page contents: aString
]

{ #category : 'private - updating' }
StPlaygroundPagePresenter >> updateLineNumber [
	| pos |
	
	lineLabel ifNil: [ ^ self ].	
	pos := text cursorPosition.
	lineLabel label: (pos 
		ifNotNil: [ ('Line: {1}:{2}' format: { pos y. pos x }) ]
		ifNil: [ '' ])
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> updatePresenter [

	page ifNotNil: [
		text text: page contents ].
	self updateLineNumber
]

{ #category : 'api - events' }
StPlaygroundPagePresenter >> whenActivatedDo: aBlock [

	activationBlock := aBlock
]

{ #category : 'initialization' }
StPlaygroundPagePresenter >> windowIcon [
	
	^ self application iconNamed: #workspace
]
