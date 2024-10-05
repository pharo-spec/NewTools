"
I am a controller used by the ProfilerPresenter to interact with different kinds of profiler models
"
Class {
	#name : 'StProfilerModel',
	#superclass : 'MorphTreeModel',
	#instVars : [
		'profilerClass',
		'showLeavesOnly',
		'showNodeThreshold',
		'profiler',
		'tallyRoot',
		'isProfiling'
	],
	#category : 'NewTools-ProfilerUI-Model',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Model'
}

{ #category : 'constants' }
StProfilerModel >> allProfilerClasses [

	^ {
		  AndreasSystemProfiler.
		  TimeProfiler".
		  PreciseProfiler" }
]

{ #category : 'announce' }
StProfilerModel >> announceProfilingFinished [

	^ self announcer announce: StProfilingFinishedAnnouncement new
]

{ #category : 'announce' }
StProfilerModel >> announceProfilingStarted [
	self announcer announce: StProfilingStartedAnnouncement new
]

{ #category : 'accessing nodes' }
StProfilerModel >> announceRootChanged: aTallyModel [

	self announcer announce:
		(StProfilerResultsTreeRootChangedAnnouncement new item: aTallyModel)
]

{ #category : 'announce' }
StProfilerModel >> announceSelectionChanged: aTallyModel [

	self announcer announce:
		(StProfilerResultsTreeSelectionChangedAnnouncement new item:
			 aTallyModel)
]

{ #category : 'event handling' }
StProfilerModel >> browseItem [
	self selectedNode ifNotNil: [:current | current browseItem ]
]

{ #category : 'constants' }
StProfilerModel >> doItSourceCodeFrom: someCode [

	^ 'self forkProfileBlock: [' , someCode , ' ]'
]

{ #category : 'api' }
StProfilerModel >> forkProfileBlock: aBlock [
	"Fork is used to get a more clean execution results tree"

	[
	self announceProfilingStarted.
	self startProfiling.
	[ profiler runBlock: aBlock ] ensure: [
		self stopProfiling.
		self announceProfilingFinished ] ] fork
]

{ #category : 'api' }
StProfilerModel >> hideNodesUnder: aNumber [
	"minimum percentage a node must have to be shown"
	showNodeThreshold := aNumber
]

{ #category : 'initialization' }
StProfilerModel >> initialize [
	super initialize.
	showLeavesOnly := false.
	showNodeThreshold := 0
]

{ #category : 'accessing' }
StProfilerModel >> isProfiling [
	^ isProfiling ifNil: [ isProfiling := false ]
]

{ #category : 'event handling' }
StProfilerModel >> keyDown: aKeyboardEvent from: aMorphTreeListManager [
	self selectedNode ifNotNil: [:current | current keyDown: aKeyboardEvent from: aMorphTreeListManager ]
]

{ #category : 'accessing nodes' }
StProfilerModel >> leaveItems [
	| res  |
	res := OrderedCollection new.
	self tallyRoot
		ifNotNil: [
			| dict |
			dict := IdentityDictionary new: 100.
			self tallyRoot leavesInto: dict fromSender: nil.
			res addAll: (dict asOrderedCollection sort reverse)].
	^ res
]

{ #category : 'accessing nodes' }
StProfilerModel >> leaveItemsOver: perCent [

	| leaveThreshold |
	self tallyRoot ifNil: [ ^ #() ].
	leaveThreshold := (perCent asFloat / 100 * self tallyRoot tally) rounded.
	^ self leaveItems select: [ :item | item tally > leaveThreshold ]
]

{ #category : 'accessing' }
StProfilerModel >> menu: menu shifted: b [
	"Set up the menu to apply to the receiver's, honoring the #shifted boolean"

	self selectedNode
		ifNotNil: [ :current |
			current menu: menu shifted: b.
			menu addLine.
			(menu
				add: 'Expand all from here'
				target: self
				selector: #expandAllFromNode:
				argument: current) icon: (self iconNamed: #windowMenuInactive).
			menu addLine.
			(menu
				add: 'Show as root'
				target: self
				selector: #setTallyRoot:
				argument: current)
				icon: (self iconNamed: #redo) ].
	^ menu
]

{ #category : 'factory' }
StProfilerModel >> newProfiler [
	^ self profilerClass new
]

{ #category : 'api' }
StProfilerModel >> profileBlock: aBlock [

	self resetProfiler.

	self forkProfileBlock: aBlock
]

{ #category : 'api' }
StProfilerModel >> profileCode: someCode notifying: requestor [

	| compiledMethod compiler |
	self resetProfiler.
	compiler := Smalltalk compiler
		            source: (self doItSourceCodeFrom: someCode);
		            requestor: requestor;
		            isScripting: true;
		            permitUndeclared: true;
		            failBlock: [ ^ self ];
		            yourself.
	compiledMethod := [ compiler compile ]
		                  on: OCUndeclaredVariableWarning
		                  do: [
			                  SpPresenter new alert:
				                  'They are undeclared variables!'.
			                  ^ self ].
	compiledMethod valueWithReceiver: self
]

{ #category : 'accessing' }
StProfilerModel >> profiler: aProfiler [

	profiler := aProfiler
]

{ #category : 'accessing' }
StProfilerModel >> profilerClass [
	^ profilerClass ifNil: [ profilerClass := self allProfilerClasses at: 1 ]
]

{ #category : 'accessing' }
StProfilerModel >> profilerClass: aClass [
	profilerClass := aClass
]

{ #category : 'reporting' }
StProfilerModel >> report [

	^ profiler report
]

{ #category : 'private' }
StProfilerModel >> resetProfiler [

	self isProfiling ifTrue: [ profiler stopProfiling ].
	profiler := self newProfiler
]

{ #category : 'accessing' }
StProfilerModel >> rootItem [
	^ self tallyRoot
]

{ #category : 'accessing' }
StProfilerModel >> rootItems [
	self tallyRoot ifNil: [ ^#() ].

	^ showLeavesOnly
		  ifTrue: [ self leaveItemsOver: showNodeThreshold ]
		  ifFalse: [ {self tallyRoot asTallyModel
			  							model: self;
			  							yourself} ]
]

{ #category : 'accessing' }
StProfilerModel >> rootNodeFromItem: anItem [

	^ anItem asTallyModel
]

{ #category : 'accessing' }
StProfilerModel >> rootNodes [

	profiler ifNil: [ ^ nil ].
	^ super rootNodes
]

{ #category : 'accessing nodes' }
StProfilerModel >> rootTallyItems [

	^ self rootTallyItemsOver: 0
]

{ #category : 'accessing nodes' }
StProfilerModel >> rootTallyItemsOver: perCent [
	| minTally |
	self tallyRoot ifNil: [ ^ #() ].
	minTally := (perCent asFloat / 100 * self tallyRoot tally) rounded.

	^ (self tallyRoot sonsOver: minTally)
		ifEmpty: [ #() ]
		ifNotEmpty: [:sons | sons asOrderedCollection sort reverse ]
]

{ #category : 'private' }
StProfilerModel >> runBlock: aBlock [

	^ profiler runBlock: aBlock
]

{ #category : 'accessing nodes' }
StProfilerModel >> setTallyRoot: aTallyModel [

	tallyRoot = aTallyModel ifTrue: [ ^ self ].
	tallyRoot := aTallyModel.
	self announceRootChanged: tallyRoot
]

{ #category : 'accessing' }
StProfilerModel >> showLeavesOnly [

	^ showLeavesOnly
]

{ #category : 'accessing' }
StProfilerModel >> showLeavesOnly: anObject [

	showLeavesOnly := anObject.
	self announceRootChanged: tallyRoot
]

{ #category : 'accessing' }
StProfilerModel >> showNodeThreshold [
	^ showNodeThreshold
]

{ #category : 'profiling' }
StProfilerModel >> startProfiling [

	isProfiling := true.
	tallyRoot := nil.
	profiler startProfiling
]

{ #category : 'profiling' }
StProfilerModel >> stopProfiling [

	profiler stopProfiling.
	self setTallyRoot: (profiler tallyRoot asTallyModel
		             model: self;
		             yourself).
	isProfiling := false
]

{ #category : 'accessing nodes' }
StProfilerModel >> tallyRoot [
	^ tallyRoot
]

{ #category : 'accessing' }
StProfilerModel >> total [
	^ self tallyRoot tally
]

{ #category : 'accessing' }
StProfilerModel >> totalTally [
	^ self tallyRoot tally
]

{ #category : 'accessing' }
StProfilerModel >> totalTime [
	^ profiler totalTime
]
