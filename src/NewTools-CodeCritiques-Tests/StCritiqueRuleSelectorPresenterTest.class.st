"
A CStCritiqueRuleSelectorPresenterTest is a test class for testing the behaivor of StCritiqueRuleSelectorPresenter
"
Class {
	#name : #StCritiqueRuleSelectorPresenterTest,
	#superclass : #TestCase,
	#instVars : [
		'rulesSelectorPresenter',
		'rules',
		'rulesByGroup'
	],
	#category : #'NewTools-CodeCritiques-Tests'
}

{ #category : #running }
StCritiqueRuleSelectorPresenterTest >> setUp [

	super setUp.
	rulesSelectorPresenter := StCritiqueRuleSelectorPresenter new.
	rules := (ReRuleManager visibleRuleClasses collect: [ :aClass | 
		          aClass new ]) sorted: [ :a :b | a name < b name ].
	rulesByGroup := (rules groupedBy: #group) associations collect: [ :as | 
		                CBCritiquesRuleGroup
			                named: as key
			                rules: as value ]
]

{ #category : #running }
StCritiqueRuleSelectorPresenterTest >> tearDown [ 

	super tearDown.
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testAddAll [

	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter addAllButton click.
	self assert: rulesSelectorPresenter selectedRules equals: rules asSet
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testAddSelectedComposite [

	| bugsGroup bugsRules |
	bugsGroup := rulesByGroup select: [ :item | item name = 'Bugs' ].
	bugsRules := bugsGroup first rules.
	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter list selectPath:
		(rulesSelectorPresenter list pathIndexOf: bugsGroup).
	rulesSelectorPresenter addButton click.
	self
		assert: rulesSelectorPresenter selectedRules
		equals: bugsRules asSet
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testAddSelectedSingleRule [

	| bugsGroup bugsRule |
	bugsGroup := rulesByGroup select: [ :item | item name = 'Bugs' ].
	bugsRule := bugsGroup first rules first.
	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter list selectItem: bugsRule.
	rulesSelectorPresenter addButton click.
	self
		assert: rulesSelectorPresenter selectedRules
		equals: { bugsRule } asSet
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testInitialize [

	| window |
	self assert: rulesSelectorPresenter list roots isEmpty.
	self assert: rulesSelectorPresenter selectedList roots isEmpty.
	window := rulesSelectorPresenter openWithSpec.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testOpen [

	| window |
	window := StCritiqueRuleSelectorPresenter open.
	self assert: window isBuilt.
	window close
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testRemoveAll [

	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter selectedRules: rules.
	rulesSelectorPresenter removeAllButton click.
	self assert: rulesSelectorPresenter selectedRules isEmpty
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testRemoveSelectedComposite [

	| styleGroup styleRules |
	rulesSelectorPresenter := StCritiqueRuleSelectorPresenter new.
	styleGroup := rulesByGroup select: [ :item | item name = 'Style' ].
	styleRules := styleGroup first rules.
	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter selectedList selectPath:
		(rulesSelectorPresenter selectedList pathIndexOf: styleGroup).
	rulesSelectorPresenter selectedRules: styleRules.
	rulesSelectorPresenter removeButton click.
	self assert: rulesSelectorPresenter selectedRules isEmpty
]

{ #category : #tests }
StCritiqueRuleSelectorPresenterTest >> testRemoveSelectedRule [

	| apiGroup apiRule |
	rulesSelectorPresenter := StCritiqueRuleSelectorPresenter new.
	apiGroup := rulesByGroup select: [ :item | item name = 'API Hints' ].
	apiRule := apiGroup first rules first.
	rulesSelectorPresenter items: rulesByGroup.
	rulesSelectorPresenter selectedRules: { apiRule } asSet.
	rulesSelectorPresenter selectedList selection selectItem: apiRule.
	self
		assert: rulesSelectorPresenter selectedRules
		equals: { apiRule } asSet.
	rulesSelectorPresenter removeButton click.
	self assert: rulesSelectorPresenter selectedRules isEmpty
]
