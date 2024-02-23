"
I am a tool made for browsing the several versions of the provided method.

I will list of the history of the method available in the sources of the image.

Examples
--------------------

	self browseVersionsForClass: self selector: #initializePresenters
	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	isShowingDiff:			<aBoolean>		Since I can show a diff or a code presenter, I am a boolean here to know which one is currently selected.
	rgMethod:					<aRGMethod>		The method to browse the versions.
	sourcePresenter:		<aPresenter>		Either a code or diff presenter depending on the informations the user wants to know.
					
	Maybe the #sourcePreseneter management should be extracted into a Strategy design pattern later to have a cleaner code.

"
Class {
	#name : 'StVersionBrowserPresenter',
	#superclass : 'StAbstractMessageCentricBrowserPresenter',
	#instVars : [
		'rgMethod',
		'sourcePresenter',
		'sourceLayout'
	],
	#category : 'NewTools-MethodBrowsers-Versions',
	#package : 'NewTools-MethodBrowsers',
	#tag : 'Versions'
}

{ #category : 'api' }
StVersionBrowserPresenter class >> browseVersionsForClass: aClass selector: aSelector [
	^ aClass
		compiledMethodAt: aSelector
		ifPresent: [ :method | self browseVersionsForMethod: method ]
		ifAbsent: [ SpInformDialog new
							title: 'Alert';
							label:
								('No method {1} in class {2}'
									format: {aSelector . aClass printString}); 
									openModal ]
]

{ #category : 'api' }
StVersionBrowserPresenter class >> browseVersionsForMethod: aRingMethod [

	^ (self on: aRingMethod) open
]

{ #category : 'tools registry' }
StVersionBrowserPresenter class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"

	registry register: self as: #versionBrowser
]

{ #category : 'visiting' }
StVersionBrowserPresenter >> accept: text notifying: notifyer [
	| message |

	message := self selectedMessage.
	message ifNil: [ ^ self ].
	
	message methodClass 
		compile: text 
		classified: message protocol
		notifying: notifyer
]

{ #category : 'actions' }
StVersionBrowserPresenter >> browseImplementors [
	SystemNavigation new browseAllImplementorsOf: rgMethod selector
]

{ #category : 'actions' }
StVersionBrowserPresenter >> browseSenders [

	self systemNavigation 
		browseSendersOf: rgMethod selector 
		name: 'Senders of ', rgMethod selector 
		autoSelect: rgMethod selector
]

{ #category : 'private - factory' }
StVersionBrowserPresenter >> buildChangeList [
	rgMethod sourcePointer ifNil:[ ^ #() ].

	^ (SourceFiles changeRecordsFor: rgMethod)
		collectWithIndex: [ :c :i | | rg |
			rg := c asRingDefinition.
			rg annotationNamed: #versionIndex put: i ]
]

{ #category : 'accessing' }
StVersionBrowserPresenter >> changeList [
	^ messageList messages
]

{ #category : 'private - actions' }
StVersionBrowserPresenter >> compareTo: anOtherVersion withLabel: aLabel [
	| versions texts |

	versions := Array with: anOtherVersion with: self selectedMessage.
	texts := (DiffVersionChangeRecordConverter 
		methodReference: anOtherVersion 
		referencesList: versions) 
		getText.

	((SpDiffPresenter newApplication: self application)
		leftText: texts first;
		rightText: texts second;
		asWindow) 
			title: ('Comparison from {1} to {2}' format: { versions second stamp. aLabel });
			initialExtent: 900@600;
			open
]

{ #category : 'actions' }
StVersionBrowserPresenter >> compareToCurrentVersion [
	self compareTo: rgMethod withLabel: 'Current version'
]

{ #category : 'actions' }
StVersionBrowserPresenter >> compareToOtherVersion [
	| labels versions index selected |
	versions := self changeList.
	labels := versions collect: [ :each | each stamp ].
	index := self application newSelect title: 'Select a version'; item: labels; openModal.
	index > 0 ifFalse: [ ^ self ].
	selected := versions at: index.
	self compareTo: selected withLabel: selected stamp
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> connectPresenters [

	messageList
		whenSelectedDo: [ :item | self selectItem: item ];
		messages: self buildChangeList.
	toolbarPresenter selectFirst
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: toolbarPresenter expand: false; 
		add: (SpPanedLayout newTopToBottom
			add: messageList;
			add: (sourceLayout := SpBoxLayout newTopToBottom);
			yourself);
		yourself
]

{ #category : 'actions' }
StVersionBrowserPresenter >> doBrowseImplementors [

	SystemNavigation new browseAllImplementorsOf: rgMethod selector
]

{ #category : 'actions' }
StVersionBrowserPresenter >> doBrowseSenders [

	self systemNavigation 
		browseSendersOf: rgMethod selector 
		name: 'Senders of ', rgMethod selector 
		autoSelect: rgMethod selector
]

{ #category : 'actions' }
StVersionBrowserPresenter >> doCompareToCurrentVersion [

	self compareTo: rgMethod withLabel: 'Current version'
]

{ #category : 'actions' }
StVersionBrowserPresenter >> doCompareToOtherVersion [
	| labels versions selected |
	
	versions := self changeList.
	labels := versions collect: [ :each | each stamp ].
	
	selected := self application newSelect 
		title: 'Select a version'; 
		items: versions;
		display: [ :aVersion | aVersion stamp ];
		openModal.
	selected ifNil: [ ^ self ].

	self compareTo: selected withLabel: selected stamp
]

{ #category : 'actions' }
StVersionBrowserPresenter >> doRevert [
	self revert: self selectedMessage
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> initializePresenters [

	messageList := self newMessageList.
	toolbarPresenter := self newMessageToolbar.
	 
	messageList
		topologicSort: false;
		sortingBlock: [ :a | a annotationNamed: #versionIndex ifAbsent: [ 0 ] ] ascending.

	self flag: #TODO. "I need this for now, but this is because toolbar is wrong :P"
	self layout: self defaultLayout.
	
	toolbarPresenter
		addItemLabeled: 'Side By Side' do: [
			self showDiffMorphWithConverter: (DiffSideBySideChangeRecordConverter 
				methodReference: self textConverter method 
				referencesList: self changeList) ];
		addItemLabeled: 'Source' do: [ 
			self showSourceWithConverter: (DiffSourceMethodConverter method: self textConverter method) ];
		addItemLabeled: 'Diff' do: [ 
			self showDiffLineWithConverter: (DiffLineChangeRecordConverter 
				methodReference: self textConverter method
				referencesList: self changeList) ]
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Recent versions of ' , rgMethod displayName
]

{ #category : 'private' }
StVersionBrowserPresenter >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches)) and in the case the source presenter is not a diff"

	(self isMethodDefinition: anItem) ifFalse: [ ^ self ].

	IconStyler withStaticStylers 
		styleText: sourcePresenter 
		withAst: anItem ast
]

{ #category : 'accessing' }
StVersionBrowserPresenter >> messageListMenu [

	self flag: #TODO. "At least some of this options needs to be a command"
	^ self newMenu
		addGroup: [ :aGroup | 
			aGroup
				addItem: [ :anItem | 
					anItem
						name: 'Compare to current';
						help: 'Compare selected version to the current version';
						action: [ self compareToCurrentVersion ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Compare to version...';
						help: 'Compare selected version to another selected version';
						action: [ self compareToOtherVersion ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Revert to selected version';
						help: 'Resubmit the selected version, so that it becomes the current version';
						action: [ self revert: self selectedMessage ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Senders';
						shortcut: $n meta;
						action: [ self browseSenders ] ];
				addItem: [ :anItem | 
					anItem
						name: 'Implementors';
						shortcut: $m meta;
						action: [ self browseImplementors ] ] ];
		yourself
]

{ #category : 'accessing' }
StVersionBrowserPresenter >> method [

	^ rgMethod
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> newMessageList [

	^ self instantiate: StMessageVersionListPresenter
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> newMessageToolbar [
		
	^ (self instantiate: StMethodHistoryToolbarPresenter on: rgMethod)
		whenRevertDo: [ self doRevert ];
		yourself
]

{ #category : 'private - factory' }
StVersionBrowserPresenter >> newSourceDiff [

	^ self newDiff
]

{ #category : 'private - factory' }
StVersionBrowserPresenter >> newTextConverter [

	^ DiffSideBySideChangeRecordConverter new
]

{ #category : 'private' }
StVersionBrowserPresenter >> replaceSourceWith: aPresenter [
	
	sourceLayout children  
		ifNotEmpty: [ 
			sourceLayout replace: sourcePresenter with: aPresenter ]
		ifEmpty: [ 
			sourceLayout add: aPresenter ].
		
	sourcePresenter := aPresenter.
	messageList selectIndex: messageList selectedIndex
]

{ #category : 'private - factory' }
StVersionBrowserPresenter >> revert: aChangeRecord [

	aChangeRecord ifNil: [
		^ self inform: 'nothing selected, so nothing done' ].

	rgMethod realClass
		compile: aChangeRecord sourceCode
		classified: aChangeRecord category
		withStamp: aChangeRecord stamp
		notifying: nil.

	"reinitialize me"
	self setRGMethodFrom: rgMethod realClass >> rgMethod selector.

	messageList
		messages: self buildChangeList;
		selectIndex: 1
]

{ #category : 'private' }
StVersionBrowserPresenter >> selectItem: item [

	sourcePresenter ifNil: [ ^ self ].

	self setSourceContentWith: (self textConverter
		method: item;
		getText)
]

{ #category : 'accessing - model' }
StVersionBrowserPresenter >> setModelBeforeInitialization: aMethod [

	self setRGMethodFrom: aMethod
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> setRGMethodFrom: aMethod [
"asHistorical, because active RGMethods don't always have the source pointer attached"

	rgMethod := aMethod asRingDefinition asHistorical
]

{ #category : 'private' }
StVersionBrowserPresenter >> setSourceContentWith: content [

	self textConverter 
		updateContent: content 
		on: self
]

{ #category : 'private' }
StVersionBrowserPresenter >> showDiffLineWithConverter: aConverter [
	| newSource |

	self textConverter: aConverter.

	newSource := self instantiate: SpPatchPresenter.
	newSource beForMethod: self selectedMessage.

	self replaceSourceWith: newSource

]

{ #category : 'private' }
StVersionBrowserPresenter >> showDiffMorphWithConverter: aConverter [
	| newSource | 

	self textConverter: aConverter.

	newSource := self newDiff.
	newSource contextClass: (self selectedMessage ifNotNil: [ :message | message methodClass ]).
	self replaceSourceWith: newSource
]

{ #category : 'private' }
StVersionBrowserPresenter >> showSourceWithConverter: aConverter [
	| newSource |

	self textConverter: aConverter.
	
	newSource := self newCode.
	newSource whenSubmitDo: [ :text | (self accept: text notifying: nil) isNotNil ].
	newSource beForMethod: self selectedMessage.

	self replaceSourceWith: newSource

]

{ #category : 'private - updating' }
StVersionBrowserPresenter >> updateDiff: content [

	(content isText or: [ content isString ])
		ifTrue: [ 
			sourcePresenter 
				leftText: '';
				rightText: content ]
		ifFalse: [ 
			sourcePresenter 
				leftText: content first;
				rightText: content second ].
			
		self installIconStylerFor: self textConverter method
]

{ #category : 'private - updating' }
StVersionBrowserPresenter >> updateDiffLine: content [

	(content isText or: [ content isString ])
		ifTrue: [ 
			sourcePresenter 
				patchFrom: '' 
				to: content asString ]
		ifFalse: [ 
			sourcePresenter 
				patchFrom: content first asString
				to: content second asString ].
			
	self installIconStylerFor: self textConverter method
]

{ #category : 'initialization' }
StVersionBrowserPresenter >> updatePresenter [

	self showDiffMorphWithConverter: (DiffSideBySideChangeRecordConverter 
		methodReference: self textConverter method 
		referencesList: self changeList)
]

{ #category : 'private - updating' }
StVersionBrowserPresenter >> updateSource: content [ 

	sourcePresenter text: content
]
