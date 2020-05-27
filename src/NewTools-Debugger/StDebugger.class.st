"
A SpecDebugger is a UI build in Spec that provides Smalltalk debugging functionality by using a DebugSession.

All the debugging logic is in DebugSession and the corresponding debugging actions. SpecDebugger only provides a graphical interface to access that functionality. The debugging actions are managed by the toolbar widget; the stack and all its related actions are managed by the stack widget.

"
Class {
	#name : #StDebugger,
	#superclass : #StPresenter,
	#instVars : [
		'sessionHolder',
		'code',
		'toolbar',
		'stackTable',
		'inspector',
		'breakpointInspector',
		'stackHeader',
		'codeHeader',
		'extensionTools',
		'extensionToolsNotebook',
		'toolbarCommandGroup',
		'debuggerActionModel'
	],
	#classVars : [
		'ActivateDebuggerExtensions',
		'DefaultSpec',
		'ErrorRecursion',
		'ExtensionToolsSettings',
		'FilterCommonMessageSends',
		'LogDebuggerStackToFile',
		'UsingSpecSelector'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #accessing }
StDebugger class >> activateDebuggerExtensions [

	^ ActivateDebuggerExtensions ifNil: [ 
		ActivateDebuggerExtensions := true ]
]

{ #category : #accessing }
StDebugger class >> activateDebuggerExtensions: anObject [
	ActivateDebuggerExtensions := anObject
]

{ #category : #'tools registry' }
StDebugger class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."

	^ true
]

{ #category : #'tools registry' }
StDebugger class >> availableExtensionToolsClassesSettings [
	| settingToClass |
	settingToClass := Dictionary new.
	self collectExtendedToolsClasses
		do: [ :toolClass | 
			self extensionToolsSettings
				at: toolClass debuggingExtensionToolName
				ifPresent:
					[ :settings | settings do: [ :s | settingToClass at: s put: toolClass ] ] ].
	^ settingToClass 
]

{ #category : #specs }
StDebugger class >> availableSpecSelectors [
	^ (self class allSelectorsInProtocol: #specs )
		reject: [ :selector | selector = #defaultSpec ]
]

{ #category : #commands }
StDebugger class >> buildCommandsGroupWith: stDebuggerInstance forRoot: rootCommandGroup [
	StDebuggerStackCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup.
	StDebuggerToolbarCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup
]

{ #category : #utilities }
StDebugger class >> closeAllDebuggers [
	<script>
	StDebugger allInstancesDo: [ :dbg | dbg close ]
]

{ #category : #'tools registry' }
StDebugger class >> collectExtendedToolsClasses [
	^ self collectExtendedToolsClassesFor: self extendedToolsPragma
]

{ #category : #'tools registry' }
StDebugger class >> collectExtendedToolsClassesFor: pragmaSelector [
	^ (self collectExtendedToolsPragmaFor: pragmaSelector)
		collect: [ :prg | prg methodClass soleInstance ]
]

{ #category : #'tools registry' }
StDebugger class >> collectExtendedToolsPragmaFor: pragmaSelector [
	self flag: 'PragmaCollector might be changed in the near future?'.
	^ (PragmaCollector filter: [ :prg | prg selector = pragmaSelector ])
		reset collected
]

{ #category : #specs }
StDebugger class >> columnInspectorsSpec [
	"<spec: #default>"

	^ SpBoxLayout newVertical
		"position: 70 percent;"
		add: (SpPanedLayout newHorizontal
			position: 65 percent;
			add: (SpPanedLayout newVertical
				position: 40 percent;
				add: (SpBoxLayout newVertical 
					add: 'Stack' expand: false fill: false padding: 5;
					add: #stackTable;
					yourself);
				add: (SpBoxLayout newVertical 
					add: 'Source' expand: false fill: false padding: 5;
					add: #toolbar expand: false fill: false padding: 0;
					add: #code;
					yourself);
				yourself);
			"add: (SpPanedLayout newVertical 
				add: #contextInspector withConstraints: [ :c | c spec: #variablesListOnTop ];
				add: #inspector withConstraints: [ :c | c spec: #inspectorAlone ];
				yourself);"
			yourself);
		yourself
]

{ #category : #settings }
StDebugger class >> debuggerExtensionSettingsForClass: toolClass builder: aBuilder [
	| settings |
	settings := self extensionToolSettingsFor: toolClass.
	settings
		do: [ :s | 
			(aBuilder group: toolClass debuggingExtensionToolName asSymbol)
				label: toolClass debuggingExtensionToolName;
				with: [ (aBuilder setting: #showInDebugger)
						label: 'Show in debugger';
						target: s;
						description: 'Activate the tool tab in the debugger right column.'.
					(aBuilder pickOne: #displayOrder)
						label: 'Position';
						target: s;
						domainValues: (1 to: 100) asArray;
						description: 'Position of the tool tab in the debugger right column.' ] ]
]

{ #category : #settings }
StDebugger class >> debuggerExtensionSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder group: #debuggerExtensions)
		label: 'Debugger Extensions';
		parent: #debugging;
		description:
			'Tools that extend the StDebugger and appear in the right column of the debugger';
		with: [ | settingsGroup |
			settingsGroup := (aBuilder setting: #activateDebuggerExtensions)
				label: 'Activate extensions';
				target: self;
				default: true;
				description:
					'(De)Activate the debugger extensions tools in the debugger right column.'.
			self
				debuggerExtensionsSettingsOn: aBuilder
				parentGroup: settingsGroup ]
]

{ #category : #settings }
StDebugger class >> debuggerExtensionsSettingsOn: aBuilder parentGroup: settingsGroup [
	settingsGroup
		with: [ self collectExtendedToolsClasses
				do:
					[ :toolClass | self debuggerExtensionSettingsForClass: toolClass builder: aBuilder ] ]
]

{ #category : #specs }
StDebugger class >> debuggerHorizontalWithExtensionsSpec [
	^ SpPanedLayout newHorizontal
		add:
			(SpBoxLayout newVertical
				add: #stackTable
					withConstraints:
						[ :constraints | constraints height: self toolbarHeight * 10 ];
				add:
					(SpBoxLayout newVertical
						add: #toolbar;
						add: #codeHeader
							expand: true
							fill: true
							padding: 0;
						yourself)
					withConstraints:
						[ :constraints | constraints height: self toolbarHeight * 2 ];
				add: #code expand: true;
				yourself);
		add:
			(SpPanedLayout newVertical
				position: 60 percent;
				add: #inspector;
				add: #extensionToolsNotebook;
				yourself);
		yourself
]

{ #category : #settings }
StDebugger class >> debuggerLayoutSettingsOn: aBuilder [
	<systemsettings>
	(aBuilder pickOne: #usingSpecSelector)
		label: 'Default debugger spec layout';
		target: self;
		default: #debuggerHorizontalWithExtensionsSpec;
		parent: #debugging;
		domainValues: self availableSpecSelectors;
		description: 'Sets the default spec layout of the debugger.'
]

{ #category : #specs }
StDebugger class >> debuggerNoHeadersWithExtensionsSpec [
	^ SpPanedLayout newVertical
		position: 65 percent;
		add:
			(SpPanedLayout newHorizontal
				position: 65 percent;
				add:
					(SpPanedLayout newVertical
						position: 30 percent;
						add: #stackTable;
						add:
							(SpBoxLayout newVertical
								add:
									(SpBoxLayout newVertical
										add: #toolbar;
										yourself)
									withConstraints: [ :constraints | 
										constraints
											expand: false;
											height: self toolbarHeight + 10 ];
								add: #code;
								yourself);
						yourself);
				add: #extensionToolsNotebook;
				yourself);
		add: #inspector;
		yourself
]

{ #category : #specs }
StDebugger class >> debuggerWithExtensionsSpec [
	^ SpPanedLayout newVertical
		position: 65 percent;
		add:
			(SpPanedLayout newHorizontal
				position: 65 percent;
				add:
					(SpPanedLayout newVertical
						position: 30 percent;						
						add:
							(SpBoxLayout newVertical
								add: #stackHeader
									expand: false
									fill: false
									padding: 5;
								add: #stackTable;
								yourself);
						add:
							(SpBoxLayout newVertical
								add:
									(SpBoxLayout newVertical
										add: #toolbar;
										add: #codeHeader
											expand: true
											fill: true
											padding: 0;
										yourself)
									withConstraints: [ :constraints | 
										constraints
											expand: false;
											height: self toolbarHeight *2  ];
								add: #code;
								yourself);
						yourself);
				add: #extensionToolsNotebook;
				yourself);
		add: #inspector;
		yourself
]

{ #category : #specs }
StDebugger class >> debuggerWithoutExtensionsSpec [
	^ SpPanedLayout newVertical
		position: 65 percent;
		add:
			(SpPanedLayout newVertical
				position: 30 percent;				
				add:
					(SpBoxLayout newVertical
						add: #stackHeader
							expand: false
							fill: false
							padding: 5;
						add: #stackTable;
						yourself);
				add:
					(SpBoxLayout newVertical
						add:
							(SpBoxLayout newVertical
								add: #toolbar;
								add: #codeHeader
									expand: true
									fill: true
									padding: 0;
								yourself)
							withConstraints: [ :constraints | 
								constraints
									expand: false;
									height: self toolbarHeight * 2 ];
						add: #code;
						yourself);
				yourself);
		add: #inspector;
		yourself
]

{ #category : #specs }
StDebugger class >> defaultSpec [
	^ self perform: self usingSpecSelector
]

{ #category : #opening }
StDebugger class >> defaultTitle [
	"GTDebugger needs this to create its action to switch to other debuggers (in this case to the Spec Debugger). I don't know if switching to this debugger actually works, but if the action cannot be created, the GTDebugger crashes when being opened. This method can be removed if the GTDebugger is removed"
	self flag: 'Why constraining us because of GT?'.
	^ 'SpecDebugger'
]

{ #category : #settings }
StDebugger class >> displayInspectorHeaderBar [
	self flag: 'Temporary hack to disable header bars on inspectors'.
	^"(self usingSpecSelector = #debuggerNoHeadersWithExtensionsSpec) not"true
]

{ #category : #'tools registry' }
StDebugger class >> extendedToolsPragma [	

	^ #debuggerExtensionOrder:showByDefault:
]

{ #category : #'tools registry' }
StDebugger class >> extensionToolSettingsFor: aToolClass [
	^ self extensionToolsSettings
		at: aToolClass debuggingExtensionToolName
		ifAbsentPut:
			[ StDebuggerExtensionSetting fromDebuggerExtensionClass: aToolClass ]
]

{ #category : #'tools registry' }
StDebugger class >> extensionToolsSettings [
	^ExtensionToolsSettings ifNil:[ExtensionToolsSettings := Dictionary new]
]

{ #category : #settings }
StDebugger class >> filterCommonMessageSends [
	^ FilterCommonMessageSends ifNil: [FilterCommonMessageSends := false]
]

{ #category : #settings }
StDebugger class >> filterCommonMessageSends: aBoolean [
	FilterCommonMessageSends := aBoolean
]

{ #category : #'tools registry' }
StDebugger class >> handlesContext: aContext [

	^ true
]

{ #category : #'tools registry' }
StDebugger class >> hasAnyActivatedExtension [
	^ self activateDebuggerExtensions
		and: [ self extensionToolsSettings values
				anySatisfy:
					[ :toolSettings | toolSettings anySatisfy: [ :setting | setting showInDebugger ] ] ]
]

{ #category : #'debugger declaration' }
StDebugger class >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	"For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector"

	<iAmADebugger>
	self flag: 'I am not sure this is good design'
]

{ #category : #'class initialization' }
StDebugger class >> initialize [ 
	
	ErrorRecursion := false.

	"Ugly check to make sure the debugger will work until everything is in the image"
	(Smalltalk tools respondsTo: #registerDebugger:withRank:) ifFalse: [ ^ self ].

	"Add ourselves to registry. See [Smalltalk tools]" 
	Smalltalk tools registerDebugger: self withRank: self rank.
	
]

{ #category : #settings }
StDebugger class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #settings }
StDebugger class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #opening }
StDebugger class >> openOn: aDebugSession withFullView: aBool [
	
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
StDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger |
	debugger := self on: aDebugSession.
	debugger openWithFullView.
	^ debugger
]

{ #category : #'class initialization' }
StDebugger class >> rank [
	^ 80
]

{ #category : #'class initialization' }
StDebugger class >> rankDebugSession: aDebugSession [
	"Returns an integer representing how much this debugger is suitable to debug @aDebugSession. The higher the integer returned, the more suitable this debugger is. Signal the DebugSessionCannotBeOpenedByThisDebugger exception if this debugger absolutely cannot debug @aDebugSession (for example if this debugger can only handle debug sessions from test executions, and @aDebugSession does not come from a test execution)"
	"For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector"
	^ self rank.
]

{ #category : #'tools registry' }
StDebugger class >> register [
	self flag: 'Maybe this is no longer necessary now that we have DebuggerSelector?'.
	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
StDebugger class >> registerToolsOn: registry [
	self flag: 'Maybe this is no longer necessary now that we have DebuggerSelector?'.
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.

]

{ #category : #accessing }
StDebugger class >> sessionClass [
	self flag: 'Should be replaced by Sindarin - should even be removed in that case!'.
	^ DebugSession
]

{ #category : #specs }
StDebugger class >> singleInspectorSpec [
	"<spec: #default>"

	^ SpPanedLayout newVertical
		position: 55 percent;
		add: (SpPanedLayout newVertical
			position: 40 percent;
			add: #stackTable;
			add: (SpBoxLayout newVertical 
				add: #toolbar expand: false fill: false padding: 0;
				add: #code;
				yourself);
			yourself);
		add: #inspector;
		yourself
]

{ #category : #accessing }
StDebugger class >> spanNewSessionFrom: anotherSession [
	self flag: 'Where is that used? 2019-06-28'.
	^ anotherSession spanNewSession
]

{ #category : #icons }
StDebugger class >> taskbarIconName [

	^#smallDebugIcon
]

{ #category : #specs }
StDebugger class >> traditionalSpec [
	"<spec: #default>"

	^ SpPanedLayout newVertical
		position: 70 percent;
		add: (SpPanedLayout newVertical
			position: 40 percent;
			add: #stackTable;
			add: (SpBoxLayout newVertical 
				add: #toolbar expand: false fill: false padding: 0;
				add: #code;
				yourself);
			yourself);
		add: (SpPanedLayout newHorizontal
			add: #inspector;
			yourself);
		yourself
]

{ #category : #'specs - selectors' }
StDebugger class >> usingSpecSelector [
	^ (UsingSpecSelector
		ifNil: [ UsingSpecSelector := StDebuggerUsingSpecSelector defaultSelector ])
		selectSpecSelector
]

{ #category : #'specs - selectors' }
StDebugger class >> usingSpecSelector: aSelector [

	UsingSpecSelector := StDebuggerUsingSpecSelector on: aSelector
]

{ #category : #commands }
StDebugger >> buildContextMenus [
	| debuggerCommandGroup stackGroup |

	debuggerCommandGroup := self rootCommandsGroup.
	stackGroup := debuggerCommandGroup / StDebuggerStackCommandTreeBuilder groupName.
	stackTable contextMenu: [ stackGroup beRoot asMenuPresenter ].
	
	toolbarCommandGroup := debuggerCommandGroup / StDebuggerToolbarCommandTreeBuilder groupName.
	
	SpToolBarPresenterBuilder new
		toolbarPresenter: toolbar;
		visit: toolbarCommandGroup.
	
	self updateToolbarDebugActions
]

{ #category : #actions }
StDebugger >> clear [
	extensionToolsNotebook pages
		do: [ :page | page activePresenter windowIsClosing ].
	extensionTools := nil.
	self removeActionsForSession: self session.
	self session terminate
]

{ #category : #'updating widgets' }
StDebugger >> clearCode [
	
	self code
		clearInteractionModel;
		clearSelection;
		clearContent
]

{ #category : #actions }
StDebugger >> close [
	self withWindowDo: #close
]

{ #category : #'accessing widgets' }
StDebugger >> code [

	^ code
]

{ #category : #commands }
StDebugger >> codeContextMenuCommandsForRootGroup: aRootCmCommandsGroup [
	| group |
	group := (CmCommandGroup named: 'Debugger actions on code selection')
		asSpecGroup.
	group
		description: 'Debugger actions on code selection.';
		beDisplayedAsGroup.
	group register: (RunToSelectionDebugCommand forSpecContext: self).
	aRootCmCommandsGroup decoratedGroup registerFirst: group.
	self codeContextMenuExtensionsForParentGroup: aRootCmCommandsGroup.
	^ aRootCmCommandsGroup asMenuPresenter
]

{ #category : #commands }
StDebugger >> codeContextMenuExtensionsForParentGroup: aCmCommandsGroup [
	| extensionPragmas group |
	extensionPragmas := self class
		collectExtendedToolsPragmaFor: #codeExtensionDebugCommand:.
	group := (CmCommandGroup
		named: 'Debugger extended actions on code selection') asSpecGroup.
	group
		description: 'Debugger extended actions on code selection.';
		beDisplayedAsGroup.
	(extensionPragmas collect: [ :prg | prg methodClass soleInstance ])
		do: [ :extCmdClass | group register: (extCmdClass forSpecContext: self) ].
	aCmCommandsGroup decoratedGroup register: group
]

{ #category : #'accessing context' }
StDebugger >> context [
 
	^ self interruptedContext
]

{ #category : #'accessing context' }
StDebugger >> currentContext [
	"I answer the context on which an action should be executed.
	This is either the selected context or if nothing is selected the interrupted context."
	
	^ self selectedContext isNil 
		ifTrue: [ self interruptedContext ]
		ifFalse: [ self selectedContext ]
]

{ #category : #accessing }
StDebugger >> debuggerActionModel [
	^ debuggerActionModel
		ifNil: [ debuggerActionModel := StDebuggerActionModel on: self ]
]

{ #category : #stack }
StDebugger >> expandStackIfLastItemIsSelected [
	| selection |
	selection := stackTable selection.
	selection selectedItem == stackTable items last ifFalse: [ ^ self ].
	stackTable items: (self filterStack:
			 (self session stackOfSize: 2 * stackTable items size)).
	stackTable selectIndex: selection selectedIndex
]

{ #category : #extensions }
StDebugger >> extensionTools [
	^ extensionTools ifNil: [ extensionTools := OrderedCollection new ]
]

{ #category : #actions }
StDebugger >> fileOutSelectedContext [
	| selectedContextMethod |
	selectedContextMethod := stackTable selection selectedItem method.
	selectedContextMethod methodClass
		fileOutMethod: selectedContextMethod selector
]

{ #category : #stack }
StDebugger >> filterStack: aStack [
	^ aStack reject: [ :aContext | 
		  aContext method hasPragmaNamed: #debuggerCompleteToSender ]
]

{ #category : #stack }
StDebugger >> findFirstRelevantStackIndexIn: aStack [
	| counter |
	counter := 1.
	aStack do: [ :context | 
		context method methodClass == TestAsserter ifFalse: [ ^ counter ].
		counter := counter + 1 ].
	^ 1
]

{ #category : #'updating session' }
StDebugger >> forceSessionUpdate [
	self sessionHolder valueChanged
]

{ #category : #api }
StDebugger >> initialExtent [ 
	"This code was taken from the old debugger to get the same behavior. Fell free to refactor"
	self flag: 'Do it better'.
	"RealEstateAgent standardWindowExtent y < 400"true "a tiny screen" 
		ifTrue: [ ^ 1000@800 ].
	
	^ [ | w h |
		w := Display width.
		h := Display height.
		(w - (w // 3)) @ (h - (h // 5)) ]
		on: Error
		do: [ 850@650 ]
]

{ #category : #initialization }
StDebugger >> initialize [
	super initialize.
	self setSessionHolderSubscriptions.
	self forceSessionUpdate
]

{ #category : #initialization }
StDebugger >> initializeBreakpointInspector [
	breakpointInspector := self
		instantiate: StDebuggerBreakpointInspection
		on: (StInspectorModel on: nil).
]

{ #category : #initialization }
StDebugger >> initializeCode [
	self flag: 'Add metalink information in the gutter!'.
	
	code := self newCode.
	code whenSubmitDo: [ :text | 
		self
			recompileMethodTo: text string
			inContext: self stackTable selection selectedItem
			notifying: nil ].
	code whenResetDo: [ self updateCodeFromContext ].
	code contextMenu: [ self codeContextMenuCommandsForRootGroup: code rootCommandsGroup ].
			
	codeHeader := self instantiate: StHeaderBar.	
	codeHeader removeStyleFromLabel: 'label.header'.	
	codeHeader applyStyleToLabel: 'label.headerError'.
	codeHeader label: self session name
]

{ #category : #extensions }
StDebugger >> initializeExtensionTools [
	| settingsToClasses sortedSettings pages |
	extensionToolsNotebook := self newNotebook.
	self class hasAnyActivatedExtension
		ifFalse: [ ^ self ].
	settingsToClasses := self class
		availableExtensionToolsClassesSettings.
	sortedSettings := SortedCollection
		sortBlock: [ :s1 :s2 | s1 displayOrder <= s2 displayOrder ].
	sortedSettings addAll: settingsToClasses keys.
	sortedSettings := sortedSettings select: [ :s | s showInDebugger ].
	pages := sortedSettings
		collect: [ :s | self instantiateExtensionToolsPage: (settingsToClasses at: s) ].
	extensionToolsNotebook pages: pages
]

{ #category : #initialization }
StDebugger >> initializeInspector [
	inspector := self
		instantiate: StDebuggerInspector
		on: (StDebuggerInspectorModel on: nil).
	inspector label: 'Receiver'.
	self flag: 'Temporary hack to disable header bars on inspectors'.
	inspector displayHeaderBar: self class displayInspectorHeaderBar
]

{ #category : #initialization }
StDebugger >> initializePresenters [

	self initializeStack.
	self initializeToolbar.
	self initializeCode.
	self initializeInspector.
	self initializeExtensionTools
]

{ #category : #initialization }
StDebugger >> initializeStack [
	stackTable := self newTable.
	stackTable
		addColumn:
			(SpStringTableColumn
				title: 'Class'
				evaluated: [ :item | item receiver class ]);
		addColumn:
			(SpStringTableColumn
				title: 'Method'
				evaluated: [ :item | item method selector ]);
		addColumn:
			(SpStringTableColumn
				title: 'Context'
				evaluated: [ :item | item sender stDisplayString ]).
	stackTable
		transmitDo: [ :context | 
			stackTable selection isEmpty
				ifFalse: [ self updateInspectorFromContext: context.
					self updateCodeFromContext: context.
					self updateTitle.
					self expandStackIfLastItemIsSelected ] ].
	stackHeader := self instantiate: StHeaderBar.
	stackHeader label: 'Stack'
]

{ #category : #initialization }
StDebugger >> initializeToolbar [
	toolbar := self newToolBar.
	toolbar displayMode: self application toolbarDisplayMode
]

{ #category : #initialization }
StDebugger >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter 
		title: self title;
		initialExtent: self initialExtent;
		whenClosedDo: [ self clear ]
]

{ #category : #extensions }
StDebugger >> instantiateExtensionToolsPage: aToolClass [
	| toolInstance |
	toolInstance := self instantiate: aToolClass on: self.
	self registerExtensionTool: toolInstance.
	^ SpNotebookPage
		title: aToolClass debuggingExtensionToolName
		provider: [ toolInstance ]
]

{ #category : #'accessing context' }
StDebugger >> interruptedContext [

	^ self session interruptedContext
]

{ #category : #accessing }
StDebugger >> interruptedProcess [

	^ self session interruptedProcess
]

{ #category : #api }
StDebugger >> okToChange [

	self code canDiscardEdits
		ifTrue: [ ^ true ].
	self code changed: #wantToChange.
	^ self code canDiscardEdits
]

{ #category : #opening }
StDebugger >> openWithFullView [
	"Create and schedule a full debugger with the given label. Do not
	terminate the current active process."

	self
		openWithSpec;
		buildContextMenus;
		updateCodeFromContext
]

{ #category : #opening }
StDebugger >> openWithNotification: notificationString [
	self openWithFullView
]

{ #category : #actions }
StDebugger >> proceedDebugSession [ 
	self debuggerActionModel proceedDebugSession.
	self close
]

{ #category : #actions }
StDebugger >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	^ aContext 
		ifNil: [ false ]
		ifNotNil: [
			self session recompileMethodTo: aString inContext: aContext notifying: aNotifyer ]
]

{ #category : #'updating session' }
StDebugger >> registerActionsForSession: aSession [
	self flag: 'Rewrite it'.
	aSession
		ifNotNil: [ aSession
				when: #restart send: #updateRestart to: self;
				when: #resume send: #updateResume to: self;
				when: #stepInto send: #updateStepInto to: self;
				when: #stepOver send: #updateStepOver to: self;
				when: #stepThrough send: #updateStepThrough to: self;
				when: #contextChanged send: #updateContextChanged to: self ]
]

{ #category : #extensions }
StDebugger >> registerExtensionTool: anExtension [
	self extensionTools add: anExtension
]

{ #category : #'updating session' }
StDebugger >> removeActionsForSession: aSession [
	self flag: 'Rewrite it'.
	aSession
		ifNotNil: [ aSession
				removeActionsForEvent: #restart;
				removeActionsForEvent: #resume;
				removeActionsForEvent: #stepInto;
				removeActionsForEvent: #stepOver;
				removeActionsForEvent: #stepThrough;
				removeActionsForEvent: #contextChanged ]
]

{ #category : #'updating session' }
StDebugger >> removeSessionHolderSubscriptions [
	self sessionHolder announcer unsubscribe: self sessionHolder.
	self removeActionsForSession: self session
]

{ #category : #actions }
StDebugger >> restartCurrentContext [
	self debuggerActionModel restartContext: self currentContext
]

{ #category : #actions }
StDebugger >> returnEnteredValue [
	| expression value |
	expression := UIManager default
		request: 'Enter expression for return value:'.
	value := self class compiler
		source: expression;
		context: self currentContext;
		receiver: self currentContext receiver;
		evaluate.
	self session returnValue: value from: self currentContext
]

{ #category : #stack }
StDebugger >> selectTopContext [
	stackTable selectIndex: 1
]

{ #category : #'accessing context' }
StDebugger >> selectedContext [

	^ self stackTable selection selectedItem
]

{ #category : #accessing }
StDebugger >> session [
	^ self sessionHolder value
]

{ #category : #accessing }
StDebugger >> session: aSession [
	self sessionHolder value: aSession
]

{ #category : #accessing }
StDebugger >> sessionHolder [
	^ sessionHolder ifNil: [ sessionHolder := nil asValueHolder ]
]

{ #category : #initialization }
StDebugger >> setModelBeforeInitialization: aSession [

	self session: aSession
]

{ #category : #'updating session' }
StDebugger >> setSessionHolderSubscriptions [
	self sessionHolder
		whenChangedDo: [ :newSession :oldSession | 
			self removeActionsForSession: oldSession.
			self registerActionsForSession: newSession.
			self updateStackFromSession: newSession.
			self updateTitle.
			self updateExtensionsFrom: newSession ]
]

{ #category : #stack }
StDebugger >> showFullStack [
	stackTable items: (self filterStack: self session stack)

]

{ #category : #commands }
StDebugger >> stackSelectionMethodContext [
	^ [ stackTable selection selectedItem method ]
]

{ #category : #commands }
StDebugger >> stackSelectionMethodSelectorContext [
	^[ stackTable selection selectedItem method selector ]
]

{ #category : #commands }
StDebugger >> stackSelectionReceiverClassContext [
	^ [ stackTable selection selectedItem receiver class ]
]

{ #category : #commands }
StDebugger >> stackSelectionReceiverContext [
	^ [ stackTable selection selectedItem receiver ]
]

{ #category : #'accessing widgets' }
StDebugger >> stackTable [
	^stackTable
]

{ #category : #'accessing context' }
StDebugger >> statusLabelStyleForCurrentContext [
	self flag: 'deprecated?'.
"true ifTrue: [ ^ 'label.headerError' ]."
	(self context tempNames includes: #exception) ifTrue: [ 
		(self context tempNamed: #exception) ifNotNil: [ :ex | 
			^ 'label.headerError' ] ].
	self context currentNode isHaltNode ifTrue: [ ^ 'label.headerError' ].
	^ 'label.header'
]

{ #category : #'accessing context' }
StDebugger >> statusLabelTextForCurrentContext [
	self flag: 'deprecated?'.
	(self context tempNames includes: #exception)
		ifTrue: [ (self context tempNamed: #exception)
				ifNotNil: [ :ex | ^ ex description ] ].
	^ self context currentNode isHaltNode
		ifTrue: [ 'Halt' ]
		ifFalse:
			[ self context receiver class name , '>>' , self context selector ]
]

{ #category : #api }
StDebugger >> title [
	^ ((self session isContextPostMortem: self interruptedContext)
		ifTrue: [ '[PostMortem] ' ]
		ifFalse: [ '' ]) , self titlePrefixTextForCurrentContext, self currentContext asString
]

{ #category : #'accessing context' }
StDebugger >> titlePrefixTextForCurrentContext [
	((self context tempNames includes: #exception)
		and: [ self context sender == self currentContext ])
		ifTrue: [ (self context tempNamed: #exception)
				ifNotNil: [ :ex | ^ ex description , ' in ' ] ].
	^ self currentContext currentNode isHaltNode
		ifTrue: [ 'Halt in ' ]
		ifFalse: [ '' ]
]

{ #category : #'accessing widgets' }
StDebugger >> toolbar [

	^ toolbar
]

{ #category : #'updating widgets' }
StDebugger >> updateCodeFromContext [

	self updateCodeFromContext: self currentContext
]

{ #category : #'updating widgets' }
StDebugger >> updateCodeFromContext: aContext [
	| selectionInterval |

	aContext ifNil: [ ^ self clearCode ].

	selectionInterval := self session selectedCodeRangeForContext: aContext.
	aContext sourceCode = self code text 
		ifFalse: [ self code text: aContext sourceCode ].
	self code beForContext: aContext.
	self code selectionInterval: selectionInterval.
	
	self flag: #DBG, 'the following leaves highlighted text everywhere when the code pane is not updated.'
	"self
		updateCodeTextSegmentDecoratorsIn: aContext
		forInterval: selectionInterval."
	
]

{ #category : #'updating widgets' }
StDebugger >> updateCodeHeaderLabel [
	codeHeader label: self statusLabelTextForCurrentContext
]

{ #category : #'updating widgets' }
StDebugger >> updateCodeTextSegmentDecoratorsIn: aContext forInterval: selectionInterval [
	self code removeAllTextSegmentDecorations.
	
	"This decorates the receiver and the next node with an underline"
	self code
		addTextSegmentDecoration:
			(SpTextPresenterDecorator new
				underlineColor: Color orange;
				interval: (aContext currentNode start to: aContext currentNode stop + 1);
				yourself).
				
	"This decorates the next executing node"
	self code
		addTextSegmentDecoration:
			(SpTextPresenterDecorator new
				highlightColor: (Color orange alpha: 0.5);
				underlineColor: (Color white alpha: 0);
				interval: (selectionInterval first to: selectionInterval last + 1);
				yourself).
				
			"	icon: (self iconNamed: #warning);
				iconBlock: [ :n | n inspect ];
				title: 'Click me!';"
]

{ #category : #'updating actions' }
StDebugger >> updateContextChanged [
	self updateStep
]

{ #category : #'updating widgets' }
StDebugger >> updateExtensionsFrom: newSession [
	self extensionTools do:[:tool| tool updatePresenter]
]

{ #category : #'updating widgets' }
StDebugger >> updateInspectorFromContext: aContext [
	
	inspector
		updateWith:
			(StDebuggerContext
				context: aContext
				session: self session
				debugger: self)
]

{ #category : #'updating actions' }
StDebugger >> updateRestart [
	self updateStep
]

{ #category : #'updating actions' }
StDebugger >> updateResume [

	
]

{ #category : #stack }
StDebugger >> updateStackFromSession: aSession [
	|stack|
	stack := (self filterStack: aSession shortStack).
	stackTable items: stack.
	stackTable selectIndex: (self findFirstRelevantStackIndexIn: stack)
]

{ #category : #'updating actions' }
StDebugger >> updateStep [
	self updateStackFromSession: self session.
	self updateCodeHeaderLabel.
	self updateExtensionsFrom: self session.
	self updateTitle.
	self updateToolbarDebugActions.
]

{ #category : #'updating actions' }
StDebugger >> updateStepInto [
	self updateStep
]

{ #category : #'updating actions' }
StDebugger >> updateStepOver [

	self updateStep 
	
]

{ #category : #'updating actions' }
StDebugger >> updateStepThrough [

	self updateStep 
]

{ #category : #'updating widgets' }
StDebugger >> updateTitle [
	self withWindowDo: [ :window | window title: self title]
]

{ #category : #'updating widgets' }
StDebugger >> updateToolbarDebugActions [
	
	toolbarCommandGroup allCommands
		do: [ :spCommand | spCommand updateEnableStatus ]
]
