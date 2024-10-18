"
The StDebugger is a presenter that provides Pharo debugging functionality by using a DebugSession.

The debugging logic is in DebugSession and the corresponding debugging actions. 

SpecDebugger only provides a graphical interface to access that functionality. 
To interact with the DebugSession, the debugger uses a StDebuggerActionModel, which has responsibility to perform actions to the execution context.


!!Structure of the Pharo debugger

!!!Sub-presenters and layouts
The debugger is composed of default views and extension views.
Default views are the stack, the commands, the status line, the code pane and the inspector.
An extension view automatically appears if any debugging extension is present and if extensions are activated in the settings.
If not, extensions do not appear.

Default and extension views are available in a vertical and an horizontal layout.
It is configureable in the settings under ==Tools >> Debugging >> Debugger layout==.
It is possible to fully customize the debugger layout, and therefore to add or remove any view.
The customized layout must then me selected in the aforementioned setting to be set as default.
To appear in that setting's list of possible values, the layout must be implemented in a method under the ==specs== protocol of the ==StDebugger== class side.

""""The stack.""""
It shows the call stack of the current interrupted context.
Each element in the stack is a context representing a message send.

The context menu (through right click) provides different interactions with the selected stack element: inspection, exploration, exportation, etc.

By default, only a small part of the stack is shown.
More of the stack is observable by either clicking on the bottom context (the last in the stack) or through the context menu.

""""Commands.""""
Commands are actions applicable to the current context
After each debugging action (''e.g.'', a step), the list of commands is being updated.
New commands may appear or disappear.
It depends if they are applicable or not to the current context and debugging session.
For instance, when a ==doesNotUnderstand== exception is raised (''i.e.'', a method does not exist), the command ''createMethod'' will appear.
In that case, it gives users the possibility to create the missing method and continue the execution.

""""The status line.""""
This view provides information about the current context.
Non-critical information, such as the current instruction being stepped, are displayed in gray.
Critical information ,such as halts or breakpoints or DNU exceptions, are displayed in red.

""""The code.""""
The code pane shows the source code of the interrupted context's method.
The source code is annotated with informations about the position of the interrupted execution.
This position corresponds to the next execution that will be executed if a step action is performed.
It is coloured in blue if that instruction is selected in the source code, or in orange and underlined if the selection is empty.

A context menu (through right click) provides inspection, exploration, and stepping actions applicable to the context.
Such actions include, ''e.g.'', browse implementors of a selected message or skip execution of selected parts of the code.

""""The inspector.""""
It provides views on the current context.
It contains tabs with different inspections or views on the current context or on the system.

The raw inspection shows three items: ''Receiver'', ''Temps'' and ''Context''.
The receiver item shows information about the receiver of the message, or the object executing the method from the context.
The temps item shows the temporary variables of the current context.
Finally, the context item shows lower-level details, such as the interrupted context, the debug session or the debugger itself.
Double-clicking on an item will spawn a new view in the same inspector, with an inspection on the selected item.

The breakpoints inspection shows all breakpoints installed for the current receiver.
Those breakpoints are either installed on the receiver's class (''e.g.'', halts) or on that specific receiver (''i.e.'', object-centric breakpoints or halts.)
Ticking or unticking a breakpoint in that list will activate or deactivate that breakpoint.

The meta inspection shows methods of the receiver's class hierarchy.
Methods can be modified and saved in directly in that pane.
"
Class {
	#name : 'StDebugger',
	#superclass : 'StPresenter',
	#traits : 'TDebugger',
	#classTraits : 'TDebugger classTrait',
	#instVars : [
		'code',
		'toolbar',
		'stackTable',
		'inspector',
		'breakpointInspector',
		'stackHeader',
		'extensionTools',
		'extensionToolsNotebook',
		'toolbarCommandGroup',
		'debuggerActionModel',
		'unsavedCodeChanges',
		'programmaticallyClosed',
		'stackAndCodeContainer'
	],
	#classVars : [
		'EnableStackColoring'
	],
	#classInstVars : [
		'layoutConfigurator'
	],
	#category : 'NewTools-Debugger-View',
	#package : 'NewTools-Debugger',
	#tag : 'View'
}

{ #category : 'commands' }
StDebugger class >> buildBreakpointExtentionCommandsGroupWith: stDebuggerInstance forRoot: rootCommandGroup [

	<extensionCommands>
	| commands codeGroup |
	commands := { StBreakOnStackCommand } collect: [ :class |
		            class forSpecContext: stDebuggerInstance ].


	codeGroup := rootCommandGroup
	             / StDebuggerCodeCommandTreeBuilder groupName
	             /
	             StDebuggerCodeCommandTreeBuilder new
		             codeDebugCommandsGroupName.
	commands do: [ :c | codeGroup register: c ]
]

{ #category : 'commands' }
StDebugger class >> buildCommandsGroupWith: stDebuggerInstance forRoot: rootCommandGroup [

	StDebuggerStackCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup.
	StDebuggerToolbarCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup.
	StDebuggerCodeCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup.
	StDebuggerConfigurationCommandTreeBuilder
		buildCommandsGroupWith: stDebuggerInstance
		forRoot: rootCommandGroup
]

{ #category : 'utilities' }
StDebugger class >> closeAllDebuggers [

	<script>
	self allInstancesDo: [ :dbg | dbg close ]
]

{ #category : 'accessing' }
StDebugger class >> configureLayout [
	 ^self layoutConfigurator selectedLayout
]

{ #category : 'accessing' }
StDebugger class >> configureLayout: aSymbol [

	self layoutConfigurator selectedLayout: aSymbol.
	self codeSupportAnnouncer announce: StDebuggerLayoutChangedAnnouncement new
]

{ #category : 'instance creation' }
StDebugger class >> debugSession: aDebugSession [

	| applicationDebugSession debugger debugActionModel |

	applicationDebugSession := self currentApplication backend
		                           spawnNewDebugSessionForSpecBackend: aDebugSession.	

	debugActionModel := StDebuggerActionModel on: applicationDebugSession.
	debugger := self on: applicationDebugSession.
	aDebugSession application ifNotNil: [ :app |
		debugger application: app ].

	applicationDebugSession deferDebuggerOpeningToBackend: debugger.
	
	^ debugger
]

{ #category : 'accessing' }
StDebugger class >> debuggerContextClass [
	^ StDebuggerContext
]

{ #category : 'accessing' }
StDebugger class >> debuggerLayoutSettingsOn: aBuilder [

	<systemsettings>
	(aBuilder pickOne: #configureLayout)
		parent: #debugging;
		label: 'Debugger Layout';
		target: StDebugger;
		default: #beVerticalStackThenCode;
		domainValues:
			#( #beHorizontalCodeThenStack #beHorizontalStackThenCode
			   #beVerticalCodeThenStack #beVerticalStackThenCode );
		description: ''
]

{ #category : 'accessing' }
StDebugger class >> defaultDebuggerRank [

	^ 10
]

{ #category : 'accessing' }
StDebugger class >> enableStackColoring [

	^ EnableStackColoring
]

{ #category : 'accessing' }
StDebugger class >> enableStackColoring: anObject [

	EnableStackColoring := anObject
]

{ #category : 'tools registry' }
StDebugger class >> extensionToolsClasses [

	^ TStDebuggerExtension users reject: [ :extensionClass |
		  extensionClass isOnlyForTests ]
]

{ #category : 'tools registry' }
StDebugger class >> hasAnyActivatedExtension: extensionsClasses [

	^ extensionsClasses anySatisfy: [ :toolClass | 
		  toolClass showInDebugger ]
]

{ #category : 'class initialization' }
StDebugger class >> initialize [ 

	EnableStackColoring := true
]

{ #category : 'accessing' }
StDebugger class >> layoutConfigurator [

	^ layoutConfigurator ifNil: [
		  layoutConfigurator := StDebuggerLayoutConfiguration new ]
]

{ #category : 'opening' }
StDebugger class >> openOn: aDebugSession withFullView: aBool [
	
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : 'opening' }
StDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger |
	debugger := self on: aDebugSession.
	debugger openWithFullView.
	^ debugger
]

{ #category : 'accessing' }
StDebugger class >> settings [

	^ StDebuggerSettings
]

{ #category : 'settings' }
StDebugger class >> stackColoringSettingOn: aBuilder [

	<systemsettings>
		(aBuilder setting: #enableStackColoring)
				label: 'Enable stack coloring';
				target: self;
				parent: #debugging;
				default: true;
				description:
					'If enable, the debugger will highlight the elements of the stacks that are from the same class and same package as the selected context.'.
]

{ #category : 'accessing' }
StDebugger class >> taskbarIconName [

	^#smallDebug
]

{ #category : 'tools registry' }
StDebugger class >> usesExtensions [

	^ self hasAnyActivatedExtension: self extensionToolsClasses
]

{ #category : 'code pane' }
StDebugger >> acceptCodeChanges: newSource forContext: aContext [

	"It is wrong here that I have to use code adapter widget.
	It is expected down in the compilation call chain that the notified requestor answers to textMorph.
	This is for modifying the source code when declaring temps"

	self
		recompileMethodTo: newSource
		inContext: aContext
		notifying: code adapter widget.
	self clearUnsavedCodeChanges
]

{ #category : 'extensions' }
StDebugger >> addExtension: aDebuggerExtensionClass [
	"If no extension was activated, we instantiate the page for the activated extension and we change the stack and code layout"

	self extensionTools ifEmpty: [
		extensionToolsNotebook pages:
			{ (self instantiateExtensionToolsPage: aDebuggerExtensionClass) }
				asOrderedCollection.
		extensionToolsNotebook selectPageIndex: 1.
		stackAndCodeContainer := self stackAndCodeWithExtensionsLayout.
		self layout: self defaultLayout.
		^ self ].

	"Else, if the extension was not activated and now is, we instantiate the page for the activated extension, and adds it to the existing pages"

	extensionToolsNotebook addPage:
		(self instantiateExtensionToolsPage: aDebuggerExtensionClass)
]

{ #category : 'actions' }
StDebugger >> breakOnStack [

	self debuggerActionModel
		breakOnStackAtSelection: self code selectionInterval
		inContext: self currentContext
]

{ #category : 'commands - support' }
StDebugger >> buildContextMenus [
	| stackGroup codeCommands debuggerCommandGroup |
	
	debuggerCommandGroup := self rootCommandsGroup.
	"Stack"
	stackGroup := debuggerCommandGroup / StDebuggerStackCommandTreeBuilder groupName. 
	stackTable actions: stackGroup.
	 
	"Toolbar"
	toolbarCommandGroup := debuggerCommandGroup / StDebuggerToolbarCommandTreeBuilder groupName.
	SpToolbarPresenterBuilder new
		toolbarPresenter: toolbar;
		visit: toolbarCommandGroup.

	"Code"
	codeCommands := debuggerCommandGroup / StDebuggerCodeCommandTreeBuilder groupName.
	code actions: codeCommands.
	
	"Configuration"
	stackHeader toolbarActions: (debuggerCommandGroup / StDebuggerConfigurationCommandTreeBuilder groupName)
]

{ #category : 'commands - support' }
StDebugger >> canExecuteCreateMissingClassCommand [
	^ self debuggerActionModel isInterruptedContextMissingClassException
]

{ #category : 'commands - support' }
StDebugger >> canExecuteCreateMissingMethodCommand [
	^ self debuggerActionModel isInterruptedContextDoesNotUnderstand
]

{ #category : 'commands - support' }
StDebugger >> canExecuteCreateSubclassResponsibilityCommand [
	^ self debuggerActionModel isInterruptedContextSubclassResponsibilityException
]

{ #category : 'commands - support' }
StDebugger >> canExecuteDebugCommand [
	^ self debuggerActionModel isContextSteppable
]

{ #category : 'commands - support' }
StDebugger >> canExecuteRestartCommand [

	^ (self debuggerActionModel isInterruptedContextPostMortem or: [ 
		   self debuggerActionModel isInterruptedContextDead ]) not
]

{ #category : 'commands - support' }
StDebugger >> canExecuteReturnCommand [

	^ self debuggerActionModel isInterruptedContextDead not
]

{ #category : 'testing' }
StDebugger >> canGenerateAndProceed [

	^ self debuggerActionModel isInterruptedContextGeneratingCode
]

{ #category : 'actions' }
StDebugger >> clear [

	extensionToolsNotebook pages do: [ :page |
		page activePresenter windowIsClosing ].
	extensionTools := nil.
	self unsubscribeFromActionModel.
	self unsubscribeFromSystemAnnouncer.

	self clearDebuggerActionModel.

	"When we programmatically close the window, we do not need to terminate the session as it was already cleared"
	programmaticallyClosed ifTrue: [ ^ self ].
	self clearDebugSession
]

{ #category : 'code pane' }
StDebugger >> clearCode [
	
	self code
		clearInteractionModel;
		clearSelection;
		clearContent
]

{ #category : 'actions' }
StDebugger >> clearDebugSession [

	self debuggerActionModel ifNotNil: [ :debugActionModel |
		debugActionModel clearDebugSession ]
]

{ #category : 'actions' }
StDebugger >> clearDebuggerActionModel [
	
	self debuggerActionModel ifNotNil: [ :debugActionModel | debugActionModel clear ]
]

{ #category : 'code pane' }
StDebugger >> clearUnsavedCodeChanges [

	unsavedCodeChanges := IdentityDictionary new
]

{ #category : 'opening' }
StDebugger >> close [

	programmaticallyClosed := true.
	[ self withWindowDo: #close ] ensure: [
		debuggerActionModel ifNotNil: [ :actionModel |
			actionModel clearDebugSession ] ]
]

{ #category : 'accessing - presenters' }
StDebugger >> code [

	^ code
]

{ #category : 'layout' }
StDebugger >> codeLayout [

	^ SpBoxLayout newTopToBottom
		  add: #toolbar expand: false;
		  add: #code;
		  yourself
]

{ #category : 'initialization' }
StDebugger >> connectPresenters [

	super connectPresenters.
	self whenDisplayDo: [ 
		self updateToolbar.
		self updateCodeFromContext ]
]

{ #category : 'accessing - model' }
StDebugger >> context [
 
	^ self interruptedContext
]

{ #category : 'accessing' }
StDebugger >> contextPredicate [

	^ self debuggerActionModel contextPredicate
]

{ #category : 'actions' }
StDebugger >> copyStackToClipboard [
	self debuggerActionModel copyStackToClipboard
]

{ #category : 'actions' }
StDebugger >> createMissingClass [

	| variableNode |
	variableNode := self exception variableNode.
	[ 
	| newClassBinding |
	self flag: 'This method is actually hard to test because it requires user input to complete. How to test that automatically?'.
	newClassBinding := OCCodeReparator new
		                   node: variableNode;
		                   defineClass: variableNode name ]
		on: Abort
		do: [ ^ self ].

	self debuggerActionModel restartContext:
		self interruptedContext sender
]

{ #category : 'accessing - model' }
StDebugger >> currentContext [
	"I answer the context on which an action should be executed.
	This is either the selected context or if nothing is selected the interrupted context."

	^ self selectedContext
		  ifNil: [ self interruptedContext ]
		  ifNotNil: [ self selectedContext ]
]

{ #category : 'accessing - model' }
StDebugger >> debuggerActionModel [
	^ debuggerActionModel
]

{ #category : 'subscription' }
StDebugger >> debuggerActionModelCleared [

	self unsubscribeFromActionModel.
	self unsubscribeFromSystemAnnouncer
]

{ #category : 'accessing - model' }
StDebugger >> debuggerInspectorClass [
	^ StDebuggerInspector
]

{ #category : 'accessing - model' }
StDebugger >> debuggerInspectorModelClass [
	^ StDebuggerInspectorModel
]

{ #category : 'layout' }
StDebugger >> defaultLayout [
	^ SpPanedLayout newTopToBottom
		positionOfSlider: 65 percent;
		add: stackAndCodeContainer;
		add: #inspector;
		yourself
]

{ #category : 'testing' }
StDebugger >> defaultSelectedCodeRangeForContext: aContext [

	^ self debuggerActionModel selectedCodeRangeForContext: aContext
]

{ #category : 'code pane' }
StDebugger >> discardCodeChangesFor: aContext [

	self unsavedCodeChanges removeKey: aContext ifAbsent: [  ].
	self code text: aContext sourceCode.
	self update
]

{ #category : 'commands' }
StDebugger >> doBrowseClass [

	self systemNavigation browse:
		(self stackSelectionMethodContext value: self)
]

{ #category : 'code pane' }
StDebugger >> doBrowseClassReferences [

	| cls |
	cls := self stackSelectionReceiverClassContext value: self.
	cls isTrait
		ifTrue: [ self systemNavigation browseAllUsersOfTrait: cls ]
		ifFalse: [ self systemNavigation browseAllCallsOnClass: cls ]
]

{ #category : 'commands' }
StDebugger >> doBrowseHierarchy [

	self systemNavigation browseHierarchy:
		(self stackSelectionReceiverClassContext value: self)
]

{ #category : 'commands' }
StDebugger >> doBrowseImplementors [

	self systemNavigation browseAllImplementorsOf:
		(self stackSelectionMethodSelectorContext value: self)
]

{ #category : 'commands' }
StDebugger >> doBrowseMethodInheritance [

	| cls |
	(self stackSelectionMethodContext value: self) method isDoIt ifTrue: [ 
		^ self ].
	cls := self stackSelectionReceiverClassContext value: self.
	cls isBlock ifTrue: [ 
		cls := (self stackSelectionMethodContext value: self) methodClass ].
	self systemNavigation
		methodHierarchyBrowserForClass:
		(self stackSelectionReceiverClassContext value: self)
		selector: (self stackSelectionMethodSelectorContext value: self)
]

{ #category : 'commands' }
StDebugger >> doBrowseMethodReferences [

	self systemNavigation browseAllSendersOrUsersOf:
		(self stackSelectionMethodSelectorContext value: self)
]

{ #category : 'commands' }
StDebugger >> doBrowseMethodVersions [

	| target |
	target := self stackSelectionMethodContext.
	target isBlock ifTrue: [ target := target method ].
	self application versionBrowser
		browseVersionsForClass: target methodClass
		selector: target selector
]

{ #category : 'commands' }
StDebugger >> doBrowseReceiverClass [

	self systemNavigation browse:
		(self stackSelectionReceiverClassContext value: self)
]

{ #category : 'commands' }
StDebugger >> doBrowseSenders [

	self systemNavigation browseAllSendersOf:
		(self stackSelectionMethodSelectorContext value: self)
]

{ #category : 'accessing - model' }
StDebugger >> exception [
	^ self debuggerActionModel exception
]

{ #category : 'stack' }
StDebugger >> expandStackIfLastItemIsSelected [
	| selection |
	selection := stackTable selection.
	selection selectedItem == stackTable items last ifFalse: [ ^ self ].
	stackTable items: (self filterStack:
			 (self stackOfSize: 2 * stackTable items size)).
	stackTable selectIndex: selection selectedIndex
]

{ #category : 'accessing - presenters' }
StDebugger >> extensionToolNotebook [

	^ extensionToolsNotebook
]

{ #category : 'extensions' }
StDebugger >> extensionToolUpdateBlock [

	^ [ :newPages |
	  newPages asSortedCollection: [ :s1 :s2 |
		  s1 presenterProvider value displayOrder
		  <= s2 presenterProvider value displayOrder ] ]
]

{ #category : 'extensions' }
StDebugger >> extensionTools [
	^ extensionTools ifNil: [ extensionTools := OrderedCollection new ]
]

{ #category : 'extensions' }
StDebugger >> extensionsToDisplay [

	^ self class extensionToolsClasses select: [ :s |
		  s showInDebugger and: [ s acceptsPredicate: self contextPredicate ] ]
]

{ #category : 'actions' }
StDebugger >> fileOutSelectedContext [
	self debuggerActionModel
		fileOutMethod: stackTable selection selectedItem method
]

{ #category : 'stack' }
StDebugger >> filterStack: aStack [
	^self debuggerActionModel filterStack: aStack
]

{ #category : 'stack' }
StDebugger >> findFirstRelevantStackIndexIn: aStack [
	| counter |
	counter := 1.
	aStack do: [ :context | 
		context method methodClass == TestAsserter ifFalse: [ ^ counter ].
		counter := counter + 1 ].
	^ 1
]

{ #category : 'updating' }
StDebugger >> forceSessionUpdate [

	self
		updateStackFromSession: self session;
		updateExtensionsFromSession: self session
]

{ #category : 'actions' }
StDebugger >> implementMissingMethod [

	self debuggerActionModel implementMissingMethod.
	self selectTopContext.
	self flag: 'why do we need to give code the keyboard focus?'
	"code takeKeyboardFocus"
]

{ #category : 'api' }
StDebugger >> initialExtent [

	^ self settings defaultExtent 
]

{ #category : 'initialization' }
StDebugger >> initialize [

	super initialize.
	self debuggerActionModel updateContextPredicate.
	self forceSessionUpdate.
  	self susbcribeToExtensionToggleAnnouncement.
	self susbcribeToLayoutChangesAnnouncement.
	
	programmaticallyClosed := false.
]

{ #category : 'initialization' }
StDebugger >> initializeBreakpointInspector [
	breakpointInspector := self
		instantiate: StDebuggerBreakpointInspection
		on: (StInspectorModel on: nil).
]

{ #category : 'code pane' }
StDebugger >> initializeCode [

	code := self instantiate: StDebuggerCodePresenter.
	code debuggerActionModel: self debuggerActionModel.
	code whenSubmitDo: [ :text | 
		self acceptCodeChanges: text string forContext: self selectedContext ].
	code whenResetDo: [ self discardCodeChangesFor: self selectedContext ]
]

{ #category : 'extensions' }
StDebugger >> initializeExtensionTools [

	| sortedToolClasses pages |
	extensionToolsNotebook := self newNotebook.
	extensionToolsNotebook whenPagesChangedDo:
		self extensionToolUpdateBlock.
	extensionToolsNotebook whenPageAddedDo: [ :newPage |
		self extensionToolUpdateBlock cull: extensionToolsNotebook pages ].
	self class usesExtensions ifFalse: [ ^ self ].

	sortedToolClasses := SortedCollection new sortBlock: [ :s1 :s2 |
		                     s1 displayOrder <= s2 displayOrder ].

	sortedToolClasses addAll: self extensionsToDisplay.
	pages := sortedToolClasses collect: [ :toolClass |
		         self instantiateExtensionToolsPage: toolClass ].
	extensionToolsNotebook pages: pages
]

{ #category : 'initialization' }
StDebugger >> initializeInspector [

	inspector := self
		instantiate: self debuggerInspectorClass
		on: (self debuggerInspectorModelClass on: self newDebuggerContext).
	inspector label: 'Receiver'
]

{ #category : 'initialization' }
StDebugger >> initializePresenters [

	self initializeStack.
	self initializeToolbar.
	self initializeCode.
	self initializeInspector.
	self initializeExtensionTools.
	self setStackAndCodeContainer.

	self layout: self defaultLayout
]

{ #category : 'initialization' }
StDebugger >> initializeShortcuts: aWindowPresenter [

	self flag: #DBG_TempSolvesSpecBug_RemoveWhenFixed.
	"This is only because of a problem in presenters, where shortcuts only work in the scope of their presenter.
	Consequently, debug shortcuts from the debugger toolbar only work if the mouse is over the toolbar button.
	This should be removed once the spec bug is fixed"
	
	aWindowPresenter 
		addShortcutWith: [ :action | action 
			shortcutKey: StProceedCommand defaultShortcut;
			action: [ self proceedDebugSession ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: StStepIntoCommand defaultShortcut;
			action: [ self stepInto ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: StStepOverCommand defaultShortcut;
			action: [ self stepOver ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: StStepThroughCommand defaultShortcut;
			action: [ self stepThrough ] ];
		addShortcutWith: [ :action | action 
			shortcutKey: StRestartCommand defaultShortcut;
			action: [ self restartCurrentContext ] ]
]

{ #category : 'stack' }
StDebugger >> initializeStack [

	stackTable := self newList.
	stackTable
		activateOnDoubleClick;
		whenActivatedDo: [ :selection | self doBrowseClass ].
	stackTable display:[:selection| StContextPrinter printContext: selection].
	stackTable displayColor:[ :context | self stackColorForContext: context ].
	stackTable displayIcon: [ :context| self stackIconForContext: context ].	
	stackTable transmitDo: [ :context |
		stackTable selection isEmpty ifFalse: [
			self updateInspectorFromContext: context.
			self updateCodeFromContext: context.
			self updateExtensionsFromSession: self session.
			self expandStackIfLastItemIsSelected.
			self updateWindowTitle ] ].
	stackHeader := self instantiate: StHeaderBar.
	stackHeader label: 'Stack'
]

{ #category : 'initialization' }
StDebugger >> initializeToolbar [

	toolbar := self newToolbar.
	toolbar addStyle: 'stToolbar'.
	toolbar displayMode: self application toolbarDisplayMode
]

{ #category : 'initialization' }
StDebugger >> initializeWindow: aWindowPresenter [

	super initializeWindow: aWindowPresenter.
	aWindowPresenter
		title: self debuggerActionModel statusStringForContext;
		initialExtent: self settings lastKnownExtent;
		initialPosition: self settings lastKnownPosition;
		windowIcon: (self iconNamed: #smallDebug);
		whenClosedDo: [ self clear ].

	self settings initializeWindow: aWindowPresenter.
	self initializeShortcuts: aWindowPresenter
]

{ #category : 'extensions' }
StDebugger >> instantiateExtensionToolsPage: aToolClass [

	| toolInstance |
	toolInstance := self instantiate: aToolClass on: self.
	toolInstance layout: toolInstance debuggerLayout.
	^ self notebookPageForExtension: toolInstance
]

{ #category : 'accessing - model' }
StDebugger >> interruptedContext [

	^ self debuggerActionModel interruptedContext
]

{ #category : 'accessing - model' }
StDebugger >> interruptedProcess [

	^ self debuggerActionModel  interruptedProcess
]

{ #category : 'testing' }
StDebugger >> isInSelectedContextClass: context [
	"Return true if the given context is in the same class than the currently selected context of the stack."

	| selectedContext |
	selectedContext := self selectedContext.
	^ selectedContext isNotNil and: [
		  selectedContext methodClass = context methodClass ]
]

{ #category : 'testing' }
StDebugger >> isInSelectedContextPackage: context [
	"Return true if the given context is in the same package than the currently selected context of the stack."

	^ self selectedContext method package = context method package
]

{ #category : 'commands - support' }
StDebugger >> keybindsForFromContextMenu: aGroupElement [
	| keybinds keybindsCommands |
	keybinds := KMCategory new.
	
	keybindsCommands := aGroupElement allCommands select: [ :aCommand | aCommand hasShortcutKey ].
	
	keybindsCommands do: [ :aCommand | | action |
		action := [ :aSelectedElement | aCommand execute ]. 
		keybinds addKeymapEntry: (KMKeymap
			shortcut: aCommand shortcutKey
			action: action).
		].
	
	^ keybinds
]

{ #category : 'instance creation' }
StDebugger >> newDebuggerContext [

	^ self class debuggerContextClass new
		  exception: self exception;
		  debugger: self;
		  yourself
]

{ #category : 'instance creation' }
StDebugger >> newDebuggerContextFor: aContext [

	^ self newDebuggerContext
		  context: aContext;
		  debugger: self;
		  yourself
]

{ #category : 'accessing - model' }
StDebugger >> newTitle [

	^ self debuggerActionModel statusStringForContext
]

{ #category : 'extensions' }
StDebugger >> notebookPageForExtension: anExtensionPresenter [

	self registerExtensionTool: anExtensionPresenter.
	^ SpNotebookPage
		  title: anExtensionPresenter debuggerExtensionToolName
		  provider: [ anExtensionPresenter ]
]

{ #category : 'api' }
StDebugger >> okToChange [

	self flag: 'Seems to be used to control if we can close the debugger when we edited code. This should be investigated'.
	self code canDiscardEdits ifTrue: [ ^ true ].
	self code changed: #wantToChange.
	^ self code canDiscardEdits
]

{ #category : 'opening' }
StDebugger >> openWithFullView [

	"Create and schedule a full debugger with the given label. Do not
	terminate the current active process."

	self open
]

{ #category : 'opening' }
StDebugger >> openWithNotification: notificationString [

	self openWithFullView
]

{ #category : 'actions' }
StDebugger >> peelToFirstLike: aContext [

	self debuggerActionModel peelToFirstLike: aContext.
	self clearUnsavedCodeChanges.
	self code text: self currentContext sourceCode
]

{ #category : 'actions' }
StDebugger >> proceedDebugSession [

	self unsubscribeFromActionModel .
	self debuggerActionModel proceedDebugSession.
	self close
]

{ #category : 'private' }
StDebugger >> protocolSuggestionsFor: aClass [

	| classProtocols reject allExistingProtocols interestingProtocols |
	classProtocols := aClass protocolNames.
	reject := Set with: Protocol unclassified.
	allExistingProtocols := (SystemNavigation default allExistingProtocolsFor: aClass isMeta not) reject: [ :p | classProtocols includes: p ].
	interestingProtocols := classProtocols , (allExistingProtocols asOrderedCollection sort: [ :a :b | a asLowercase < b asLowercase ]).
	^ interestingProtocols reject: [ :e | reject includes: e ]
]

{ #category : 'actions' }
StDebugger >> recompileMethodTo: aString inContext: aContext notifying: aNotifyer [

	^ self debuggerActionModel recompileMethodTo: aString inContext: aContext notifying: aNotifyer.
]

{ #category : 'code pane' }
StDebugger >> recordUnsavedCodeChanges [

	|codeInteractionModel codeText|
	codeInteractionModel := self code interactionModel.
	codeInteractionModel hasUnsavedCodeChanges ifFalse:[^self].
	
	codeText := self code text asString.
	self unsavedCodeChanges at: codeInteractionModel context put: codeText
]

{ #category : 'extensions' }
StDebugger >> registerExtensionTool: anExtension [
	self extensionTools add: anExtension
]

{ #category : 'extensions' }
StDebugger >> removeExtension: aDebuggerExtension [
	"Else, the extension was activated and now isn't anymore. In this case, we remove the corresponding page. If there isn't any activated extension left, we change the stackAndCode layout"

	extensionToolsNotebook pages: (extensionToolsNotebook pages
			 removeAllSuchThat: [ :page |
				 page presenterProvider value class = aDebuggerExtension ];
			 yourself).
	extensionTools removeAllSuchThat: [ :extensionInstance |
		extensionInstance class = aDebuggerExtension ].
	extensionTools ifEmpty: [
		stackAndCodeContainer := self stackAndCodeLayout ].
	self layout: self defaultLayout
]

{ #category : 'actions' }
StDebugger >> restartCurrentContext [

	self debuggerActionModel restartContext: self currentContext.
	self clearUnsavedCodeChanges.
	self code text: self currentContext sourceCode.
	self updateCodeFromContext
]

{ #category : 'actions' }
StDebugger >> returnEnteredValue [
	| expression |
	self flag: #DBG_HowToTestNilIfUserCancels.
	expression := (self application newRequest
		title: 'Enter expression for return value:';
		openModal
		) ifNil: [^self].
	self debuggerActionModel
		returnValueFromExpression: expression
		fromContext: self currentContext
]

{ #category : 'actions' }
StDebugger >> runToSelection [
	self debuggerActionModel
		runToSelection: self code selectionInterval
		inContext: self currentContext
]

{ #category : 'actions' }
StDebugger >> saveGeneratedCodeAndProceed [

	self
		acceptCodeChanges: self code text
		forContext: self selectedContext.

	self proceedDebugSession
]

{ #category : 'actions' }
StDebugger >> selectNextExecutedExpression [

	| sourceNodeExecuted |
	sourceNodeExecuted := self currentContext sourceNodeExecuted.
	self code selectionInterval:
		(sourceNodeExecuted start to: sourceNodeExecuted stop)
]

{ #category : 'stack' }
StDebugger >> selectTopContext [

	stackTable selectIndex: 1
]

{ #category : 'highlighting' }
StDebugger >> selectedCodeRangeForContext: aContext [

	^ self debuggerActionModel exception
		  selectedCodeRangeForContext: aContext
		  forDebugger: self
]

{ #category : 'accessing - model' }
StDebugger >> selectedContext [

	^ self stackTable selection selectedItem
]

{ #category : 'accessing - model' }
StDebugger >> session [
	^ self debuggerActionModel session
]

{ #category : 'accessing - model' }
StDebugger >> session: aSession [

	debuggerActionModel
		ifNil: [ 
			debuggerActionModel := StDebuggerActionModel on: aSession.
			self subscribeToActionModel ]
		ifNotNil: [ debuggerActionModel session: aSession ]
]

{ #category : 'initialization' }
StDebugger >> setModelBeforeInitialization: aSession [

	self session: aSession
]

{ #category : 'initialization' }
StDebugger >> setStackAndCodeContainer [

	stackAndCodeContainer := extensionTools
		                         ifEmpty: [ self stackAndCodeLayout ]
		                         ifNotEmpty: [
		                         self stackAndCodeWithExtensionsLayout ]
]

{ #category : 'api' }
StDebugger >> settings [

	^ self class settings 
]

{ #category : 'stack' }
StDebugger >> stack [
	^ self debuggerActionModel stack 

]

{ #category : 'layout' }
StDebugger >> stackAndCodeLayout [

	^ self class layoutConfigurator configureForLayouts: {
			  (#stack -> self stackLayout).
			  (#code -> self codeLayout) } asDictionary
]

{ #category : 'layout' }
StDebugger >> stackAndCodeWithExtensionsLayout [

	^ (SpPanedLayout newLeftToRight
			positionOfSlider: 65 percent;
			add: self stackAndCodeLayout;
			add: #extensionToolsNotebook;
			yourself)
]

{ #category : 'stack' }
StDebugger >> stackColorForContext: context [
	"I return the color the text should have in the stack by comparing the context in parameter to the selected context.
	
	If they are from the same class, we return a certain 'primary' highlight color.
	If they are from the same package (but different class), we return a 'secondary' highlight color.
	Else, we just keep the normal style."

	self class enableStackColoring ifFalse: [ ^ self theme textColor ].
	self selectedContext ifNil: [ ^ self theme textColor ].

	^ (self isInSelectedContextClass: context)
		  ifTrue: [ self theme highlightTextColor ]
		  ifFalse: [
			  (self isInSelectedContextPackage: context)
				  ifTrue: [
				  self theme highlightTextColor
					  mixed: 0.5
					  with: self theme textColor ]
				  ifFalse: [ self theme textColor ] ]
]

{ #category : 'accessing - presenters' }
StDebugger >> stackHeader [

	^ stackHeader
]

{ #category : 'stack' }
StDebugger >> stackIconForContext: context [

	self unsavedCodeChanges at: context ifAbsent: [ ^ nil ].
	^ self iconNamed: #repair
]

{ #category : 'layout' }
StDebugger >> stackLayout [
	^ SpBoxLayout newTopToBottom
		add: #stackHeader
			expand: false
			fill: false
			padding: 5;
		add: #stackTable;
		yourself
]

{ #category : 'stack' }
StDebugger >> stackOfSize: anInteger [

	^ self debuggerActionModel stackOfSize: anInteger
]

{ #category : 'commands - support' }
StDebugger >> stackSelectionMethodContext [

	^ [ :dbg | stackTable selection selectedItem homeMethod ]
]

{ #category : 'commands - support' }
StDebugger >> stackSelectionMethodSelectorContext [

	^ [ :dbg | stackTable selection selectedItem method selector ]
]

{ #category : 'commands - support' }
StDebugger >> stackSelectionReceiverClassContext [

	^ [ :dbg | stackTable selection selectedItem receiver class ]
]

{ #category : 'commands - support' }
StDebugger >> stackSelectionReceiverContext [

	^ [ :dbg | stackTable selection selectedItem receiver ]
]

{ #category : 'accessing - presenters' }
StDebugger >> stackTable [

	^ stackTable
]

{ #category : 'actions' }
StDebugger >> stepInto [
	self debuggerActionModel stepInto: self currentContext
]

{ #category : 'actions' }
StDebugger >> stepOver [
	self debuggerActionModel stepOver: self currentContext
]

{ #category : 'actions' }
StDebugger >> stepThrough [
	self debuggerActionModel stepThrough: self currentContext
]

{ #category : 'subscription' }
StDebugger >> subscribeToActionModel [

	self debuggerActionModel
		when: StDebuggerActionModelStepAnnouncement
		send: #updateStep
		to: self;
		when: StDebuggerActionModelRestartAnnouncement
		send: #updateRestart
		to: self;
		when: StDebuggerActionModelContextChangedAnnouncement
		send: #updateContextChanged
		to: self;
		when: StDebuggerActionModelMethodAddedAnnouncement
		send: #updateAfterMethodAdded
		to: self;
		when: StDebuggerActionModelClearAnnouncement
		send: #debuggerActionModelCleared
		to: self
]

{ #category : 'subscription' }
StDebugger >> susbcribeToExtensionToggleAnnouncement [

	self class codeSupportAnnouncer weak when: StDebuggerExtensionActivationToggle send: #updateExtensionsFromAnnouncement: to: self
]

{ #category : 'subscription' }
StDebugger >> susbcribeToLayoutChangesAnnouncement [

	self class codeSupportAnnouncer weak when: StDebuggerLayoutChangedAnnouncement send: #updateLayout to: self
]

{ #category : 'accessing - presenters' }
StDebugger >> toolbar [

	^ toolbar
]

{ #category : 'code pane' }
StDebugger >> unsavedCodeChanges [

	^ unsavedCodeChanges ifNil: [ 
		  unsavedCodeChanges := IdentityDictionary new ]
]

{ #category : 'code pane' }
StDebugger >> unsavedCodeChangesFor: aContext [ 
	^self unsavedCodeChanges at: aContext
]

{ #category : 'events - removing' }
StDebugger >> unsubscribeFromActionModel [

	self debuggerActionModel ifNotNil: [ :actionModel |
		actionModel unsubscribe: self ]
]

{ #category : 'subscription' }
StDebugger >> unsubscribeFromSystemAnnouncer [

	self class codeSupportAnnouncer unsubscribe: self
]

{ #category : 'updating' }
StDebugger >> updateAfterMethodAdded [

	self updateToolbar
]

{ #category : 'updating - presenters' }
StDebugger >> updateCodeFromContext [

	self updateCodeFromContext: self currentContext
]

{ #category : 'code pane' }
StDebugger >> updateCodeFromContext: aContext [

	| selectionInterval formerCodeInteractionModel |
	aContext ifNil: [ ^ self clearCode ].

	self recordUnsavedCodeChanges.
	aContext sourceCode = self code text ifFalse: [
		self updateSourceCodeFor: aContext ].
	selectionInterval := self selectedCodeRangeForContext: aContext.
	formerCodeInteractionModel := self code interactionModel.
	self code beForContext: aContext.
	"add bindings of the old interaction model in the new one"
	formerCodeInteractionModel ifNotNil: [
		formerCodeInteractionModel bindings associations do: [ :assoc |
			self code interactionModel addBinding: assoc ] ].
	self code selectionInterval:
		(selectionInterval last to: selectionInterval last - 1).
	self
		updateCodeTextSegmentDecoratorsIn: aContext
		forInterval: selectionInterval
]

{ #category : 'updating - presenters' }
StDebugger >> updateCodeTextSegmentDecoratorsIn: aContext forInterval: selectionInterval [
	
	self code removeAllTextSegmentDecorations.
	
	"This decorates the receiver and the next node with an underline"
	"self code
		addTextSegmentDecoration:
			(SpTextPresenterDecorator new
				underlineColor: Color orange;
				interval: (aContext currentNode start to: aContext currentNode stop + 1);
				yourself)."
				
	"This decorates the next executing node"
	self code addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
		interval: (selectionInterval first to: selectionInterval last + 1);
		yourself)
				
	"	icon: (self iconNamed: #warning);
		iconBlock: [ :n | n inspect ];
		title: 'Click me!';"
]

{ #category : 'updating' }
StDebugger >> updateContextChanged [
	"A context has changed when a method has been recompiled. If a method has been recompiled with additional instance variables and/or temporary variables, the inspector needs to be updated"

	inspector shouldUpdate.
	"The top context has been changed so we force the code presenter to change its text. Otherwise, the debugger would consider that there are unsaved code changes, as the source code from the context would not be the same as the source code displayed"
	self updateSourceCodeFor: self interruptedContext.
	self updateStep
]

{ #category : 'initialization' }
StDebugger >> updateExtensionsFromAnnouncement: aStDebuggerToggleAnnouncement [

	| extensionToggled |
	extensionToggled := aStDebuggerToggleAnnouncement
		                    debuggerExtensionClass.

	"If the extension was (de)activated but does not accept the corresponding context predicate, nothing changes"
	(extensionToggled acceptsPredicate: self contextPredicate) ifFalse: [
		^ self ].

	extensionToggled showInDebugger
		ifTrue: [ self addExtension: extensionToggled ]
		ifFalse: [ self removeExtension: extensionToggled ]
]

{ #category : 'updating - presenters' }
StDebugger >> updateExtensionsFromSession: newSession [

	| newExtensions |
	newExtensions := self extensionsToDisplay.

	"All extensions that were displayed but shouldn't be anymore are removed"
	(extensionTools
		 collect: [ :each | each class ]
		 thenReject: [ :each | newExtensions includes: each ]) do: [
		:extension | self removeExtension: extension ].

	"All extensions that weren't displayed but should be now, are displayed"
	(newExtensions copyWithoutAll:
		 (extensionTools collect: [ :each | each class ])) do: [ :extension |
		self addExtension: extension ].
	self extensionTools do: [ :tool | tool updatePresenter ]
]

{ #category : 'updating - presenters' }
StDebugger >> updateInspectorFromContext: aContext [

	inspector
		updateLayoutForContexts: self interruptedContext
		isAssertionFailure:
		self debuggerActionModel isInterruptedContextAnAssertEqualsFailure.
	inspector updateWith: (self newDebuggerContextFor: aContext).
	self flag: #DBG_INSPECTOR_UPDATE_BUG.
	inspector getRawInspectorPresenterOrNil ifNotNil: [ :p | p update ]
]

{ #category : 'updating' }
StDebugger >> updateLayout [

	self setStackAndCodeContainer.
	self layout: self defaultLayout
]

{ #category : 'initialization' }
StDebugger >> updatePresenter [

	self updateStackFromSession: self session.
	self buildContextMenus
]

{ #category : 'updating' }
StDebugger >> updateRestart [

	self updateStep
]

{ #category : 'code pane' }
StDebugger >> updateSourceCodeFor: aContext [

	| codeText |
	codeText := self unsavedCodeChanges
		            at: aContext
		            ifAbsent: [ aContext sourceCode ].
	self code text: codeText
]

{ #category : 'stack' }
StDebugger >> updateStackFromSession: aSession [
	| stack |
	stack := self filterStack: aSession stack.
	stackTable items: stack.
	stackTable
		selectIndex: (self findFirstRelevantStackIndexIn: stack)
		scrollToSelection: true
]

{ #category : 'updating' }
StDebugger >> updateStep [
  | previousASTScope previousContext currentASTScope currentContext |
	
  	previousContext := self currentContext.
	previousASTScope := debuggerActionModel previousASTScope. 

	self updateStackFromSession: self session.
	self updateWindowTitle.
	self updateExtensionsFromSession: self session.
	self updateToolbar.

	currentContext := self currentContext.
	currentASTScope := (currentContext compiledCode sourceNodeForPC:
		                    currentContext pc) scope.
	self flag: #DBG_INSPECTOR_UPDATE_BUG.
	inspector getRawInspectorPresenterOrNil ifNotNil: [ :p |
		previousContext == currentContext ifTrue: [ "otherwise, if contexts have changed, updating the stack has already updated all nodes." "Here it is necessary to update temporary nodes if we are still in the same context but in a different scope. This is possible when leaving or entering an optimized block scope."
			p updateNodesFromScope: previousASTScope to: currentASTScope ].
		p update ]
]

{ #category : 'updating - presenters' }
StDebugger >> updateToolbar [
	
	toolbarCommandGroup ifNil: [ ^ self ].
	toolbarCommandGroup allCommands do: [ :spCommand | 
		spCommand updateEnableStatus ]
]

{ #category : 'updating - presenters' }
StDebugger >> updateWindowTitle [

	self withWindowDo: [ :window | window title: self newTitle ].
]

{ #category : 'ui requests' }
StDebugger >> warning: aString for: aPresenter [

	self newPopover
		addStyle: 'error';
		relativeTo: aPresenter;
		position: SpPopoverPosition top;
		presenter: (SpPresenter new
				 layout: (SpBoxLayout newTopToBottom
						  borderWidth: 2;
						  spacing: 0;
						  add: (self newLabel label: aString);
						  yourself);
				 yourself);
		popup
]
