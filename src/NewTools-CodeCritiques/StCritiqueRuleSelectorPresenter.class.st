"
I am a presenter that allows to select items from a list of rules organized by group in my left column and put that items on a selected list in my rigth column. I support selection for SpTreeTablePresenter. 

If you click on '>', I can add a group rules or a singe rule to selected list.
If you click on '<', I can remove a group rules or a singe rule from selected list.

If you click on 'Next', I will open the StCritiqueBrowserPresenter.
I send selected rules from selected list to StCritiqueBrowserPresenter. 

You can open me whit:
`StCritiqueRuleSelectorPresenter open`

"
Class {
	#name : 'StCritiqueRuleSelectorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'selectedList',
		'selectedItems',
		'list',
		'addAllButton',
		'methodName',
		'addButton',
		'removeAllButton',
		'buttonBar',
		'removeButton',
		'items',
		'nextButton',
		'selectedRules',
		'environment',
		'removeTestCase'
	],
	#category : 'NewTools-CodeCritiques-Applier',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Applier'
}

{ #category : 'instance creation' }
StCritiqueRuleSelectorPresenter class >> defaultPreferredExtent [ 
	
	^ 450 @ 360
]

{ #category : 'instance creation' }
StCritiqueRuleSelectorPresenter class >> items [

	| rules rulesByGroup |
	rules := (ReRuleManager visibleRuleClasses collect: [ :aClass | 
		          aClass new ]) sorted: [ :a :b | a name < b name ].
	rulesByGroup := (rules groupedBy: #group) associations collect: [ :as | 
		                CBCritiquesRuleGroup
			                named: as key
			                rules: as value ].
	rulesByGroup sort: [ :a :b | a name < b name ].
	^ rulesByGroup
]

{ #category : 'instance creation' }
StCritiqueRuleSelectorPresenter class >> open [

	<example>
	| packages env |
	packages := self packageOrganizer packages.
	env := RBPackageEnvironment new packages: packages.
	^ (self openWithEnvironment: env removeTestCase: false)
]

{ #category : 'instance creation' }
StCritiqueRuleSelectorPresenter class >> openWithEnvironment: anEnvironment removeTestCase: aBoolean [

	^ self new
		items: self items;
		environment: anEnvironment;
		removeTestCase: aBoolean;
		updateTree;
		open
		
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> addAll [

	selectedList roots do: [ :group | selectedRules addAll: group rules ].
	self update.
	nextButton enabled: selectedRules isNotEmpty.
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> addAllButton [

	^ addAllButton
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> addButton [

	^ addButton
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> addSelected [

	list selectedItem ifNotNil: [ :item | 
		item isComposite
			ifFalse: [ selectedRules add: item ]
			ifTrue: [ selectedRules addAll: item rules ] ].
	self update.
	nextButton enabled: selectedRules isNotEmpty.
]

{ #category : 'layout' }
StCritiqueRuleSelectorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		add: (SpBoxLayout newTopToBottom
			spacing: 5;
		  	add: (SpPanedLayout newLeftToRight
				add: (SpBoxLayout newLeftToRight
					spacing: 5;
					add: list;
					add: buttonBar expand: false;
					yourself);
				add: selectedList;
				yourself);
		  yourself);
 		add: (SpBoxLayout newLeftToRight
				addLast: nextButton;
				yourself)
 			expand: false;
 		yourself
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> environment: aEnviroment [

	environment := aEnviroment
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> groupRules [
	^ #(
	#'API Change'
	#'API Hints'
	#'Architectural'
	#'Bugs'
	#'Coding Idiom Violation'
	#'Design Flaws'
	#'Optimization'
	#'Potential Bugs'
	#'Rubric'
	#'SUnit'
	#'Style'
	#'Unclassified rules'  )
]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializeButtonBar [

	buttonBar := SpBoxLayout newTopToBottom
		vAlignStart;
		hAlignCenter;
		spacing: 3;
		add: self addButton;
		add: self addAllButton;
		add: self removeButton;
		add: self removeAllButton;
		yourself
]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializeButtons [

	addButton := self newButton
				addStyle: 'small';
				label: '>';
				action: [ self addSelected ];
				yourself.

	addAllButton := self newButton
				addStyle: 'small';
				label: '>>';
				action: [ self addAll ];
				yourself.

	removeButton := self newButton
				addStyle: 'small';
				label: '<';
				action: [ self removeSelected ];
				yourself.

	removeAllButton := self newButton
				addStyle: 'small';
				label: '<<';
				action: [ self removeAll ];
				yourself
]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializeList [
	| rulesToSelectChildrenBlock |
	
	list := self newTree.

	rulesToSelectChildrenBlock := [ :rule | 
	                              rule isComposite
		                              ifTrue: [ 
			                              rule rules select: [ :r | 
				                              (self isSelected: r) not or: [ 
					                              r isComposite ] ] ]
		                              ifFalse: [ #(  ) ] ].
	list children: rulesToSelectChildrenBlock.
	list display: [ :rule | rule name ].

]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializeNextButton [

	nextButton := self newButton.
	nextButton
		icon: (self iconNamed: #smallOk);
		label: 'Next';
		enabled: false;
		action: [ self nextAction ]
]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializePresenters [

	self initializeList.
	self initializeSelectedList.
	self initializeButtons.
	self initializeButtonBar.
	self initializeNextButton
]

{ #category : 'initialization' }
StCritiqueRuleSelectorPresenter >> initializeSelectedList [
	| selectedRulesChildrenBlock |
	
	selectedList := self newTree.

	selectedRules := Set new.
	selectedRulesChildrenBlock := [ :rule | 
	                              rule isComposite
		                              ifTrue: [ 
			                              rule rules select: [ :r | 
				                              (self isSelected: r) or: [ 
					                              r isComposite ] ] ]
		                              ifFalse: [ #(  ) ] ].

	selectedList children: selectedRulesChildrenBlock.
	selectedList display: [ :rule | rule name ].
	
	selectedList whenSelectionChangedDo: [ :aSelection | 
		self updateButtonsState: aSelection ].
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> isSelected: aRule [

	"Check the rule identifier to not run twice the same rule"

	^ selectedRules anySatisfy: [ :rule | 
		  rule class uniqueIdentifierName = aRule class uniqueIdentifierName ]
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> items: aCollection [

	list roots: aCollection.
	selectedList roots: aCollection
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> list [
	
	^ list
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> list: anObject [

	list := anObject
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> methodName [

	^ methodName
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> nextAction [

	self delete.

	CBCritiqueWorkingConfiguration current
		rule: selectedRules;
		environment: environment;
		removeTestCase: removeTestCase.
	StCritiqueBrowserPresenter openOnWorkingConfiguration:
		CBCritiqueWorkingConfiguration current
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> removeAll [

	selectedList roots do: [ :item | 
		selectedRules removeAllFoundIn: item value ].
	self update.
	nextButton enabled: selectedRules isNotEmpty
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> removeAllButton [

	^ removeAllButton
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> removeButton [

	^ removeButton
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> removeSelected [

	selectedList selectedItem ifNotNil: [ :item | 
		item isComposite 
			ifTrue: [ selectedRules removeAllFoundIn: item rules ]
			ifFalse: [ selectedRules remove: item ] ].
	self update.
	nextButton enabled: selectedRules isNotEmpty
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> removeTestCase: aBoolean [

	removeTestCase := aBoolean
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> selectedItems [

	^ selectedItems ifNil: [ selectedItems := #() ]
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> selectedList [

	^ selectedList
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> selectedList: anObject [

	selectedList := anObject
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> selectedRules [

	^ selectedRules
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> selectedRules: anObject [

	selectedRules := anObject
]

{ #category : 'accessing - model' }
StCritiqueRuleSelectorPresenter >> setModelBeforeInitialization: aCollection [

	items := aCollection first.
	selectedItems := aCollection second.
	methodName := aCollection third
]

{ #category : 'updating' }
StCritiqueRuleSelectorPresenter >> updateButtonsState: aSelection [

	| shouldBeEnabled |
	
	shouldBeEnabled := aSelection isEmpty 
		ifTrue: [ false ]
		ifFalse: [ aSelection selectedItem isComposite 
				ifTrue: [ aSelection selectedItem rules anySatisfy: [:e | self isSelected: e ] ]
				ifFalse: [ true ] ].
	
	removeButton enabled: shouldBeEnabled.
	

]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> updateTree [

	list update.
	selectedList update
]

{ #category : 'accessing' }
StCritiqueRuleSelectorPresenter >> windowTitle [

	^ 'Select rules'
]
