Class {
	#name : 'StPulse',
	#superclass : 'SpPresenter',
	#traits : 'SpTModel',
	#classTraits : 'SpTModel classTrait',
	#instVars : [
		'searchPresenter',
		'resultListPresenter',
		'emptyPresenter',
		'editorListPresenter',
		'toolListPresenter',
		'activePresenter',
		'tabLayout',
		'windowsContext',
		'toolsContext',
		'environmentContext',
		'worker'
	],
	#classInstVars : [
		'pulse'
	],
	#category : 'NewTools-Pulse',
	#package : 'NewTools-Pulse'
}

{ #category : 'accessing' }
StPulse class >> defaultExtent [

	^ 700@350
]

{ #category : 'instance creation' }
StPulse class >> newWithText: aText [

	self reset.
	pulse := self new.
	pulse searchPresenter text: aText.
	^ pulse 
]

{ #category : 'instance creation' }
StPulse class >> open [

	<script>
	self openWithText: ''
]

{ #category : 'instance creation' }
StPulse class >> openWithText: aText [
"If a Spotter is already open, it closes itself and opens the Finder instead.  
 Otherwise, it initializes a new Spotter. The purpose of this is so users can 
 press 'shift+enter' inside the Spotter to open the Finder."
   | searchText |
	pulse ifNotNil: [
		pulse isVisible ifTrue: [
			searchText := pulse searchPresenter text.
			self reset.
			^ StFinderPresenter openWithText: searchText ] ].
	
	pulse := self newWithText: aText.
	^ pulse openModal
]

{ #category : 'instance creation' }
StPulse class >> windowClosed [

	pulse := nil
]

{ #category : 'private - actions' }
StPulse >> acceptSelection [

	self withWindowDo: [ :aWindow | aWindow close ].
	activePresenter selectedItem 
		ifNotNil: [ :anEntry | anEntry accept: self ]
]

{ #category : 'initialization' }
StPulse >> addKeyboardBehavior: aPresenter [

	aPresenter eventHandler whenKeyDownDo: [ :anEvent | 
		"28 = Left Arrow"
		anEvent keyValue = 28
			ifTrue: [ self giveFocusToPreviousResultList ].
		"29 = Right Arrow"
		anEvent keyValue = 29
			ifTrue: [ self giveFocusToNextResultList ].
		"30 = Arrow up | 31 = Arrow down"
		(#(28 29 30 31) includes: anEvent keyValue )
			ifFalse:  [ searchPresenter takeKeyboardFocus ] ]
	
]

{ #category : 'initialization' }
StPulse >> connectPresenters [

	searchPresenter 
		whenTextChangedDo: [ :aString | self doSearch: aString ];
		whenSubmitDo: [ :aString | self acceptSelection ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey down asKeyCombination;
			action: [ self giveFocusToResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey right asKeyCombination actionModifier;
			action: [ self giveFocusToNextResultList ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: KeyboardKey left asKeyCombination actionModifier;
			action: [ self giveFocusToPreviousResultList ] ].
	resultListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ].
	editorListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ].
	toolListPresenter whenActivatedDo: [ :aSelection | self acceptSelection ].
	self addKeyboardBehavior: resultListPresenter.
	self addKeyboardBehavior: editorListPresenter.
	self addKeyboardBehavior: toolListPresenter.
	
	
]

{ #category : 'layout' }
StPulse >> defaultLayout [

	^ SpBoxLayout newVertical
		add: searchPresenter expand: false;
		add: (SpOverlayLayout new 
			"child: resultListPresenter;"
			child: ((tabLayout := SpTabLayout new) 
				add: resultListPresenter label: 'Environment';
				add: editorListPresenter label: 'Windows';
				add: toolListPresenter label: 'Commands';
				whenTabSelectedDo: [ :ann | self tabActivated: ann presenter ];
				yourself);
			addOverlay: emptyPresenter withConstraints: [ :c | c vAlignCenter; hAlignCenter ];
			yourself);
		yourself
]

{ #category : 'private - actions' }
StPulse >> doSearch: aString [
	
	"clean all possible pending tasks (this is *a bit* better, but still annoying :("
	worker purge.
	worker isBusy ifTrue: [ 
		worker finalizer finalize.
		worker start ].
	"now schedule the last one"
	worker schedule: [ 
		| candidates |
		candidates := self model 
			candidatesFor: aString 
			inContext: self selectedContext.
		"just update the last result (empty runner means there are no more tasks) 
		 and since purge ensures there is always just one pending... this should 
		 work slightly better.
		 In anycase it feels smoother :)"
		worker isEmpty ifTrue: [
			self updateResultListWith: candidates ] ]
]

{ #category : 'private' }
StPulse >> environmentContext [

	^ environmentContext ifNil: [ 
		environmentContext := StPulseSearchContext searchEnvironment
			browser: self owner window;
			yourself ]
]

{ #category : 'private' }
StPulse >> giveFocusToNextResultList [
	| nextPresenter |

	nextPresenter := tabLayout children last = activePresenter 
		ifTrue: [ tabLayout children first ]
		ifFalse: [ tabLayout children after: activePresenter ].
		
	tabLayout select: nextPresenter.
	activePresenter takeKeyboardFocus
]

{ #category : 'private' }
StPulse >> giveFocusToPreviousResultList [
	| prevPresenter |

	prevPresenter := tabLayout children first = activePresenter 
		ifTrue: [ tabLayout children last ]
		ifFalse: [ tabLayout children before: activePresenter ].
		
	tabLayout select: prevPresenter.
	activePresenter takeKeyboardFocus
]

{ #category : 'private' }
StPulse >> giveFocusToResultList [

	activePresenter takeKeyboardFocus
]

{ #category : 'initialization' }
StPulse >> initialize [
	
	self setModelBeforeInitialization: StPulseModel new.
	super initialize.
	self initializeWorker
]

{ #category : 'initialization' }
StPulse >> initializeDialogWindow: aDialogWindowPresenter [

]

{ #category : 'initialization' }
StPulse >> initializePresenters [

	self addStyle: 'stSpotter'.
	self addStyle: 'dockSpotter'.

	emptyPresenter := self newLabel 
		addStyle: 'dim';
		label: 'No results yet...';
		yourself.

	searchPresenter := self newSearchInput
		addStyle: 'stSpotterSearch';
		yourself.

	resultListPresenter := self newResultList.
	editorListPresenter := self newResultList.
	toolListPresenter := self newResultList
]

{ #category : 'initialization' }
StPulse >> initializeWindow: aWindowPresenter [
	
	aWindowPresenter 
		initialExtent: self class defaultExtent;
		withoutDecorations;
		whenClosedDo: [ 
			self windowClosed.
			self class windowClosed ];
		centered
]

{ #category : 'initialization' }
StPulse >> initializeWorker [

	worker := TKTWorker new 
		name: 'Pulse-', UUID new asString;
		start
]

{ #category : 'initialization' }
StPulse >> newResultList [

	^ self newEasyListView
		addStyle: 'stList';
		addStyle: 'stSpotterSearch';
		rowPresenterClass: StPulseRow;
		yourself
]

{ #category : 'private' }
StPulse >> searchPresenter [

	^ searchPresenter
]

{ #category : 'private' }
StPulse >> selectedContext [

	activePresenter = editorListPresenter ifTrue: [ ^ self windowsContext ].
	activePresenter = toolListPresenter ifTrue: [ ^ self toolsContext ].
	
	^  self environmentContext
]

{ #category : 'private' }
StPulse >> tabActivated: aPresenter [
	
	activePresenter = aPresenter ifTrue: [ ^ self ].
	
	activePresenter := aPresenter.
	activePresenter ifNotNil: [
		self updateSearchPlaceHolder.
		self doSearch: searchPresenter text ]
]

{ #category : 'private' }
StPulse >> toolsContext [

	^ toolsContext ifNil: [ 
		toolsContext := StPulseSearchContext searchTools
			browser: self owner window;
			yourself ]
]

{ #category : 'initialization' }
StPulse >> updatePresenter [

	super updatePresenter
]

{ #category : 'initialization' }
StPulse >> updateResultListWith: aCollection [
	
	"use defer to ensure UI loop"
	self application defer: [
		emptyPresenter visible: aCollection isEmpty.
		activePresenter updateItemsKeepingSelection: aCollection.
		(activePresenter selectedItem isNil 
			and: [ aCollection isNotEmpty ])
			ifTrue: [ resultListPresenter selectFirst ] ]
]

{ #category : 'initialization' }
StPulse >> updateSearchPlaceHolder [
	
	searchPresenter placeholder: self selectedContext searchPlaceholder
]

{ #category : 'visiting' }
StPulse >> visitClassEntry: aClassEntry [ 
	
	self systemNavigation browse: aClassEntry content
]

{ #category : 'visiting' }
StPulse >> visitMenuEntry: anEntry [ 
	
	anEntry doEvaluate
]

{ #category : 'visiting' }
StPulse >> visitMethodEntry: aClassEntry [ 

	self systemNavigation browse: aClassEntry content
]

{ #category : 'visiting' }
StPulse >> visitWindowEntry: aWindowEntry [
	
	aWindowEntry content stActDefault
]

{ #category : 'private' }
StPulse >> windowClosed [

	worker stop
]

{ #category : 'private' }
StPulse >> windowsContext [

	^ windowsContext ifNil: [ 
		windowsContext := StPulseSearchContext searchEditors
			browser: self owner root;
			yourself ]
]
