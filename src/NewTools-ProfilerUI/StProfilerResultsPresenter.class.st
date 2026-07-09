"
I am a panel in the ProfilerPresenter containing the profiling process results together with parameters to filter these results
"
Class {
	#name : 'StProfilerResultsPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'treeTable',
		'viewModel',
		'codePresenter',
		'browseButton',
		'treeDropList',
		'expandAllButton',
		'collapseAllButton',
		'thresholdFilterInput',
		'thresholdExpandInput',
		'navigationToolbar',
		'reportButton',
		'showAsRootButton'
	],
	#category : 'NewTools-ProfilerUI-Presenters',
	#package : 'NewTools-ProfilerUI',
	#tag : 'Presenters'
}

{ #category : 'initialization' }
StProfilerResultsPresenter >> connectPresenters [

	super connectPresenters.

	treeTable whenSelectedItemChangedSend: #handleSelectionChanged to: self.

	thresholdExpandInput whenTextChangedDo: [ :text | text asInteger ifNotNil: [ treeTable expandNodesOver: text asNumber ] ].

	thresholdFilterInput whenTextChangedDo: [ :text | text asInteger ifNotNil: [ treeTable hideNodesUnder: text asNumber ] ].

	treeDropList whenSelectedItemChangedDo: [ :item | viewModel showLeavesOnly: item value ]
]

{ #category : 'layout' }
StProfilerResultsPresenter >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  positionOfSlider: 50 percent;
		  add: (SpBoxLayout newTopToBottom
				   add: navigationToolbar expand: false;
				   add: treeTable;
				   yourself);
		  add: (SpBoxLayout newTopToBottom
				   add: (SpBoxLayout newTopToBottom
						    add: (SpBoxLayout newLeftToRight
								     add: treeDropList;
								     add: expandAllButton expand: false;
								     add: collapseAllButton expand: false;
								     yourself);
						    add: (SpBoxLayout newLeftToRight
								     add: 'Hide nodes under (%): ' expand: false;
								     add: thresholdFilterInput width: 55;
								     add: 'Expand nodes over (%): ' expand: false;
								     add: thresholdExpandInput width: 55;
								     yourself);
						    yourself)
				   expand: false;
				   add: codePresenter;
				   add: (SpBoxLayout newLeftToRight
						    add: reportButton withConstraints: [ :constraints |
								    constraints
									    bePlacedAtStart;
									    fill: true;
									    expand: false ];
						    addLast: showAsRootButton;
						    addLast: browseButton)
				   expand: false;
				   yourself);
		  yourself
]

{ #category : 'private' }
StProfilerResultsPresenter >> doItNode [

	| talliesPathToExpand actualNodeInTree |
	talliesPathToExpand := Stack withAll:
		                       (viewModel tallyRoot
			                        detectPathOfMethodSelector: 'DoIt'
			                        maxDepth: 10).

	talliesPathToExpand ifEmpty: [ ^ nil ].

	actualNodeInTree := nil.

	treeTable expandAllSuchThat: [ :item |
		(talliesPathToExpand isNotEmpty and: [
			 item = talliesPathToExpand top and: [ item hasContents ] ])
			ifTrue: [
				talliesPathToExpand pop.
				talliesPathToExpand ifEmpty: [ actualNodeInTree := item ].
				true ]
			ifFalse: [ false ] ].

	^ actualNodeInTree
]

{ #category : 'event handling' }
StProfilerResultsPresenter >> handleProfilingFinished [

	| doItNode |
	self defer: [
		self enabled: true.

		viewModel showLeavesOnly ifFalse: [ "select do it node and expand tree"
			doItNode := self doItNode.
			doItNode
				ifNil: [
					self inform:
						'The excecution time was too short! No measurements taken' ]
				ifNotNil: [
					treeTable selectPath: doItNode path scrollToSelection: true.
					viewModel setTallyRoot: doItNode ] ].
		viewModel announcer announce:
			StProfilingResultsDisplayedAnnouncement new ]
]

{ #category : 'event handling' }
StProfilerResultsPresenter >> handleProfilingStarted [
	self enabled: false.
	navigationToolbar reset
]

{ #category : 'event handling' }
StProfilerResultsPresenter >> handleSelectionChanged [

	| navButton node |
	node := treeTable selectedItem.

	node
		ifNil: [
				browseButton disable.
				showAsRootButton disable.
				codePresenter
					text: '';
					clearInteractionModel ]
		ifNotNil: [
				| methodOrBlock |
				methodOrBlock := node methodOrBlock.
				browseButton enable.
				showAsRootButton enable.

				codePresenter
					text: methodOrBlock sourceCode;
					beForMethod: methodOrBlock originMethod.

				methodOrBlock isCompiledBlock
					ifTrue: [
							codePresenter addTextSegmentDecoration: (SpTextPresenterDecorator forHighlight
									 interval: (methodOrBlock sourceNode sourceInterval first to: methodOrBlock sourceNode sourceInterval last + 1);
									 yourself) ]
					ifFalse: [ codePresenter removeAllTextSegmentDecorations ] ].

	navButton := navigationToolbar selectedItem.
	navButton ifNil: [ ^ self ].
	navButton selectedObject: node
]

{ #category : 'event handling' }
StProfilerResultsPresenter >> handleTreeRootChanged: event [

	| nodeToSelect pathToSelect |
	self assert: event item == viewModel tallyRoot.

	treeTable roots: viewModel rootItems.
	self assert: treeTable selectedItem isNil.

	navigationToolbar setSelectedItem:
		(navigationToolbar ensureItemWith: viewModel tallyRoot).

	nodeToSelect := navigationToolbar selectedItem
		                ifNil: [ event item ]
		                ifNotNil: [ :btn |
		                btn selectedObject ifNil: [ event item ] ].

	pathToSelect := viewModel showLeavesOnly
		                ifTrue: [ nodeToSelect path ]
		                ifFalse: [ nodeToSelect relativePath ].

	viewModel showLeavesOnly ifFalse: [
		treeTable expandAllSuchThat: [ :node |
			node weightToRoot asFloat closeTo: 100.0 ].
		treeTable expandPath: pathToSelect ].

	treeTable selectPath: pathToSelect scrollToSelection: true
]

{ #category : 'initialization' }
StProfilerResultsPresenter >> initializeActions [

	| pres |
	"Report"
	reportButton action: [
			pres := self newText
				        text: viewModel report;
				        open.
			pres withWindowDo: [ :w | w title: 'Profiling Report' ] ].

	collapseAllButton action: [
			treeTable collapseAll.
			treeTable takeKeyboardFocus ].
	"Configuration section actions"

	expandAllButton action: [
			treeTable expandAll.
			treeTable takeKeyboardFocus ]
]

{ #category : 'initialization' }
StProfilerResultsPresenter >> initializePresenters [

	super initializePresenters.
	navigationToolbar := self instantiate: StProfilerToolbarPresenter.
	treeTable := self instantiate: StProfilerTreeTablePresenter on: viewModel.
	codePresenter := self newCode.
	reportButton := self newButton.
	showAsRootButton := self newButton.
	browseButton := self newButton.
	treeDropList := self newTreeVisualizationDropList.
	expandAllButton := self newButton.
	collapseAllButton := self newButton.
	thresholdFilterInput := self newThresholdFilterInput.
	thresholdExpandInput := self newThresholdExpandInput.

	collapseAllButton
		label: 'Collapse All';
		icon: (self iconNamed: #windowMinimize).

	expandAllButton
		label: 'Expand All';
		icon: (self iconNamed: #windowMenu).

	codePresenter beNotEditable.

	reportButton
		icon: (self iconNamed: #recentMessages);
		label: 'Full Report';
		disable.

	showAsRootButton
		icon: (self iconNamed: #redo);
		label: 'Show node as root';
		action: [ viewModel setTallyRoot: treeTable selectedItem ];
		disable.

	browseButton
		icon: (self iconNamed: #browse);
		label: 'Browse';
		disable;
		action: [ treeTable selectedItem browseItem ].

	self initializeActions
]

{ #category : 'private - factory' }
StProfilerResultsPresenter >> newProfilerNumberInput [
	^ self instantiate: StProfilerNumberInput
]

{ #category : 'private - factory' }
StProfilerResultsPresenter >> newThresholdExpandInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be expanded';
		  number: 0;
		  yourself
]

{ #category : 'private - factory' }
StProfilerResultsPresenter >> newThresholdFilterInput [

	^ self newProfilerNumberInput
		  help: 'Only nodes with a percentage of time greater than this threshold will be shown';
		  number: viewModel showNodeThreshold;
		  yourself
]

{ #category : 'private - factory' }
StProfilerResultsPresenter >> newTreeVisualizationDropList [
	| items |
	items := {
		         ('Full tree' -> false).
		         ('Leaves only' -> true) }.

	^ self newDropList
		                help: 'Results visualization mode';
		                items: items;
		                selectItem: (viewModel showLeavesOnly
				                 ifTrue: [ items at: 2 ]
				                 ifFalse: [ items at: 1 ]);
		                display: [ :assoc | assoc key ];
		                yourself
]

{ #category : 'accessing - model' }
StProfilerResultsPresenter >> setModelBeforeInitialization: aDomainObject [

	viewModel := aDomainObject
]

{ #category : 'subscription' }
StProfilerResultsPresenter >> subscribeOnProfilingAnnouncements [

	viewModel announcer
		when: StProfilingStartedAnnouncement send: #handleProfilingStarted to: self;
		when: StProfilingFinishedAnnouncement send: #handleProfilingFinished to: self;
		when: StProfilerResultsTreeRootChangedAnnouncement send: #handleTreeRootChanged: to: self
]

{ #category : 'subscription' }
StProfilerResultsPresenter >> unsubscribeFromProfilingAnnouncements [

	viewModel announcer unsubscribe: self
]

{ #category : 'accessing' }
StProfilerResultsPresenter >> viewModel [

	^ viewModel
]
