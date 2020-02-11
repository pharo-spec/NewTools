"
A SpecDebugger is a UI build in Spec that provides Smalltalk debugging functionality by using a DebugSession.

All the debugging logic is in DebugSession and the corresponding debugging actions. SpecDebugger only provides a graphical interface to access that functionality. The debugging actions are managed by the toolbar widget; the stack and all its related actions are managed by the stack widget.

"
Class {
	#name : #SpecDebugger,
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
		'extensionToolsNotebook'
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
SpecDebugger class >> activateDebuggerExtensions [

	^ ActivateDebuggerExtensions ifNil: [ 
		ActivateDebuggerExtensions := true ]
]

{ #category : #accessing }
SpecDebugger class >> activateDebuggerExtensions: anObject [
	ActivateDebuggerExtensions := anObject
]

{ #category : #'tools registry' }
SpecDebugger class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."

	^ true
]

{ #category : #'tools registry' }
SpecDebugger class >> availableExtentionToolsClassesSettings [
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

{ #category : #utilities }
SpecDebugger class >> closeAllDebuggers [
	<script>
	SpecDebugger allInstancesDo: [ :dbg | dbg close ].
	SpecPreDebugPresenter allInstancesDo: [ :dbg | dbg close ]
]

{ #category : #'tools registry' }
SpecDebugger class >> collectExtendedToolsClasses [
	^ self collectExtendedToolsClassesFor: self extendedToolsPragma
]

{ #category : #'tools registry' }
SpecDebugger class >> collectExtendedToolsClassesFor: pragmaSelector [
	^ (self collectExtendedToolsPragmaFor: pragmaSelector)
		collect: [ :prg | prg methodClass soleInstance ]
]

{ #category : #'tools registry' }
SpecDebugger class >> collectExtendedToolsPragmaFor: pragmaSelector [
	^ (PragmaCollector filter: [ :prg | prg selector = pragmaSelector ])
		reset collected
]

{ #category : #specs }
SpecDebugger class >> columnInspectorsSpec [
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
SpecDebugger class >> debuggerExtensionSettingsForClass: toolClass builder: aBuilder [
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
SpecDebugger class >> debuggerExtensionSettingsOn: aBuilder [
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
SpecDebugger class >> debuggerExtensionsSettingsOn: aBuilder parentGroup: settingsGroup [
	settingsGroup
		with: [ self collectExtendedToolsClasses
				do:
					[ :toolClass | self debuggerExtensionSettingsForClass: toolClass builder: aBuilder ] ]
]

{ #category : #specs }
SpecDebugger class >> debuggerWithExtensionsSpec [
	^ SpPanedLayout newVertical
		  position: 70 percent;
		  add: (SpPanedLayout newHorizontal
				   position: 65 percent;
				   add: (SpPanedLayout newVertical
						    position: 40 percent;
						    add: (SpBoxLayout newVertical
								     add: #stackHeader
								     expand: false
								     fill: false
								     padding: 5;
								     add: #stackTable;
								     yourself);
						    add: (SpBoxLayout newVertical
								     add: (SpBoxLayout newVertical
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
				   add: #extensionToolsNotebook;
				   yourself);
		  add: #inspector;
		  yourself
]

{ #category : #specs }
SpecDebugger class >> debuggerWithoutExtensionsSpec [
	^ SpPanedLayout newVertical
		position: 70 percent;
		add:
			(SpPanedLayout newVertical
				position: 40 percent;
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
SpecDebugger class >> defaultSpec [
	^ self perform: self usingSpecSelector
]

{ #category : #opening }
SpecDebugger class >> defaultTitle [
	"GTDebugger needs this to create its action to switch to other debuggers (in this case to the Spec Debugger). I don't know if switching to this debugger actually works, but if the action cannot be created, the GTDebugger crashes when being opened. This method can be removed if the GTDebugger is removed"
	self flag: 'Why constraining us because of GT?'.
	^ 'SpecDebugger'
]

{ #category : #'tools registry' }
SpecDebugger class >> extendedToolsPragma [	

	^ #debuggerExtensionOrder:showByDefault:
]

{ #category : #'tools registry' }
SpecDebugger class >> extensionToolSettingsFor: aToolClass [
	^ self extensionToolsSettings
		at: aToolClass debuggingExtensionToolName
		ifAbsentPut:
			[ StDebuggerExtensionSetting fromDebuggerExtensionClass: aToolClass ]
]

{ #category : #'tools registry' }
SpecDebugger class >> extensionToolsSettings [
	^ExtensionToolsSettings ifNil:[ExtensionToolsSettings := Dictionary new]
]

{ #category : #settings }
SpecDebugger class >> filterCommonMessageSends [
	^ FilterCommonMessageSends ifNil: [FilterCommonMessageSends := false]
]

{ #category : #settings }
SpecDebugger class >> filterCommonMessageSends: aBoolean [
	FilterCommonMessageSends := aBoolean
]

{ #category : #'tools registry' }
SpecDebugger class >> handlesContext: aContext [

	^ true
]

{ #category : #'tools registry' }
SpecDebugger class >> hasAnyActivatedExtension [
	^ self activateDebuggerExtensions
		and: [ self extensionToolsSettings values
				anySatisfy:
					[ :toolSettings | toolSettings anySatisfy: [ :setting | setting showInDebugger ] ] ]
]

{ #category : #'debugger declaration' }
SpecDebugger class >> iAmADebugger [
	"Leave blank for intermediate classes. Add the <iAmADebugger> pragma for concrete debugger classes. This pragma is used by the system to find all available debuggers"

	"For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector"

	<iAmADebugger>
	self flag: 'I am not sure this is good design'
]

{ #category : #'class initialization' }
SpecDebugger class >> initialize [ 
	
	ErrorRecursion := false.

	"Ugly check to make sure the debugger will work until everything is in the image"
	(Smalltalk tools respondsTo: #registerDebugger:withRank:) ifFalse: [ ^ self ].

	"Add ourselves to registry. See [Smalltalk tools]" 
	Smalltalk tools registerDebugger: self withRank: self rank.
	
]

{ #category : #settings }
SpecDebugger class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #settings }
SpecDebugger class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #opening }
SpecDebugger class >> openOn: aDebugSession withFullView: aBool [
	
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
SpecDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger |
	debugger := self on: aDebugSession.
	[aDebugSession keepAlive: debugger] on: MessageNotUnderstood do: [ ]. "For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector
	The on:do: can be removed once DebuggerSelector is integrated into the image, so that DebugSession has the #keepAlive: method"
	debugger openWithFullView.
	^ debugger
]

{ #category : #'class initialization' }
SpecDebugger class >> rank [
	^ 80
]

{ #category : #'class initialization' }
SpecDebugger class >> rankDebugSession: aDebugSession [
	"Returns an integer representing how much this debugger is suitable to debug @aDebugSession. The higher the integer returned, the more suitable this debugger is. Signal the DebugSessionCannotBeOpenedByThisDebugger exception if this debugger absolutely cannot debug @aDebugSession (for example if this debugger can only handle debug sessions from test executions, and @aDebugSession does not come from a test execution)"
	"For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector"
	^ self rank.
]

{ #category : #'tools registry' }
SpecDebugger class >> register [
	self flag: 'Maybe this is no longer necessary now that we have DebuggerSelector?'.
	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
SpecDebugger class >> registerToolsOn: registry [
	self flag: 'Maybe this is no longer necessary now that we have DebuggerSelector?'.
	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.

]

{ #category : #accessing }
SpecDebugger class >> sessionClass [
	self flag: 'Should be replaced by Sindarin - should even be removed in that case!'.
	^ DebugSession
]

{ #category : #specs }
SpecDebugger class >> singleInspectorSpec [
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
SpecDebugger class >> spanNewSessionFrom: anotherSession [
	self flag: 'Where is that used? 2019-06-28'.
	^ (self sessionClass 
		named: anotherSession name 
		on: anotherSession interruptedProcess 
		startedAt: anotherSession interruptedContext)
			errorWasInUIProcess: anotherSession errorWasInUIProcess;
			yourself
]

{ #category : #icons }
SpecDebugger class >> taskbarIconName [

	^#smallDebugIcon
]

{ #category : #specs }
SpecDebugger class >> traditionalSpec [
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
SpecDebugger class >> useSpecSelector: aSelector [

	UsingSpecSelector := StDebuggerUsingSpecSelector on: aSelector
]

{ #category : #'specs - selectors' }
SpecDebugger class >> usingSpecSelector [
	^ (UsingSpecSelector
		ifNil: [ UsingSpecSelector := StDebuggerUsingSpecSelector defaultSelector ])
		selectSpecSelector
]

{ #category : #accessing }
SpecDebugger >> application [
	^ self class currentApplication
]

{ #category : #actions }
SpecDebugger >> clear [
	extensionToolsNotebook pages do:[:page| page activePresenter windowIsClosing].
	extensionTools := nil.
	self removeActionsForSession: self session.
	
	"No more code should follow after this, as the session might terminate this process."
	[self session stopKeepingAlive: self] on: MessageNotUnderstood do: [ self session terminate ] "For compatibility with DebuggerSelector https://github.com/dupriezt/DebuggerSelector
	If DebugSelector is in the image (i.e. the debug session understands the #stopKeepingAlive: message), it is responsible for terminating debug sessions, so we just let it do it. If DebugSelector is not in the image (handler block), then we terminate the debug session ourselves"
]

{ #category : #'updating widgets' }
SpecDebugger >> clearCode [
	
	self code
		text: '';
		behavior: nil;
		setSelection: (1 to: 0)
]

{ #category : #actions }
SpecDebugger >> close [
	self withWindowDo: #close
]

{ #category : #'accessing widgets' }
SpecDebugger >> code [

	^ code
]

{ #category : #commands }
SpecDebugger >> codeContextMenuCommandsForRootGroup: aRootCmCommandsGroup [
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
SpecDebugger >> codeContextMenuExtensionsForParentGroup: aCmCommandsGroup [
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
SpecDebugger >> context [
 
	^ self interruptedContext
]

{ #category : #'accessing context' }
SpecDebugger >> currentContext [
	"I answer the context on which an action should be executed.
	This is either the selected context or if nothing is selected the interrupted context."
	
	^ self selectedContext isNil 
		ifTrue: [ self interruptedContext ]
		ifFalse: [ self selectedContext ]
]

{ #category : #stack }
SpecDebugger >> expandStackIfLastItemIsSelected [
	| selection |
	selection := stackTable selection.
	selection selectedItem == stackTable items last ifFalse: [ ^ self ].
	stackTable items: (self filterStack:
			 (self session stackOfSize: 2 * stackTable items size)).
	stackTable selectIndex: selection selectedIndex
]

{ #category : #extensions }
SpecDebugger >> extensionTools [
	^ extensionTools ifNil: [ extensionTools := OrderedCollection new ]
]

{ #category : #actions }
SpecDebugger >> fileOutSelectedContext [
	| selectedContextMethod |
	selectedContextMethod := stackTable selection selectedItem method.
	selectedContextMethod methodClass
		fileOutMethod: selectedContextMethod selector
]

{ #category : #stack }
SpecDebugger >> filterStack: aStack [
	^ aStack reject: [ :aContext | 
		  aContext method hasPragmaNamed: #debuggerCompleteToSender ]
]

{ #category : #stack }
SpecDebugger >> findFirstRelevantStackIndexIn: aStack [
	| counter |
	counter := 1.
	aStack do: [ :context | 
		context method methodClass == TestAsserter ifFalse: [ ^ counter ].
		counter := counter + 1 ].
	^ 1
]

{ #category : #'updating session' }
SpecDebugger >> forceSessionUpdate [
	self sessionHolder valueChanged
]

{ #category : #api }
SpecDebugger >> initialExtent [ 
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
SpecDebugger >> initialize [
	super initialize.	
	self setSessionHolderSubscriptions.
	self forceSessionUpdate
]

{ #category : #initialization }
SpecDebugger >> initializeBreakpointInspector [
	breakpointInspector := self
		instantiate: StDebuggerBreakpointInspection
		on: (StInspectorModel on: nil).
]

{ #category : #initialization }
SpecDebugger >> initializeCode [
	self flag: 'Add metalink information in the gutter!'.
	code := self newCode.
	code acceptBlock: [ :text :notifyer | 
		self
			recompileMethodTo: text string
			inContext: self stackTable selection selectedItem
			notifying: notifyer ].
	code contextMenu: [self codeContextMenuCommandsForRootGroup: code rootCommandsGroup].
			
	codeHeader := self instantiate: StHeaderBar.	
	codeHeader removeStyleFromLabel: 'label.header'.	
	codeHeader applyStyleToLabel: 'label.headerError'.
	codeHeader label: self session name
	

]

{ #category : #extensions }
SpecDebugger >> initializeExtensionTools [
	| settingsToClasses sortedSettings pages |
	extensionToolsNotebook := self newNotebook.
	self class hasAnyActivatedExtension
		ifFalse: [ ^ self ].
	settingsToClasses := self class
		availableExtentionToolsClassesSettings.
	sortedSettings := SortedCollection
		sortBlock: [ :s1 :s2 | s1 displayOrder <= s2 displayOrder ].
	sortedSettings addAll: settingsToClasses keys.
	sortedSettings := sortedSettings select: [ :s | s showInDebugger ].
	pages := sortedSettings
		collect: [ :s | self instantiateExtensionToolsPage: (settingsToClasses at: s) ].
	extensionToolsNotebook pages: pages
]

{ #category : #initialization }
SpecDebugger >> initializeInspector [
	inspector := self
		instantiate: StDebuggerInspector
		on: (StDebuggerInspectorModel on: nil).
	inspector label: 'Receiver'
]

{ #category : #initialization }
SpecDebugger >> initializePresenters [

	self initializeStack.
	self initializeToolbar.
	self initializeCode.
	self initializeInspector.
	self initializeExtensionTools
]

{ #category : #initialization }
SpecDebugger >> initializeStack [

	stackTable := self newTable.
	stackTable 
		addColumn: (SpStringTableColumn
			title: 'Class'
			evaluated: [ :item | item receiver class ]);
		addColumn: (SpStringTableColumn
			title: 'Method'
			evaluated: [ :item | item method selector ]);
		addColumn: (SpStringTableColumn
			title: 'Context'
			evaluated: [ :item | item sender stDisplayString ]).
	
	stackTable contextMenu: [ 
		(self stackContextMenuCommandsForRootGroup: stackTable rootCommandsGroup)  ].
	
	stackTable transmitDo: [ :context | 
		self updateInspectorFromContext: context.
		self updateCodeFromContext: context.
		self updateToolbar.
		self updateTitle.
		self expandStackIfLastItemIsSelected  ].
	
	stackHeader := self instantiate: StHeaderBar.
	stackHeader label: 'Stack'.
]

{ #category : #initialization }
SpecDebugger >> initializeToolbar [

	toolbar := self newToolBar.
	toolbar displayMode: self application toolbarDisplayMode.
	self updateToolbar
]

{ #category : #initialization }
SpecDebugger >> initializeWindow: aWindowPresenter [

	aWindowPresenter 
		title: self title;
		initialExtent: self initialExtent;
		 whenClosedDo: [ self clear ]
]

{ #category : #extensions }
SpecDebugger >> instantiateExtensionToolsPage: aToolClass [
	| toolInstance |
	toolInstance := self instantiate: aToolClass on: self.
	self registerExtensionTool: toolInstance.
	^ SpNotebookPage
		title: aToolClass debuggingExtensionToolName
		provider: [ toolInstance ]
]

{ #category : #'accessing context' }
SpecDebugger >> interruptedContext [

	^ self session interruptedContext
]

{ #category : #accessing }
SpecDebugger >> interruptedProcess [

	^ self session interruptedProcess
]

{ #category : #commands }
SpecDebugger >> navigationCommand: aCommandClass forContext: anObject [
	| cmd |
	cmd := aCommandClass forSpecContext: anObject.
	cmd name: aCommandClass shortName.
	^ cmd
]

{ #category : #api }
SpecDebugger >> okToChange [

	self code canDiscardEdits
		ifTrue: [ ^ true ].
	self code changed: #wantToChange.
	^ self code canDiscardEdits
]

{ #category : #opening }
SpecDebugger >> openWithFullView [
	"Create and schedule a full debugger with the given label. Do not
	terminate the current active process."
	self 
		openWithSpec;
		updateToolbar;
		updateCodeFromContext
]

{ #category : #opening }
SpecDebugger >> openWithNotification: notificationString [
	"Create and schedule a notifier view with the given label and message.
	A notifier view shows just the message or the first several lines of the
	stack, with a menu that allows the user to open a full debugger if so
	desired. "

	"NOTE: When this method returns, a new process has been scheduled to
	run the windows, and thus this notifier, but the previous active porcess
	has not been suspended. The sender will do this."

	(SpecPreDebugPresenter on: self)
		message: notificationString;
		openWithSpec;
		setTitle: self title
]

{ #category : #actions }
SpecDebugger >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	^ aContext 
		ifNil: [ false ]
		ifNotNil: [
			self session recompileMethodTo: aString inContext: aContext notifying: aNotifyer ]
]

{ #category : #'updating session' }
SpecDebugger >> registerActionsForSession: aSession [
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
SpecDebugger >> registerExtensionTool: anExtension [
	self extensionTools add: anExtension
]

{ #category : #'updating session' }
SpecDebugger >> removeActionsForSession: aSession [
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
SpecDebugger >> removeSessionHolderSubscriptions [
	self sessionHolder announcer unsubscribe: self sessionHolder.
	self removeActionsForSession: self session
]

{ #category : #actions }
SpecDebugger >> returnEnteredValue [
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
SpecDebugger >> selectTopContext [
	stackTable selectIndex: 1
]

{ #category : #'accessing context' }
SpecDebugger >> selectedContext [

	^ self stackTable selection selectedItem
]

{ #category : #accessing }
SpecDebugger >> session [
	^ self sessionHolder value
]

{ #category : #accessing }
SpecDebugger >> session: aSession [
	self sessionHolder value: aSession
]

{ #category : #accessing }
SpecDebugger >> sessionHolder [
	^ sessionHolder ifNil: [ sessionHolder := nil asValueHolder ]
]

{ #category : #initialization }
SpecDebugger >> setModelBeforeInitialization: aSession [

	self session: aSession
]

{ #category : #'updating session' }
SpecDebugger >> setSessionHolderSubscriptions [
	self sessionHolder
		whenChangedDo: [ :newSession :oldSession | 
			self removeActionsForSession: oldSession.
			self registerActionsForSession: newSession.
			self updateToolbar.
			self updateStackFromSession: newSession.
			self updateTitle.
			self updateExtensionsFrom: newSession ]
]

{ #category : #stack }
SpecDebugger >> showFullStack [
	stackTable items: (self filterStack: self session stack)

]

{ #category : #commands }
SpecDebugger >> stackContextMenuActionsCommands [
	| group |
	group := (CmCommandGroup named: 'Context Actions') asSpecGroup.
	group beDisplayedAsGroup.
	group description: 'Actions on the selected context.'.
	group iconName: #smallDoIt.
	(StDebugCommand stackContextMenuActionsCommandsForDebugger: self)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #commands }
SpecDebugger >> stackContextMenuCommandsForRootGroup: aRootCmCommandsGroup [
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuActionsCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuNavigationCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuExplorationCommands.
	aRootCmCommandsGroup decoratedGroup register: self stackContextMenuStackEditionsCommands.
	^ aRootCmCommandsGroup asMenuPresenter
]

{ #category : #commands }
SpecDebugger >> stackContextMenuExplorationCommands [
	| group |
	group := (CmCommandGroup named: 'Explore') asSpecGroup.
	group description: 'Explore the receiver object''s graph.'.
	group iconName: SpSystemDiscoveryCommand defaultIconName.
	
	group register: (self navigationCommand: SpBrowseInstancesCommand forContext: [stackTable selection selectedItem receiver class]).
	group register: (self navigationCommand: SpBrowseSubInstancesCommand forContext: [stackTable selection selectedItem receiver class]).
	group register: (self navigationCommand: SpBrowsePointersToCommand forContext: [stackTable selection selectedItem receiver]).
	^ group
]

{ #category : #commands }
SpecDebugger >> stackContextMenuNavigationCommands [
	| group |
	group := (CmCommandGroup named: 'Browse') asSpecGroup.
	group description: 'Navigate the system from the stack.'.
	group iconName: #smallSystemBrowser.
	group register: self stackContextNavigationCommands.
	group register: self stackMethodNavigationCommands.
	group register: self stackMethodSelectorNavigationCommands.
	group register: self stackReceiverClassNavigationCommands.
	^ group
]

{ #category : #commands }
SpecDebugger >> stackContextMenuStackEditionsCommands [
	| group |
	group := (CmCommandGroup named: 'Stack') asSpecGroup.
	group description: 'Stack edition.'.
	group iconName: #edit.
	(StDebugCommand stackContextMenuEditionCommandsForDebugger: self)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #commands }
SpecDebugger >> stackContextNavigationCommands [
	"Commands to navigate the context"
	
	| group |
	group := (CmCommandGroup named: 'Receiver class code navigation commands') asSpecGroup.
	group beDisplayedAsGroup.
	group
		register:
			((SpBrowseClassCommand
				forSpecContext: [ stackTable selection selectedItem method ])
				name: 'method';
				shortcutKey: nil;
				yourself).
	group
		register:
			((SpBrowseClassCommand
				forSpecContext: [ stackTable selection selectedItem receiver class])
				name: 'receiver';
				shortcutKey: nil;
				yourself).				
	
	^ group
]

{ #category : #commands }
SpecDebugger >> stackMethodNavigationCommands [
	"Commands to navigate the selected context's method "
	
	| group |
	group := (CmCommandGroup named: 'Selected method navigation commands') asSpecGroup.
	group beDisplayedAsGroup.		
	{ 
		SpBrowseMethodInheritanceCommand.
		SpBrowseMethodVersionsCommand.		
	 } do:[:navCmdClass| 	
			group register: 
				(self navigationCommand: navCmdClass forContext: [ stackTable selection selectedItem method ] )].		
	^ group
]

{ #category : #commands }
SpecDebugger >> stackMethodSelectorNavigationCommands [
	"Commands to navigate the selected context's method selector as context "
	
	| group |
	group := (CmCommandGroup named: 'Selected method''s selector navigation commands') asSpecGroup.
	group beDisplayedAsGroup.		
	{ 
		SpBrowseImplementorsCommand.
		SpBrowseSendersCommand.
		SpBrowseMethodReferencesCommand.		
	 } do:[:navCmdClass| 	
			group register: 
				(self navigationCommand: navCmdClass forContext: [ stackTable selection selectedItem method selector ] )].
	^ group
]

{ #category : #commands }
SpecDebugger >> stackReceiverClassNavigationCommands [
	"Commands to navigate the selected context's receiver class as context "
	
	| group |
	group := (CmCommandGroup named: 'Receiver class navigation commands') asSpecGroup.
	group beDisplayedAsGroup.	
	{ 
		SpBrowseClassReferencesCommand.
		SpBrowseClassHierarchyCommand.
		SpBrowseClassVariablesCommand.
		SpBrowseClassVarRefsCommand.
		SpBrowseInstVarRefsCommand		
	 } do:[:navCmdClass| 	
			group register: (self navigationCommand: navCmdClass forContext:  [ stackTable selection selectedItem receiver class ])].		
	^ group
]

{ #category : #'accessing widgets' }
SpecDebugger >> stackTable [
	^stackTable
]

{ #category : #'accessing context' }
SpecDebugger >> statusLabelStyleForCurrentContext [
"true ifTrue: [ ^ 'label.headerError' ]."
	(self context tempNames includes: #exception) ifTrue: [ 
		(self context tempNamed: #exception) ifNotNil: [ :ex | 
			^ 'label.headerError' ] ].
	self context currentNode isHaltNode ifTrue: [ ^ 'label.headerError' ].
	^ 'label.header'
]

{ #category : #'accessing context' }
SpecDebugger >> statusLabelTextForCurrentContext [
	(self context tempNames includes: #exception)
		ifTrue: [ (self context tempNamed: #exception)
				ifNotNil: [ :ex | ^ ex description ] ].
	^ self context currentNode isHaltNode
		ifTrue: [ 'Halt' ]
		ifFalse:
			[ self context receiver class name , '>>' , self context selector ]
]

{ #category : #api }
SpecDebugger >> title [
	^ ((self session isContextPostMortem: self interruptedContext)
		ifTrue: [ 'PostMortem: ' ]
		ifFalse: [ '' ]) , self currentContext asString
]

{ #category : #'accessing widgets' }
SpecDebugger >> toolbar [

	^ toolbar
]

{ #category : #actions }
SpecDebugger >> toolbarActions [
	| group |
	self flag: 'Add metalink inspect button'.
	group := (CmCommandGroup named: 'Toolbar') asSpecGroup.
	(StDebugCommand toolbarCommandsForDebugger: self)
		do: [ :cmd | group register: cmd ].
	
	^ group
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeFromContext [

	self updateCodeFromContext: self currentContext
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeFromContext: aContext [
	| selectionInterval |
	aContext ifNil: [ ^ self clearCode ].
	selectionInterval := self session
		selectedCodeRangeForContext: aContext.
	self code
		text: aContext sourceCode;
		doItReceiver: aContext home receiver;
		doItContext: aContext;
		behavior: aContext home receiver class;
		selectionInterval: selectionInterval.
	self
		updateCodeTextSegmentDecoratorsIn: aContext
		forInterval: selectionInterval
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeHeaderLabel [
	
	codeHeader removeStyleFromLabel: 'label.headerError'.	
	codeHeader removeStyleFromLabel: 'label.header'.	
	codeHeader label: self statusLabelTextForCurrentContext.
	codeHeader applyStyleToLabel: self statusLabelStyleForCurrentContext.
	codeHeader update
	
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeTextSegmentDecoratorsIn: aContext forInterval: selectionInterval [
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
SpecDebugger >> updateContextChanged [
	self updateStep
]

{ #category : #'updating widgets' }
SpecDebugger >> updateExtensionsFrom: newSession [
	self extensionTools do:[:tool| tool updatePresenter]
]

{ #category : #'updating widgets' }
SpecDebugger >> updateInspectorFromContext: aContext [
	inspector
		updateWith:
			(StDebuggerContext
				context: aContext
				session: self session
				debugger: self)
]

{ #category : #'updating actions' }
SpecDebugger >> updateRestart [
	self updateStep
]

{ #category : #'updating actions' }
SpecDebugger >> updateResume [

	
]

{ #category : #stack }
SpecDebugger >> updateStackFromSession: aSession [
	|stack|
	stack := (self filterStack: aSession shortStack).
	stackTable items: stack.
	stackTable selectIndex: (self findFirstRelevantStackIndexIn: stack)
]

{ #category : #'updating actions' }
SpecDebugger >> updateStep [
	self updateInspectorFromContext: self context.
	self updateStackFromSession: self session.
	self updateCodeHeaderLabel.
	self updateExtensionsFrom: self session
]

{ #category : #'updating actions' }
SpecDebugger >> updateStepInto [
	self updateStep
]

{ #category : #'updating actions' }
SpecDebugger >> updateStepOver [

	self updateStep 
	
]

{ #category : #'updating actions' }
SpecDebugger >> updateStepThrough [

	self updateStep 
]

{ #category : #'updating widgets' }
SpecDebugger >> updateTitle [
	self withWindowDo: [ :window | window title: self title ]
]

{ #category : #'updating widgets' }
SpecDebugger >> updateToolbar [

	toolbar removeAllItems.
	SpToolBarPresenterBuilder new 
		toolbarPresenter: toolbar;
		visit: self toolbarActions
]
