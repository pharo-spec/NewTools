"
I am the System ProcessBrowser.
I present the information about the running processes, allowing to auto update and to show or not the CPU consumption.
"
Class {
	#name : 'StProcessBrowser',
	#superclass : 'StPresenter',
	#instVars : [
		'processListPresenter',
		'stackListPresenter',
		'codePresenter',
		'model',
		'processToolbarActions',
		'processToolbarPresenter',
		'generalToolbarPresenter',
		'generalToolbarActions',
		'contextToolbarActions',
		'autoUpdateProcess',
		'autoUpdateAction',
		'autoUpdating',
		'updatingPresenters',
		'cpuWatcher',
		'cpuWatcherAction'
	],
	#classVars : [
		'WellKnownProcesses'
	],
	#category : 'NewTools-ProcessBrowser-Browsers',
	#package : 'NewTools-ProcessBrowser',
	#tag : 'Browsers'
}

{ #category : 'accessing' }
StProcessBrowser class >> autoUpdateProcessName [

	^ 'my auto-update process'
]

{ #category : 'accessing' }
StProcessBrowser class >> defaultExtent [

	^ 800@550
]

{ #category : 'class initialization' }
StProcessBrowser class >> initialize [

	self registerWellKnownProcesses
]

{ #category : 'world menu' }
StProcessBrowser class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: #'Process Browser')
		parent: #SystemTools;
		order: 3;
		action: [ self open ];
		help: 'Provides a view of all of the processes (threads) executing in Smalltalk.';
		iconName: self taskbarIconName
]

{ #category : 'private' }
StProcessBrowser class >> nameAndRulesFor: aProcess [
	"Answer a nickname and two flags: allow-stop, and allow-debug"
	^ WellKnownProcesses
		detect: [ :each | each matchesProcess: aProcess ]
		ifNone: [ StWellKnownProcess newDefinition: [ aProcess ] allowStop: true allowDebug: true  ]
]

{ #category : 'instance creation' }
StProcessBrowser class >> open [
	<script>
	
	^ self new open
]

{ #category : 'private - initialization' }
StProcessBrowser class >> registerWellKnownProcesses [

	WellKnownProcesses := {
		StWellKnownProcess newDefinition: [ ] label: 'no process'.
		StWellKnownProcess newDefinition: [ Smalltalk lowSpaceWatcherProcess ].
		StWellKnownProcess newDefinition: [ FinalizationProcess runningFinalizationProcess ].
		StWellKnownProcess newDefinition: [ Processor backgroundProcess ].
		StWellKnownProcess newDefinition: [ MorphicUIManager uiProcess ].
		StWellKnownProcess newDefinition: [ Delay schedulingProcess ] 
	}
]

{ #category : 'world menu' }
StProcessBrowser class >> taskbarIconName [

	^ #processBrowser
]

{ #category : 'accessing' }
StProcessBrowser class >> title [

	^ 'Process Browser'
]

{ #category : 'actions' }
StProcessBrowser >> browseSelectedContext [

	self selectedContext ifNotNil: [ :aContext | aContext receiver browse ]
]

{ #category : 'private' }
StProcessBrowser >> buildContextToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Inspect';
			iconName: #smallInspectIt;
			description: 'Inspect selected context.';
			shortcutKey: $i actionModifier;
			action: [ self inspectSelectedContext ] ];
		addActionWith: [ :action | action 
			name: 'Inspect Receiver';
			iconName: #smallInspectIt;
			description: 'Inspect selected context receiver.';
			shortcutKey: $i shift actionModifier;
			action: [ self inspectSelectedContextReceiver ] ];
		addActionWith: [ :action | action 
			name: 'Browse';
			iconName: #smallSystemBrowser;
			description: 'Browse context.';
			shortcutKey: $b actionModifier;
			action: [ self browseSelectedContext ] ];
		yourself
]

{ #category : 'private' }
StProcessBrowser >> buildGeneralToolbarActions [
	
	^ SpActionGroup new
		addActionWith: [ :action | (cpuWatcherAction := action)
			name: 'Show CPU Usage';
			iconName: 'search';
			description: 'Show CPU Usage per Process';
			beToggleButton;
			action: [ self toggleCPUWatcher ]];
		addActionWith: [ :action | (autoUpdateAction := action) 
			name: 'Auto update';
			iconName: #autoReload;
			description: 'Toggle auto processes update.';
			beToggleButton;
			action: [ self toggleAutoUpdate ]];
		addActionWith: [ :action | action 
			name: 'Refresh';
			iconName: #refresh;
			description: 'Refresh list of process.'; 
			action: [ self refreshProcessList ] ];
		yourself
]

{ #category : 'private' }
StProcessBrowser >> buildProcessToolbarActions [

	^ SpActionGroup new
		addActionWith: [ :action | action 
			name: 'Terminate';
			iconName: #stop; 
			description: 'Terminate selected process.';
			shortcutKey: $x actionModifier;
			action: [ self terminateSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		addActionWith: [ :action | action 
			name: 'Suspend';
			iconName: #pause; 
			description: 'Suspend selected process.';
			shortcutKey: $s actionModifier;
			action: [ self suspendSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		addActionWith: [ :action | action 
			name: 'Signal';
			iconName: #play;
			description: 'Signal this process semaphore.';
			shortcutKey: $s shift actionModifier;
			action: [ self signalSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		addActionWith: [ :action | action 
			name: 'Priority';
			iconName: #up; 
			description: 'Change priority of selected process.';
			shortcutKey: $p actionModifier;
			action: [ self changePriorityOfSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		addActionWith: [ :action | action 
			name: 'Debug';
			iconName: #smallDebug; 
			description: 'Debug selected process.';
			shortcutKey: $d actionModifier;
			action: [ self debugSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		"addActionWith: [ :action | action 
			name: 'Profile';
			iconName: #smallProfile; 
			description: 'Profile selected process.';
			action: [ self profileSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];"
		addActionWith: [ :action | action 
			name: 'Inspect';
			iconName: #smallInspectIt;
			description: 'Inspect selected process.';
			shortcutKey: $i actionModifier;
			action: [ self inspectSelectedProcess ];
			actionEnabled: [ self selectedProcess notNil ] ];
		yourself
]

{ #category : 'actions' }
StProcessBrowser >> changePriorityOfSelectedProcess [
	| process knownProcess newPriority |

	(process := self selectedProcess) ifNil: [ ^ self ].
	knownProcess := self nameAndRulesFor: process.
	knownProcess allowDebug 
		ifFalse: [ ^ self inform: 'Nope, won''t change priority of ', knownProcess label ].
	
	newPriority := self application newRequest
		title: 'Change priority';
		label: 'New priority';
		text: process priority asString;
		openModalWithParent: self window.
	newPriority ifNil: [ ^ self ].
	
	newPriority := newPriority asNumber asInteger.
	(newPriority between: 1 and: Processor highestPriority) 
		ifFalse: [ ^ self inform: 'Bad priority' ].
		
	process priority: newPriority.
		
	self updatePresenter
]

{ #category : 'initialization' }
StProcessBrowser >> connectPresenters [

	processListPresenter outputSelectionPort
		transmitTo: stackListPresenter defaultInputPort
		transform: [ :aProcess | self model stackListFor: aProcess ].
			
	processListPresenter outputSelectionPort 
		transmitDo: [ self updateToolbar ].
		
	stackListPresenter outputSelectionPort
		transmitDo: [ :aContext | self updateCodeFromContext: aContext ]
]

{ #category : 'private - accessing' }
StProcessBrowser >> contextToolbarActions [
	
	^ contextToolbarActions ifNil: [ contextToolbarActions := self buildContextToolbarActions ]
]

{ #category : 'actions' }
StProcessBrowser >> debugSelectedProcess [
	| process knownProcess |

	(process := self selectedProcess) ifNil: [ ^ self ].
	knownProcess := self nameAndRulesFor: process.
	knownProcess allowDebug
		ifFalse: [ ^ self inform: 'Nope, won''t debug ' , knownProcess label ].
	
	process suspendedContext ifNotNil: [ process resume ].
	process debugWithTitle: 'Interrupted from the Process Browser'
]

{ #category : 'api - focus' }
StProcessBrowser >> defaultKeyboardFocus [

	^ processListPresenter 
]

{ #category : 'layout' }
StProcessBrowser >> defaultLayout [

	^ SpBoxLayout newTopToBottom 
		add: (SpBoxLayout newLeftToRight 
				add: processToolbarPresenter;
				add: generalToolbarPresenter expand: false;
				yourself) 
			expand: false;
		add: (SpPanedLayout newTopToBottom
			"positionOfSlider: (self class defaultExtent y / 2) asInteger;"
			add: (SpPanedLayout newLeftToRight
				add: processListPresenter;
				add: stackListPresenter;
				yourself);
			add: codePresenter;
			yourself);
		yourself
]

{ #category : 'initialization' }
StProcessBrowser >> displayForContext: aContext [
	
	^ aContext method printString lines first
]

{ #category : 'initialization' }
StProcessBrowser >> displayForProcess: aProcess [
	
	cpuWatcher isRunning 
		ifTrue: [ ^ '({1}) {2} {3}' format: { aProcess priority. aProcess name. cpuWatcher runningPercentageFor: aProcess } ].
		
	^ '({1}) {2}' format: { aProcess priority. aProcess name }
]

{ #category : 'private' }
StProcessBrowser >> ensureAllWatchersAreClosed [
	
	cpuWatcher stop.
	self isAutoUpdating ifTrue: [ self stopAutoUpdate ]
]

{ #category : 'private - accessing' }
StProcessBrowser >> generalToolbarActions [	
	
	^ generalToolbarActions	 ifNil: [ generalToolbarActions := self buildGeneralToolbarActions ]
]

{ #category : 'initialization' }
StProcessBrowser >> initialize [

	super initialize.
	autoUpdating := false.
	updatingPresenters := false.
	cpuWatcher := StCPUWatcher new
]

{ #category : 'initialization' }
StProcessBrowser >> initializePresenters [

	(processToolbarPresenter := self newToolbar)
		displayMode: self application toolbarDisplayMode;
		addStyle: 'stToolbar';
		fillWith: self processToolbarActions.

	(generalToolbarPresenter := self newToolbar)
		displayMode: self application toolbarDisplayMode;
		addStyle: 'stToolbar';
		fillWith: self generalToolbarActions.
			
	(processListPresenter := self newEasyListView)
		actions: self processListActions;
		display: [ :aProcess | self displayForProcess: aProcess ].

	(stackListPresenter := self newEasyListView)
		actions: self contextToolbarActions;
		display: [ :aContext | self displayForContext: aContext ].
	
	codePresenter := self newCode.
	codePresenter enabled: false
]

{ #category : 'initialization' }
StProcessBrowser >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: self class defaultExtent;
		windowIcon: (self iconNamed: #processBrowser);
		whenClosedDo: [ self ensureAllWatchersAreClosed ]
]

{ #category : 'actions' }
StProcessBrowser >> inspectSelectedContext [

	self selectedContext inspect
]

{ #category : 'actions' }
StProcessBrowser >> inspectSelectedContextReceiver [

	self selectedContext ifNotNil: [ :aContext | aContext receiver inspect ]
]

{ #category : 'actions' }
StProcessBrowser >> inspectSelectedProcess [
	| process |

	(process := self selectedProcess) ifNil: [ ^ self ].
	process inspect
]

{ #category : 'private - testing' }
StProcessBrowser >> isAutoUpdating [

	^ autoUpdateProcess isNotNil and: [ autoUpdateProcess isSuspended  not ]
]

{ #category : 'private - testing' }
StProcessBrowser >> isAutoUpdatingPaused [

	^ autoUpdateProcess isNotNil and: [ autoUpdateProcess isSuspended ]
]

{ #category : 'private - testing' }
StProcessBrowser >> isOpen [

	self withWindowDo: [ :aWindow | ^ aWindow isOpen ].
	^ false
]

{ #category : 'accessing - model' }
StProcessBrowser >> model [

	^ model ifNil: [ model := StProcessBrowserModel new ]
]

{ #category : 'private' }
StProcessBrowser >> nameAndRulesFor: aProcess [
	"Answer a nickname and two flags: allow-stop, and allow-debug"
	aProcess == autoUpdateProcess ifTrue: [ 
		^ {
			self class autoUpdateProcessName. 
			false. 
			false } ].

	^self class nameAndRulesFor: aProcess
]

{ #category : 'private - accessing' }
StProcessBrowser >> processListActions [

	^ SpActionGroup new
		add: self processToolbarActions beDisplayedAsGroup;
		add: self generalToolbarActions beDisplayedAsGroup;
		yourself
]

{ #category : 'private - accessing' }
StProcessBrowser >> processToolbarActions [
	
	^ processToolbarActions ifNil: [ processToolbarActions := self buildProcessToolbarActions ]
]

{ #category : 'actions' }
StProcessBrowser >> refreshProcessList [

	self model updateProcessList.
	processListPresenter updateItemsKeepingSelection: self model processList
]

{ #category : 'private - accessing' }
StProcessBrowser >> selectedContext [

	^ stackListPresenter selectedItem
]

{ #category : 'private - accessing' }
StProcessBrowser >> selectedProcess [

	^ processListPresenter ifNotNil: #selectedItem
]

{ #category : 'actions' }
StProcessBrowser >> signalSelectedProcess [
	| process |

	(process := self selectedProcess) ifNil: [ ^ self ].
	[ process suspendingList signal ] fork.
	(Delay forMilliseconds: 300) wait.
	self updatePresenter
]

{ #category : 'private' }
StProcessBrowser >> startAutoUpdate [

	self isAutoUpdatingPaused ifTrue: [ ^ autoUpdateProcess resume ].
	
	self isAutoUpdating ifFalse: [
		| delay |
		delay := Delay forSeconds: 2.
		autoUpdateProcess := [ 
			[ self isOpen ]
			whileTrue: [
				delay wait.
				self updatePresenter ].
			autoUpdateProcess := nil 
		] 
		forkAt: Processor userSchedulingPriority
		named: self class autoUpdateProcessName ].
	
	self updatePresenter
]

{ #category : 'private' }
StProcessBrowser >> stopAutoUpdate [

	autoUpdateProcess ifNotNil: [
		autoUpdateProcess terminate.
		autoUpdateProcess := nil ].
	"give it time to die" 
	3 timesRepeat: [ Processor yield ].
	self updatePresenter
]

{ #category : 'actions' }
StProcessBrowser >> suspendSelectedProcess [
	| process |

	(process := self selectedProcess) ifNil: [ ^ self ].
	process suspend.
	self updatePresenter
]

{ #category : 'actions' }
StProcessBrowser >> terminateSelectedProcess [
	| process knownProcess |

	(process := self selectedProcess) ifNil: [ ^ self ].
	
	knownProcess := self nameAndRulesFor: process.
	knownProcess allowStop 
		ifFalse: [ ^ self inform: 'Nope, won''t kill ', (knownProcess label) ].
	
	process terminate.
	self updatePresenter
]

{ #category : 'actions' }
StProcessBrowser >> toggleAutoUpdate [

	updatingPresenters ifTrue: [ ^ self ].
	self updatingWhile: [ 
		autoUpdating := autoUpdating not.
		autoUpdating
			ifTrue: [ self startAutoUpdate ]
			ifFalse: [ self stopAutoUpdate ].
		autoUpdateAction presenter state: autoUpdating ]
]

{ #category : 'actions' }
StProcessBrowser >> toggleAutoUpdate: aBoolean [

	updatingPresenters ifTrue: [ ^ self ].
	self updatingWhile: [ 
		aBoolean
			ifTrue: [ self startAutoUpdate ]
			ifFalse: [ self stopAutoUpdate ] ]
]

{ #category : 'actions' }
StProcessBrowser >> toggleCPUWatcher [

	cpuWatcher isRunning 
		ifTrue: [ cpuWatcher stop ]
		ifFalse: [ cpuWatcher start ].
		
	cpuWatcherAction presenter state: cpuWatcher isRunning
]

{ #category : 'initialization' }
StProcessBrowser >> updateCodeFromContext: aContext [

	aContext ifNil: [ 
		codePresenter
			clearInteractionModel;
			text: ''; 
			enabled: false.
		^ self ].
	
	codePresenter
		enabled: true;
		beForContext: aContext;
		text: aContext method sourceCode
]

{ #category : 'initialization' }
StProcessBrowser >> updatePresenter [

	self model ifNil: [ ^ self ].
	processListPresenter updateItemsKeepingSelection: self model processList.
	self updateToolbar
]

{ #category : 'private - updating' }
StProcessBrowser >> updateToolbar [

	self processToolbarActions allCommands
		do: [ :each | each updateEnableStatus ]
]

{ #category : 'private' }
StProcessBrowser >> updatingWhile: aBlock [
	| oldUpdating |
	
	oldUpdating := updatingPresenters.
	updatingPresenters := true.
	aBlock ensure: [ 
		updatingPresenters := oldUpdating ]
]
