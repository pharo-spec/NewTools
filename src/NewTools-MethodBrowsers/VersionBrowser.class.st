"
I am a tool made for browsing the several versions of the provided method.

I will list of the history of the method available in the sources of the image.

Examples
--------------------

	self browseVersionsForClass: self selector: #initializeWidgets
	
 
Internal Representation and Key Implementation Points.
--------------------

    Instance Variables
	isShowingDiff:			<aBoolean>		Since I can show a diff or a code presenter, I am a boolean here to know which one is currently selected.
	rgMethod:					<aRGMethod>		The method to browse the versions.
	sourcePresenter:		<aPresenter>		Either a code or diff presenter depending on the informations the user wants to know.
					
	Maybe the #sourcePreseneter management should be extracted into a Strategy design pattern later to have a cleaner code.

"
Class {
	#name : #VersionBrowser,
	#superclass : #AbstractMessageCentricBrowser,
	#instVars : [
		'rgMethod',
		'sourcePresenter',
		'sourceLayout'
	],
	#category : #'NewTools-MethodBrowsers-Versions'
}

{ #category : #api }
VersionBrowser class >> browseVersionsForClass: aClass selector: aSelector [
	^ aClass
		compiledMethodAt: aSelector
		ifPresent: [ :method | self browseVersionsForMethod: method ]
		ifAbsent: [ self
				inform:
					('No method {1} in class {2}'
						format:
							{aSelector.
							aClass printString}) ]
]

{ #category : #api }
VersionBrowser class >> browseVersionsForMethod: aRingMethod [

	^ (self on: aRingMethod) open
]

{ #category : #specs }
VersionBrowser class >> defaultSpec [
	
	^ nil
]

{ #category : #'tools registry' }
VersionBrowser class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"

	registry register: self as: #versionBrowser
]

{ #category : #visiting }
VersionBrowser >> accept: text notifying: notifyer [
	| message |

	message := self selectedMessage.
	message ifNil: [ ^ self ].
	
	message methodClass 
		compile: text 
		classified: message protocol
		notifying: notifyer
]

{ #category : #actions }
VersionBrowser >> browseImplementors [
	SystemNavigation new browseAllImplementorsOf: rgMethod selector
]

{ #category : #actions }
VersionBrowser >> browseSenders [

	self systemNavigation 
		browseSendersOf: rgMethod selector 
		name: 'Senders of ', rgMethod selector 
		autoSelect: rgMethod selector
]

{ #category : #'private - factory' }
VersionBrowser >> buildChangeList [
	rgMethod sourcePointer ifNil:[ ^ #() ].

	^ (SourceFiles
		changeRecordsFrom: rgMethod sourcePointer
		className: rgMethod instanceSideParentName
		isMeta: rgMethod isMetaSide)
		collectWithIndex: [ :c :i | | rg |
			rg := c asRingDefinition.
			rg annotationNamed: #versionIndex put: i ]
]

{ #category : #accessing }
VersionBrowser >> changeList [
	^ messageList messages
]

{ #category : #actions }
VersionBrowser >> compareTo: anOtherVersion withLabel: aLabel [
	| versions texts |

	versions := Array with: anOtherVersion with: self selectedMessage.
	texts := (DiffVersionChangeRecordConverter 
		methodReference: anOtherVersion 
		referencesList: versions) 
		getText.

	(SpDiffPresenter newApplication: self application)
		title: ('Comparison from {1} to {2}' format: { versions second stamp. aLabel });
		leftText: texts first;
		rightText: texts second;
		openWithSpec
]

{ #category : #actions }
VersionBrowser >> compareToCurrentVersion [
	self compareTo: rgMethod withLabel: 'Current version'
]

{ #category : #actions }
VersionBrowser >> compareToOtherVersion [
	| labels versions index selected |
	versions := self changeList.
	labels := versions collect: [ :each | each stamp ].
	index := UIManager default chooseFrom: labels.
	index > 0 ifFalse: [ ^ self ].
	selected := versions at: index.
	self compareTo: selected withLabel: selected stamp
]

{ #category : #initialization }
VersionBrowser >> connectPresenters [

	messageList
		whenSelectedDo: [ :item | self selectItem: item ];
		messages: self buildChangeList.
	toolbarPresenter dropListModel selectIndex: 1
]

{ #category : #initialization }
VersionBrowser >> defaultLayout [
	^ SpPanedLayout newTopToBottom
		add: messageList;
		add: ((sourceLayout := SpBoxLayout newTopToBottom)
			add: toolbarPresenter expand: false;
			yourself);
		yourself
]

{ #category : #initialization }
VersionBrowser >> initializePresenters [

	messageList := self instantiate: MessageList on: rgMethod.
	toolbarPresenter := self instantiate: SpMethodToolbarPresenter on: rgMethod.
	self layout: self defaultLayout.
	 
	messageList
		topologicSort: false;
		sortingBlock: [ :a | a annotationNamed: #versionIndex ifAbsent: [ 0 ] ] ascending;
		contextMenu: self messageListMenu.

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
				referencesList: self changeList) ].
		
	toolbarPresenter versionModel
		label: 'Revert';
		action: [ self revert: self selectedMessage ]
]

{ #category : #initialization }
VersionBrowser >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter title: 'Recent versions of ' , rgMethod displayName
]

{ #category : #private }
VersionBrowser >> installIconStylerFor: anItem [
	"icons styler are only supported for method definitions (not nil / not for comment definitions    
	 (those may occure for comment or general string searches)) and in the case the source presenter is not a diff"

	(self isMethodDefinition: anItem) ifFalse: [ ^ self ].

	IconStyler withStaticStylers 
		styleText: sourcePresenter 
		withAst: anItem ast
]

{ #category : #accessing }
VersionBrowser >> messageListMenu [

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

{ #category : #accessing }
VersionBrowser >> method [

	^ rgMethod
]

{ #category : #'private - factory' }
VersionBrowser >> newSourceDiff [

	^ self newDiff
]

{ #category : #'private - factory' }
VersionBrowser >> newTextConverter [

	^ DiffSideBySideChangeRecordConverter new
]

{ #category : #private }
VersionBrowser >> replaceSourceWith: aPresenter [
	
	sourceLayout children size = 1 
		ifTrue: [ 
			sourceLayout add: aPresenter ]
		ifFalse: [ 
			sourceLayout replace: sourcePresenter with: aPresenter ].
		
	sourcePresenter := aPresenter.
	messageList selectIndex: messageList selectedIndex
]

{ #category : #'private - factory' }
VersionBrowser >> revert: aChangeRecord [

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

{ #category : #private }
VersionBrowser >> selectItem: item [

	sourcePresenter ifNil: [ ^ self ].

	self setSourceContentWith: (self textConverter
		method: item;
		getText)
]

{ #category : #'accessing - model' }
VersionBrowser >> setModelBeforeInitialization: aMethod [

	self setRGMethodFrom: aMethod
]

{ #category : #initialization }
VersionBrowser >> setRGMethodFrom: aMethod [
"asHistorical, because active RGMethods don't always have the source pointer attached"

	rgMethod := aMethod asRingDefinition asHistorical
]

{ #category : #private }
VersionBrowser >> setSourceContentWith: content [

	self textConverter 
		updateContent: content 
		on: self
]

{ #category : #private }
VersionBrowser >> showDiffLineWithConverter: aConverter [
	| newSource |

	self textConverter: aConverter.

	newSource := self instantiate: SpPatchPresenter.
	newSource beForMethod: self selectedMessage.

	self replaceSourceWith: newSource

]

{ #category : #private }
VersionBrowser >> showDiffMorphWithConverter: aConverter [
	| newSource | 

	self textConverter: aConverter.

	newSource := self newDiff.
	newSource contextClass: self selectedMessage methodClass.
	self replaceSourceWith: newSource
]

{ #category : #private }
VersionBrowser >> showSourceWithConverter: aConverter [
	| newSource |

	self textConverter: aConverter.
	
	newSource := self newCode.
	newSource whenSubmitDo: [ :text | (self accept: text notifying: nil) notNil ].
	newSource beForMethod: self selectedMessage.

	self replaceSourceWith: newSource

]

{ #category : #'private - updating' }
VersionBrowser >> updateDiff: content [

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

{ #category : #'private - updating' }
VersionBrowser >> updateDiffLine: content [

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

{ #category : #'private - updating' }
VersionBrowser >> updateSource: content [ 

	sourcePresenter text: content
]
