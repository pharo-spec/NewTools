"
I am a tool that allows you to match and test a pattern code with Pharo's code. To open me: `MatchToolPresenter open`

Write the pattern's code and the Pharo's code in the code editors and then press the 'Match' button. After that, I will match all ocurrences of the pattern code on the Pharo's code.

- The middle column shows all the occurrences that the pattern code has in the Pharo's code.
- The right column shows all the bindings of the selected matched of the middle column.
"
Class {
	#name : #StRewriterMatchToolPresenter,
	#superclass : #StPresenter,
	#instVars : [
		'executeButton',
		'ruleEditor',
		'codeEditor',
		'bindingsTable',
		'matchesList',
		'codeLabel',
		'methodCheckbox',
		'astPattern',
		'astCode'
	],
	#category : #'NewTools-RewriterTools-MatchTool'
}

{ #category : #accessing }
StRewriterMatchToolPresenter class >> descriptionText [
	^ 'MatchTool is a simple UI for experimenting with the matching functionality of a rewrite rule'
]

{ #category : #accessing }
StRewriterMatchToolPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : #accessing }
StRewriterMatchToolPresenter class >> iconName [

	| iconContent |
	iconContent := 'iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAIAAACQkWg2AAABx0lEQVQokWVSTWsTURQ9972ZpkSwpC0RN4GU0oWiqy7cVZD+AD/+gb/Hf+BKXSp04aaCS8WKViKlBARLCTSlIabEJjOZefceF5mJaXvhvdU9555z75H1xpaZJ0kzGLIs3Xz2fOPRk0mamMKMSqjBSDUa6YAYZRH03h/svh0c/3LeAwBk+kQEAgAOV0pcOhx8f/fS8hwiJRFIAiB5DQD4aOG03er8+OyjeAqZfSLiZlAAVDUNcM5FcXLek2k7L9FFhRARDaHWWLu7/bS6vEqJFmt1zbOCeg4TiUhBb3Zv+3HzwcM0TVWZa6Cy1AMRwACgkAQA5Hg40JBbCKYKEiLORyWkKCflKuBcp7WnWVaKdGGSdg+/achE3My7r91szmxc9HurzY2l2w0N6hcqB+/ffH39gqr1O5tmRpKcnwDQdH/n1d+zk7iyeNZu/f60G1eqx18+DE+OnI+mfX55aa2wQYq48Xm/83Ove7jf/riTj0cS+TAZV1fqK+v3LQTO1jpT5XyUDPqj3ql4L94Z6UT+HLWpAQB5ORrTUeKci+O5ZfhRvxsmyTQpV6Mxb0nK2GUXwzwZiYjxGuD/WYr7UkQsZGGSELh1w/4BoVf8Blsi4TsAAAAASUVORK5CYII='.
	self theme icons icons
		at: #jigsawIcon
		ifAbsentPut: [
		Form fromBinaryStream: iconContent base64Decoded readStream ].

	^ #jigsawIcon
]

{ #category : #menu }
StRewriterMatchToolPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Match Tool')
		action: [ self new open ];
		order: 32;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : #specs }
StRewriterMatchToolPresenter class >> title [

	^ 'Match Tool'
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> connectPresenters [

	matchesList
		whenSelectionChangedDo: [ :selection |
			self selectedMatchChanged: selection ];
		whenModelChangedDo: [ :newItems | self matchesChanged ].
	executeButton action: [ self performMatching ]
]

{ #category : #layout }
StRewriterMatchToolPresenter >> defaultLayout [

	| rulePanel codePanel matchesWithLabelPanel |
	rulePanel := SpBoxLayout newTopToBottom
		add: (SpBoxLayout newLeftToRight
			add: methodCheckbox expand: false;
			addLast: executeButton expand: false;
			yourself)
		expand: false;
		add: ruleEditor;
		yourself.
	codePanel := SpBoxLayout newTopToBottom
		add: codeLabel expand: false;
		add: codeEditor;
		yourself.
	matchesWithLabelPanel := SpBoxLayout newTopToBottom
		add: 'Matches' expand: false;
		add: matchesList;
		yourself.

	^ SpPanedLayout newLeftToRight
		add: (SpPanedLayout newTopToBottom
			add: rulePanel;
			add: codePanel;
			yourself);
		add: (SpPanedLayout newLeftToRight
			add: matchesWithLabelPanel;
			add: bindingsTable;
			yourself);
		yourself
]

{ #category : #actions }
StRewriterMatchToolPresenter >> emptyLists [

	bindingsTable items: #(  ).
	matchesList items: #(  )
]

{ #category : #defaults }
StRewriterMatchToolPresenter >> getBindingsItemsForMatch: bindingsAssociation [

	| newItems |
	newItems := OrderedCollection new.
	bindingsAssociation keysAndValuesDo: [ :key :value |
		(value isKindOf: OrderedCollection)
			ifTrue: [ newItems add: (value collect: [ :each | key -> each ]) ]
			ifFalse: [ newItems add: key -> value ] ].
	^ newItems flattened
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> initializeButtons [

	executeButton := self newButton.
	executeButton
		icon: (self iconNamed: #smallDoIt);
		label: 'Match';
		shortcut: Character cr meta
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> initializeEditors [

	methodCheckbox := self newCheckBox label: 'The rule is for a method?'.

	codeLabel := self newLabel label: 'Pharo code'.

	codeEditor := self newCode.
	codeEditor
		withoutLineNumbers;
		beForScripting;
		text: StRewriterDemoRules defaultRule pharoCode.

	ruleEditor := self instantiate: StRewriterSearchForPanelPresenter
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> initializeMatchesPresenters [

	matchesList := self newList.
	matchesList display: [ :assoc | assoc key formattedCode ].

	bindingsTable := self newTable.
	bindingsTable
		addColumn: (SpStringTableColumn
			title: 'Pattern'
			evaluated: [ :assoc | assoc key formattedCode ]);
		addColumn: (SpStringTableColumn
			title: 'Bindings'
			evaluated: [ :assoc | assoc value formattedCode ]);
		beResizable
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> initializePresenters [

	self initializeEditors.
	self initializeButtons.
	self initializeMatchesPresenters
]

{ #category : #initialization }
StRewriterMatchToolPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 800 @ 450;
		windowIcon: self class icon;
		askOkToClose: false;
		aboutText: self class descriptionText
]

{ #category : #'event handling' }
StRewriterMatchToolPresenter >> matchesChanged [

	bindingsTable items: #(  ).
	matchesList unselectAll
]

{ #category : #accessing }
StRewriterMatchToolPresenter >> patternCode [

	^ ruleEditor lhs
]

{ #category : #accessing }
StRewriterMatchToolPresenter >> patternCode: aPatternCode [

	ruleEditor lhs: aPatternCode
]

{ #category : #actions }
StRewriterMatchToolPresenter >> performMatching [

	| matches |
	self emptyLists.

	matches := StRewriterPatternMatcher
		performMatching: codeEditor text
		pattern: ruleEditor lhs
		isForMethod: methodCheckbox state.

	matchesList items: matches
]

{ #category : #accessing }
StRewriterMatchToolPresenter >> pharoCode [

	^ codeEditor text
]

{ #category : #accessing }
StRewriterMatchToolPresenter >> pharoCode: aPharoCode [

	codeEditor text: aPharoCode
]

{ #category : #'event handling' }
StRewriterMatchToolPresenter >> selectedMatchChanged: selection [

	| selectedMatch |
	selectedMatch := selection selectedItem.
	selectedMatch
		ifNil: [
			bindingsTable items: #(  ).
			codeEditor clearSelection ]
		ifNotNil: [
			bindingsTable items: (self getBindingsItemsForMatch: selectedMatch value).
			codeEditor selectionInterval: selectedMatch key sourceInterval ]
]
