Class {
	#name : 'StSindarinDebuggerPresenter',
	#superclass : 'StPresenterWithModel',
	#instVars : [
		'currentNodeSource',
		'stack',
		'inspector',
		'toolbar'
	],
	#category : 'NewTools-Sindarin-Tools-Presenters',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Presenters'
}

{ #category : 'layout' }
StSindarinDebuggerPresenter class >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: #toolbar expand: false;
		add:
			(SpPanedLayout newTopToBottom
				add: #stack;
				add:
					(SpPanedLayout newLeftToRight
						add: #inspector;
						add: #currentNodeSource;
						yourself);
				yourself);
		yourself
]

{ #category : 'initialization' }
StSindarinDebuggerPresenter >> buildToolbar [

	| group |
	group := CmCommandGroup forSpec.
	(SindarinCommand allSubclasses reject: #isAbstract) do: [ :cmd |
		group register: (cmd forSpecContext: self) ].
	^ self newToolbar
		  displayMode: self application toolbarDisplayMode;
		  addStyle: 'stToolbar';
		  fillWith: group
]

{ #category : 'initialization' }
StSindarinDebuggerPresenter >> initializePresenters [

	stack := self newList.
	stack whenSelectionChangedDo: [ :selection |
			selection selectedItem
				ifNil: [
						inspector model: nil.
						currentNodeSource text: '' ]
				ifNotNil: [
						| node |
						node := selection selectedItem sourceNodeExecuted.
						inspector model: node.
						inspector setAttributeTable.
						currentNodeSource text: node source.
						currentNodeSource beForBehavior: node methodNode methodClass.
						currentNodeSource selectionInterval: (node start to: node stop).
						currentNodeSource
							doItReceiver: selection selectedItem home receiver;
							doItContext: selection selectedItem ] ].
	inspector := StRawInspectionPresenter on: self model stack first.
	currentNodeSource := self newCode.
	currentNodeSource whenBuiltDo: [ :ann |
		ann widget font: StandardFonts codeFont ].
	currentNodeSource withSyntaxHighlight.
	currentNodeSource text: self model node source.
	currentNodeSource beForBehavior: self model method methodClass.
	stack items: self model stack.
	stack selectIndex: 1.
	toolbar := self buildToolbar
]

{ #category : 'stepping' }
StSindarinDebuggerPresenter >> refresh [

	stack items: self model stack.
	stack selectIndex: 1
]

{ #category : 'stepping' }
StSindarinDebuggerPresenter >> stepIn [

	self model step.
	self refresh
]

{ #category : 'stepping' }
StSindarinDebuggerPresenter >> stepOver [

	self model stepOver.
	self refresh
]

{ #category : 'stepping' }
StSindarinDebuggerPresenter >> windowTitle [

	^ 'Sindarin Debugger'
]
