"
A SpecDebugger is a UI build in Spec that provides Smalltalk debugging functionality by using a DebugSession.

All the debugging logic is in DebugSession and the corresponding debugging actions. SpecDebugger only provides a graphical interface to access that functionality. The debugging actions are managed by the toolbar widget; the stack and all its related actions are managed by the stack widget.

"
Class {
	#name : #SpecDebugger,
	#superclass : #SpPresenterWithModel,
	#instVars : [
		'sessionHolder',
		'labelHolder',
		'code',
		'toolbar',
		'contextInspector',
		'receiverInspector',
		'stackTable',
		'sindarinDebugger',
		'subscription'
	],
	#classVars : [
		'ErrorRecursion',
		'FilterCommonMessageSends',
		'LogDebuggerStackToFile'
	],
	#category : #'NewTools-Debugger-View'
}

{ #category : #'tools registry' }
SpecDebugger class >> availableAutomatically [
	"Should this debugger be taken into account when looking for a debugger to handle an exception."

	^ true
]

{ #category : #utilities }
SpecDebugger class >> closeAllDebuggers [
	<script>
	SpecDebugger allInstancesDo: [ :dbg | dbg close ].
	SpecPreDebugPresenter allInstancesDo: [ :dbg | dbg close ]
]

{ #category : #specs }
SpecDebugger class >> defaultSpec [
	<spec: #default>

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
			add: #receiverInspector;
			add: #contextInspector;
			yourself);
		yourself
]

{ #category : #'menu code' }
SpecDebugger class >> dynamicCodeContextMenu: aBuilder [
	<contextMenu>
	<specDebuggerCodeContextMenu>
	self flag: 'BROKEN 2019-06-28'.
	aBuilder model codeContextMenuDebuggingActions do: [ :anAction | 
		anAction asMenuRegistrationIn: aBuilder ]
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

{ #category : #'class initialization' }
SpecDebugger class >> initialize [ 
	
	ErrorRecursion := false.

	"Ugly check to make sure the debugger will work until everything is in the image"
	(Smalltalk tools respondsTo: #registerDebugger:withRank:) ifFalse: [ ^ self ].

	"Add ourselves to registry. See [Smalltalk tools]" 
	Smalltalk tools registerDebugger: self withRank: 80.
	
]

{ #category : #settings }
SpecDebugger class >> logDebuggerStackToFile [
	^ LogDebuggerStackToFile ifNil: [LogDebuggerStackToFile := true]
]

{ #category : #settings }
SpecDebugger class >> logDebuggerStackToFile: aBoolean [
	 LogDebuggerStackToFile := aBoolean
]

{ #category : #'instance creation' }
SpecDebugger class >> on: aDebugSession [
	| sindarinDebugSession returnValue |
	sindarinDebugSession := SindarinDebugSession forDebugSession: aDebugSession.
	[sindarinDebugSession interruptedContext == aDebugSession interruptedContext ] whileFalse: [ sindarinDebugSession stepOver ].
	returnValue := self basicNew
		session: sindarinDebugSession;
		sindarinDebugger: (SindarinDebugger attachTo: sindarinDebugSession);
		initialize.
	sindarinDebugSession activateEventTriggering.
	^ returnValue
	
]

{ #category : #opening }
SpecDebugger class >> openOn: aDebugSession withFullView: aBool [
	
	^ self openOn: aDebugSession withFullView: aBool andNotification: nil
]

{ #category : #opening }
SpecDebugger class >> openOn: aDebugSession withFullView: aBool andNotification: aString [
	| debugger |
	debugger := self on: aDebugSession.
	debugger openWithFullView.
	^ debugger
]

{ #category : #'tools registry' }
SpecDebugger class >> register [

	self registerToolsOn: Smalltalk tools
]

{ #category : #'tools registry' }
SpecDebugger class >> registerToolsOn: registry [

	"Add ourselves to registry. See [Smalltalk tools]" 
	registry register: self as: #debugger.

]

{ #category : #accessing }
SpecDebugger class >> sessionClass [
	self flag: 'Should be replaced by Sindarin - should even be removed in that case!'.
	^ DebugSession
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

{ #category : #actions }
SpecDebugger >> clear [
	self removeActionsForSession: self session.

	"No more code should follow after this, as the session might terminate this process."
	self session terminate
]

{ #category : #actions }
SpecDebugger >> close [
	self withWindowDo: #close
]

{ #category : #'accessing widgets' }
SpecDebugger >> code [

	^ code
]

{ #category : #'actions code' }
SpecDebugger >> codeContextMenuDebuggingActions [
	self deprecated: 'Commands should be used from now on'.
	^ self session class 
		debuggingActionsForPragmas: #(contextMenuCodeDebuggingAction) 
		for: self
]

{ #category : #accessing }
SpecDebugger >> color: aColor [
	"Hack to make the spec debugger availlable in tests too"
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

{ #category : #api }
SpecDebugger >> initialExtent [ 
	"This code was taken from the old debugger to get the same behavior. Fell free to refactor"

	RealEstateAgent standardWindowExtent y < 400 "a tiny screen" 
		ifTrue: [^ 700@500].
	
	^ [ | w h |
		w := Display width.
		h := Display height.
		(w - (w // 3)) @ (h - (h // 5)) ]
		on: Error
		do: [ 850@600 ]
]

{ #category : #initialization }
SpecDebugger >> initialize [
	super initialize.
	self whenWindowChanged: [ :w | w whenClosedDo: [ self clear ] ].
	self sessionHolder
		whenChangedDo: [ :newSession :oldSession | 
			self removeActionsForSession: oldSession.
			self registerActionsForSession: newSession.
			self updateToolbar.
			self updateStackFromSession: newSession ].
	self labelHolder whenChangedDo: [ self updateTitle ].
	self sessionHolder valueChanged
]

{ #category : #initialization }
SpecDebugger >> initializeInspectors [

	receiverInspector := (StDebuggerInspector
		newApplication: self application
		model: (StInspectorModel on: nil))
		label: 'Receiver'.

	contextInspector := (StDebuggerInspector
		newApplication: self application
		model: (StInspectorModel on: [ ] asContext))
		label: 'Context'
]

{ #category : #stack }
SpecDebugger >> initializeStack [
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
			(SpStringTableColumn title: 'Context' evaluated: [ :item | item sender ]).
	stackTable
		whenSelectionChangedDo: [ :selection | 
			| context |
			context := selection selectedItem.
			self updateCodeFromContext: context.
			self updateInspectorsFromContext: context.
			self updateToolbar ].
	stackTable
		contextMenu: [ self stackMenuActions beRoot asMenuPresenter ]
]

{ #category : #initialization }
SpecDebugger >> initializeWidgets [
	self initializeStack.
	toolbar := self newDynamicToolbar.
	code := self newCode.
	self initializeInspectors.
	self code
		acceptBlock: [ :text :notifyer | 
			self
				recompileMethodTo: text string
				inContext: self stackTable selection selectedItem
				notifying: notifyer ]
	"self code selection whenChangedSend: #selectionChanged to: self"
]

{ #category : #'accessing context' }
SpecDebugger >> interruptedContext [

	^ self session interruptedContext
]

{ #category : #accessing }
SpecDebugger >> interruptedProcess [

	^ self session interruptedProcess
]

{ #category : #accessing }
SpecDebugger >> label [
	^ self labelHolder value
]

{ #category : #accessing }
SpecDebugger >> label: aString [
	self labelHolder value: aString
]

{ #category : #accessing }
SpecDebugger >> labelHolder [
	^ labelHolder ifNil: [ labelHolder := nil asValueHolder ]
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

{ #category : #session }
SpecDebugger >> registerActionsForSession: aSession [

	self flag: 'Kill it'.

	aSession ifNotNil: [
		aSession
			when: #restart send: #updateRestart to: self;
			when: #resume send: #updateResume to: self;
			when: #stepInto send: #updateStepInto to: self;
			when: #stepOver send: #updateStepOver to: self;
			when: #stepThrough send: #updateStepThrough to: self;
			when: #contextChanged send: #updateContextChanged to: self  ]
]

{ #category : #session }
SpecDebugger >> removeActionsForSession: aSession [
self flag: 'Kill it'.
	aSession ifNotNil: [ 
		aSession  
			removeActionsForEvent: #restart;
			removeActionsForEvent: #resume;
			removeActionsForEvent: #stepInto;
			removeActionsForEvent: #stepOver;
			removeActionsForEvent: #stepThrough;
			removeActionsForEvent:#contextChanged ]. 
]

{ #category : #'accessing context' }
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
	self sessionHolder value: aSession.
	self label: aSession asString
]

{ #category : #accessing }
SpecDebugger >> sessionHolder [
	^ sessionHolder ifNil: [ sessionHolder := nil asValueHolder ]
]

{ #category : #accessing }
SpecDebugger >> sindarinDebugger [
	^ sindarinDebugger
]

{ #category : #accessing }
SpecDebugger >> sindarinDebugger: aSindarinDebugger [
	sindarinDebugger := aSindarinDebugger
]

{ #category : #actions }
SpecDebugger >> stackMenuActions [
	| group |
	group := (CmCommandGroup named: 'Stack') decorateWith: SpCommandGroup.
	(DebugCommand stackContextMenuCommandsForDebugger: self)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #initialization }
SpecDebugger >> subscribeToSessionHolder [
	self sessionHolder
		whenChangedDo: [ :newSession :oldSession | 
			self removeActionsForSession: oldSession.
			self registerActionsForSession: newSession.
			self updateToolbar.
			self updateStackFromSession: newSession ].
]

{ #category : #api }
SpecDebugger >> title [

	^ ((self session isContextPostMortem: self interruptedContext)  
			ifTrue: [ 'PostMortem: ' ]
			ifFalse: [ '' ]), (self label ifNil: [ '' ])
]

{ #category : #'accessing widgets' }
SpecDebugger >> toolbar [

	^ toolbar
]

{ #category : #actions }
SpecDebugger >> toolbarActions [
	| group |
	group := (CmCommandGroup named: 'Toolbar')
		decorateWith: SpCommandGroup.
	(DebugCommand toolbarCommandsForDebugger: self)
		do: [ :cmd | group register: cmd ].
	^ group
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeFromContext [
	self updateCodeFromContext: self currentContext.
]

{ #category : #'updating widgets' }
SpecDebugger >> updateCodeFromContext: aContext [
	aContext
		ifNil: [ self code
				withoutSyntaxHighlight;
				text: '';
				behavior: nil;
				setSelection: (1 to: 0) ]
		ifNotNil: [ | selectionInterval |
			selectionInterval := self session
				selectedCodeRangeForContext: aContext.
			self code
				withSyntaxHighlight;
				text: aContext sourceCode;
				doItReceiver: aContext home receiver;
				doItContext: aContext;
				behavior: aContext home receiver class;
				setSelection: selectionInterval ]
]

{ #category : #'updating actions' }
SpecDebugger >> updateContextChanged [
	| selection |
	selection := self stackTable selection selectedItem.
	self updateStep
	"	self stack selectItem: selection"
]

{ #category : #updating }
SpecDebugger >> updateInspectorsFromContext: aContext [
	contextInspector updateWith: aContext.
	receiverInspector updateWith: aContext home receiver
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
	stackTable items: aSession shortStack.
	stackTable selectIndex: 1
]

{ #category : #'updating actions' }
SpecDebugger >> updateStep [
	self updateStackFromSession: self session
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
SpecDebugger >> updateToolbar [
	self toolbar update
]

{ #category : #'updating widgets' }
SpecDebugger >> updateToolbarFromSession: aSession [
	"self toolbar session: aSession"
]
