"
I am a presenter that allows get a list of critiques that broken the selected rules in the selected packages. 

I interact with StCritiquePackageSelectorPresenter to get the list of selected packages.
I interact with StCritiqueRuleSelectorPresenter to get the list of selected rules.
I interact with StCritiquesCache to get the critiques saved as 'To-do' and marked as 'false positive'.

You can open me whit:
`StCritiqueBrowserPresenter open`

"
Class {
	#name : 'StCritiqueBrowserPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'critiqueModel',
		'rulesModel',
		'checker',
		'title',
		'rbEnvironment',
		'removeTestCase',
		'cache',
		'resetButton',
		'logButton',
		'updateButton',
		'critiquesModel',
		'sourceCodeModel',
		'toolbarModel'
	],
	#category : 'NewTools-CodeCritiques-Base',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Base'
}

{ #category : 'menu' }
StCritiqueBrowserPresenter class >> critiquesBrowserMenuOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Critique Browser')
		action: [ self openOnCurrentWorkingConfiguration ];
		order: 2;
		parent: #Browsing;
		help: 'To manage rule checks.';
		iconName: self iconName
]

{ #category : 'layout' }
StCritiqueBrowserPresenter class >> defaultLayout [

	^ SpPanedLayout newTopToBottom
		  add: (SpPanedLayout newLeftToRight
				   add: (SpBoxLayout newTopToBottom
						    add: #rulesModel;
						    add: (SpBoxLayout newLeftToRight
								     add: #resetButton;
								     add: #updateButton;
								     add: #logButton;
								     yourself)
						    height: 25;
						    yourself);
				   add: (SpBoxLayout newTopToBottom
						    add: #critiquesModel;
						    add: #toolbarModel height: 25;
						    yourself);
				   yourself);
		  add: #sourceCodeModel;
		  yourself
]

{ #category : 'icons' }
StCritiqueBrowserPresenter class >> icon [

	"Answer an icon for the receiver."

	^ self iconNamed: self iconName
]

{ #category : 'icons' }
StCritiqueBrowserPresenter class >> iconName [

	^ #smallQA
]

{ #category : 'instance creation' }
StCritiqueBrowserPresenter class >> open [

	<example>
	^ self new open
]

{ #category : 'menu' }
StCritiqueBrowserPresenter class >> openOnCurrentWorkingConfiguration [

	<script>
	CBCritiqueWorkingConfiguration exists
		ifTrue: [ StResetWindowPresenter new open ]
		ifFalse: [ StCritiquePackageSelectorPresenter open ]
]

{ #category : 'instance creation' }
StCritiqueBrowserPresenter class >> openOnRule: aRule onEnvironment: aEnv [

	| cbr |
	cbr :=  self new rules: aRule;
		environment: aEnv;
		removeTestCase: false;
		yourself.
		
	cbr open.
	cbr applyRules. 
	cbr rulesModel changed:  #listElementAt:
]

{ #category : 'instance creation' }
StCritiqueBrowserPresenter class >> openOnWorkingConfiguration: aWorkingConfiguration [

	| cbr |
	cbr := self new 
		rules: aWorkingConfiguration rule;
		environment: aWorkingConfiguration environment;
		removeTestCase: aWorkingConfiguration removeTestCase;
		yourself.

	cbr open.
	cbr applyRules. 
	cbr rulesModel  changed:  #listElementAt:
]

{ #category : 'icons' }
StCritiqueBrowserPresenter class >> taskbarIconName [

	^#smallWarning
]

{ #category : 'window' }
StCritiqueBrowserPresenter >> addModelItemsToWindowMenu: aMenu [
	"Add model-related items to the window menu"

	aMenu
		addLine;
		add: 'Clean all manifest' target: checker selector: #cleanAllManifest;
		add: 'Reapply all  rules' target: self selector: #reapplyAllRules
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> allRules [
	^ rulesModel roots flatCollect: #rules
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> applyRules [

	| packageCount nbPackage process rules |
	rules := self allRules.
	nbPackage := rbEnvironment packages size.
	packageCount := 0.
	self updateTree.
	process := [
	           rbEnvironment packages do: [ :package |
		           | windowTitle |
		           packageCount := packageCount + 1.
		           windowTitle := String streamContents: [ :s |
			                          s << 'run rules on ' << package name << ' (' << packageCount asString << '/' << nbPackage asString << ')' ].
		           self setTitle: windowTitle.
		           checker runRules: rules onPackage: package withoutTestCase: removeTestCase ].
	           checker rule: rules.
	           self setTitle: self defaultTitle.
	           cache packages: rbEnvironment.
	           cache initCache.
	           self rules: (self allRules select: [ :r | self hasBrokenRules: r ]).
	           self rulesModel refresh.
	           self rebuildLayout.
	           self updateTree ] newProcess.
	process name: 'SmallLint'.
	process resume
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> browseRule [

	rulesModel selectedItem ifNotNil: [ :item | ^ item browse ]
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> buildRuleMenuActions [

	^ SpActionGroup new
		addActionWith: [ :item | item
			name: 'Browse rule' translated;
			action: [ self browseRule ] ];
		addActionWith: [ :item | item
			name: 'Reapply this rule' translated;
			action: [ self reapplyThisRule ] ];
		yourself
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> classAdded: aClass [

	| rules |
	(rbEnvironment definesClass: aClass) ifFalse: [ ^ self ].

	rules := self allRules.
	checker
		resetResult;
		checkClass: aClass.

	rules do: [ :rule | 
		(checker criticsOf: rule) do: [ :crit | 
			cache addCritique: crit forRule: rule ].
		(checker falsePositiveOf: rule) do: [ :crit | 
			cache addFalsePositive: crit forRule: rule ].
		(checker toDoOf: rule) do: [ :crit | 
			cache addToDo: crit forRule: rule ] ].

	cache updateBrowser
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> classRemoved: aClass [

	(rbEnvironment definesClass: aClass)
		ifTrue: [ cache itemRemoved: aClass ].
		
	cache updateBrowser
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> colorForRule: aRule [

	| total |
	^ (total := cache critiquesOf: aRule)
		  ifEmpty: [ critiqueModel falsePositiveColor ]
		  ifNotEmpty: [ 
			  (cache falsePositiveOf: aRule) = total
				  ifTrue: [ critiqueModel falsePositiveColor ]
				  ifFalse: [ self class theme textColor ] ]
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> connectPresenters [

	rulesModel whenSelectedItemChangedDo: [ :rule | 
		(rule isNil or: [ rule isComposite ]) ifFalse: [ 
			critiqueModel
				resetSelection;
				rule: rule;
				setTextModelForNil ].
		self setTitle:
			(rule ifNil: [ self defaultTitle ] ifNotNil: [ rule name ]) ]
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> critiquesModel [

	^ critiqueModel critiquesModel
]

{ #category : 'api' }
StCritiqueBrowserPresenter >> defaultTitle [

	^ 'Critique Browser'
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> environment [
	^ rbEnvironment

]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> environment: aEnv [
	rbEnvironment := aEnv

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleClassAdded: anAnnouncement [

	self classAdded: anAnnouncement classAdded

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleClassModified: anAnnouncement [

	self
		classRemoved: anAnnouncement oldClassDefinition;
		classAdded: anAnnouncement newClassDefinition
	
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleClassRemoved: anAnnouncement [

	self classRemoved: anAnnouncement classRemoved

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleMethodAdded: anAnnouncement [

	self methodAdded: anAnnouncement methodAdded

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleMethodModified: anAnnouncement [

	self
		methodRemoved: anAnnouncement oldMethod;
		methodAdded: anAnnouncement newMethod
	

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> handleMethodRemoved: anAnnouncement [

	self methodRemoved: anAnnouncement methodRemoved

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> hasBrokenRules: rule [
    | unclassified falsePositives toDos total |
    falsePositives := (cache falsePositiveOf: rule) size.
    toDos := (cache toDosOf: rule) size.
    total := (cache critiquesOf: rule) size.
    unclassified := total - falsePositives - toDos.
    ^ unclassified > 0
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> initialize [

	super initialize.
	cache := CBCritiquesCache new.
	checker := ReSmalllintChecker new.
	cache checker: checker.
	cache browser: self.
	critiqueModel cache: cache.
	toolbarModel cache: cache
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> initializePresenters [

	title := self defaultTitle.
	rulesModel := self newTreeTable.
	resetButton := self newButton.
	updateButton := self newButton.
	logButton := self newButton.

	self setLogButton.
	self setResetButton.
	self setUpdateButton.

	critiqueModel := StSingleCritiqueResultListPresenter new.
	critiquesModel := self critiquesModel.
	sourceCodeModel := self sourceCodeModel.
	toolbarModel := self toolbarModel.

	self setRulesModel.

	self focusOrder
		add: rulesModel;
		add: critiqueModel
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 760 @ 370
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> logButton [
	^ logButton 
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> logInManifest [
	cache logInManifest
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> methodAdded: aMethod [

	| rules |
	(rbEnvironment includesMethod: aMethod) ifFalse: [ ^ self ].

	rules := self allRules.
	checker
		resetResult;
		getCritiquesAbout: aMethod
		by: (rules select: [ :r | r class checksMethod ]).

	rules do: [ :rule | 
		(checker criticsOf: rule) do: [ :crit | 
			cache addCritique: crit forRule: rule ].
		(checker falsePositiveOf: rule) do: [ :crit | 
			cache addFalsePositive: crit forRule: rule ].
		(checker toDoOf: rule) do: [ :crit | 
			cache addToDo: crit forRule: rule ] ].

	cache updateBrowser
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> methodRemoved: aMethod [

	(rbEnvironment includesMethod: aMethod)
		ifTrue: [ cache itemRemoved: aMethod ].
		
	cache updateBrowser
]

{ #category : 'api' }
StCritiqueBrowserPresenter >> onWindowClosed [

	self unregisterFromAnnouncements.

	cache cacheChange ifTrue: [
		| logging |
		logging := self application newConfirm
			           title: 'Question';
			           label:
				           'Do you want log all wrong violations in the Manifests
before closing the Critiques Browser ?';
			           acceptLabel: 'Sure!';
			           cancelLabel: 'No';
			           openModal.
		logging ifTrue: [ cache logInManifest ] ]
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> reapplyAllRules [

	cache initialize.
	checker resetResult.
	self applyRules
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> reapplyRule: aRule [

	cache removeRule: aRule.
	checker resetResult.
	rbEnvironment packages do: [ :package | 
		checker runRules: { aRule } onPackage: package withoutTestCase: removeTestCase ]. 
	(checker criticsOf: aRule) do:	[ :crit |
		cache addCritique: crit forRule: aRule ].
	(checker falsePositiveOf: aRule) do:	[ :crit |
		cache addFalsePositive: crit forRule: aRule ].
	(checker toDoOf: aRule) do:	[ :crit |
		cache addToDo: crit forRule: aRule ].	
	
	cache updateBrowser
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> reapplyThisRule [

	| rule |
	rulesModel selectedItem ifNil: [ ^ self ].
	rule := rulesModel selectedItem.
	rule isComposite 
		ifTrue: [ rule rules do: [ :each | self reapplyRule: each ] ]
		ifFalse: [ self reapplyRule: rule ]
	

]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> registerToAnnouncements [

	self unregisterFromAnnouncements.

	self class codeChangeAnnouncer weak
		when: ClassAdded send: #handleClassAdded: to: self;
		when: ClassModifiedClassDefinition send: #handleClassModified: to: self;
		when: ClassRemoved send: #handleClassRemoved: to: self;
		when: MethodAdded send: #handleMethodAdded: to: self;
		when: MethodModified send: #handleMethodModified: to: self;
		when: MethodRemoved send: #handleMethodRemoved: to: self.
	self window window announcer when: WindowClosed send: #onWindowClosed to: self
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> removeTestCase: aBoolean [
	removeTestCase :=  aBoolean
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> resetButton [
	^ resetButton 
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> rules: rulesCollection [

	self rulesModel roots:
		(((rulesCollection groupedBy: #group) associations collect: [ :as | 
			  CBCritiquesRuleGroup named: as key rules: as value ]) sorted: [ 
			 :a 
			 :b | a name < b name ])
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> rulesModel [

	^ rulesModel
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setActionLogButton [

	^ [
		| logging |
		logging := self application newConfirm
			           title: 'Question';
			           label:
				          'Do you want to save all false positive and toDo in the Manifests ?
(this action may generate new manifest classes and make dirty your package)';
			           acceptLabel: 'Sure!';
			           cancelLabel: 'No';
			           openModal.
		logging ifTrue: [ cache logInManifest ] ]
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setActionResetButton [

	^ [
	| logging |
		logging := self application newConfirm
			           title: 'Question';
			           label:
				           'Do you want to delete the current configuration
 and create a new configuration ?';
			           acceptLabel: 'Sure!';
			           cancelLabel: 'No';
			           openModal.
		logging ifTrue: [
		  self delete.
		  StCritiquePackageSelectorPresenter open ] ]
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setActionUpdateButton [
	^ [ self reapplyAllRules ]
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setLogButton [

	logButton 
		state: false;
		icon: (self iconNamed: #smallSave);
		label: 'Save Critiques';
		action: self setActionLogButton 
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setResetButton [

	resetButton 
		state: false;
		icon: (self iconNamed: #smallUpdate);
		label: 'Run new configuration';
		action: self setActionResetButton
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> setRulesModel [ 
	
	rulesModel children: [ :rule | 
		rule isComposite
			ifTrue: [ rule rules asArray ]
			ifFalse: [ #() ] ].

	rulesModel addColumn: ((SpStringTableColumn evaluated: [ :rule | 
			  self stringMorphForRule: rule ]) title: 'Rules Group').
	rulesModel actions: self buildRuleMenuActions
]

{ #category : 'api' }
StCritiqueBrowserPresenter >> setTitle: aTitle [

	title := aTitle.
	self withWindowDo: [ :w | w title: aTitle ]
]

{ #category : 'initialization' }
StCritiqueBrowserPresenter >> setUpdateButton [

	updateButton 
		state: false;
		icon: (self iconNamed: #restart);
		label: 'Update';
		action: self setActionUpdateButton.
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> sourceCodeModel [

	^ critiqueModel sourceCodeModel
]

{ #category : 'private' }
StCritiqueBrowserPresenter >> stringMorphForRule: rule [
	
	"set the amount of critiques per rule"
	| unclassified falsePositives toDos text total |
	falsePositives := (cache falsePositiveOf: rule) size.
	toDos := (cache toDosOf: rule) size.
	total := (cache critiquesOf: rule) size.
	unclassified := total - falsePositives - toDos.
	text := String streamContents: [ :s | 
		        s
			        << rule name;
			        << ' (To sort: ';
			        print: unclassified;
			        << ', ToDo: ';
			        print: toDos;
			        << ', Wrong: ';
			        print: falsePositives;
			        << ')' ].
	^ text asMorph
		  color: (self colorForRule: rule);
		  yourself
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> toolbarModel [

	^ critiqueModel toolbarModel
]

{ #category : 'system annoucements' }
StCritiqueBrowserPresenter >> unregisterFromAnnouncements [

	self class codeChangeAnnouncer unsubscribe: self
]

{ #category : 'accessing' }
StCritiqueBrowserPresenter >> updateButton [
	^ updateButton 
]

{ #category : 'thread' }
StCritiqueBrowserPresenter >> updateTree [

	critiqueModel updateList.
	rulesModel update
]
