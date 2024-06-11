"
I am a presenter that provides a table for showing the rules that are stored in the file system. Also, I provide a text input field for filtering the rules according to their name
"
Class {
	#name : 'StRewriterRulesTableSelectorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'rulesTable',
		'filterTextInput'
	],
	#category : 'NewTools-RewriterTools-Widgets',
	#package : 'NewTools-RewriterTools',
	#tag : 'Widgets'
}

{ #category : 'layout' }
StRewriterRulesTableSelectorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  add: rulesTable;
		  add: filterTextInput expand: false;
		  yourself
]

{ #category : 'actions' }
StRewriterRulesTableSelectorPresenter >> filterRules: aText [

	| filteredRules |
	aText ifEmpty: [
		rulesTable items: self getRules.
		^ self ].
	filteredRules := self getRules select: [ :aRuleHolder |
		(aRuleHolder name includesSubstring: aText caseSensitive: false) or: [
			(aRuleHolder lhs includesSubstring: aText caseSensitive: false) or: [
				aRuleHolder rhs includesSubstring: aText caseSensitive: false ] ] ].
	rulesTable items: filteredRules
]

{ #category : 'accessing' }
StRewriterRulesTableSelectorPresenter >> getRules [

	^ StRewriterDemoRules demoRules
]

{ #category : 'initialization' }
StRewriterRulesTableSelectorPresenter >> initializeFiltering [

	filterTextInput := self newTextInput.
	filterTextInput
		placeholder: 'Filter...';
		whenTextChangedDo: [ :aText | self filterRules: aText ]
]

{ #category : 'initialization' }
StRewriterRulesTableSelectorPresenter >> initializePresenters [

	self initializeTable.
	self initializeFiltering
]

{ #category : 'initialization' }
StRewriterRulesTableSelectorPresenter >> initializeTable [

	| lhsTableColumn ruleNameTableColumn hashtagTableColumn rhsTableColumn |
	rulesTable := self newTable.
	hashtagTableColumn := (SpIndexTableColumn title: '#')
		                      width: 20;
		                      yourself.
	ruleNameTableColumn := SpStringTableColumn
		                       title: 'Rule name'
		                       evaluated: [ :rule | rule name ].
	lhsTableColumn := SpStringTableColumn
		                  title: 'Search for'
		                  evaluated: [ :rule | rule lhs ].
	rhsTableColumn := SpStringTableColumn
		                  title: 'Replace with'
		                  evaluated: [ :rule | rule rhs ].
	rulesTable
		items: self getRules;
		sortingBlock: [ :a :b |
			a name < b name ];
		addColumn: hashtagTableColumn;
		addColumn: ruleNameTableColumn;
		addColumn: lhsTableColumn;
		addColumn: rhsTableColumn;
		beMultipleSelection
]

{ #category : 'api' }
StRewriterRulesTableSelectorPresenter >> lhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first lhs ]
]

{ #category : 'api' }
StRewriterRulesTableSelectorPresenter >> rhs [

	^ self selectedRules
		ifEmpty: [ '' ]
		ifNotEmpty: [ :f |self selectedRules first rhs ]
]

{ #category : 'api' }
StRewriterRulesTableSelectorPresenter >> selectedRules [

	^ rulesTable selectedItems
]
