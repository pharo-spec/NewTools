"
I am a tool that allows you to create, apply and save custom rewrite rules. To open me go to my class side method `open`.

You can write the rewrite rule on searchFor's and replaceWith's editors. When the rewrite rule is written, you can click on 'Open Applier' for open a tool that allows you to apply the rewrite rule to specific classes. Or you just can click on 'Apply on all classes' to apply the rewrite rule to all system's classes.

The Applier only works with saved rules, so remember to save your rule before open it. To apply the rule to all system's classes you do not need to save the rule.

The rule is saved as a subclass of `RBTransformationRule` so the name you enter must be a valid class name.

If you want to edit an already saved rewrite rule, just click on 'Open Loader' and select your rule. When you open me with an already saved rule and click the 'Save rule' button, the name of the rule is entered by default. If you save a rewrite rule with the same name it will be updated.

Click on MatchTool to open a tool that allows you to match your rule with a block of Pharo's code.
"
Class {
	#name : 'StRewriterRuleEditorPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'cheatSheet',
		'loadButton',
		'expressionFinderButton',
		'searchForEditor',
		'replaceWithEditor',
		'scopeSelectorPresenter',
		'transformSelectedClassesButton',
		'transformAllClassesButton',
		'isForMethodCheckbox',
		'openMatcherButton'
	],
	#category : 'NewTools-RewriterTools-RuleEditor',
	#package : 'NewTools-RewriterTools',
	#tag : 'RuleEditor'
}

{ #category : 'accessing' }
StRewriterRuleEditorPresenter class >> descriptionText [

	^ 'A tool to build and apply custom Rewrite Rules.'
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter class >> iconName [
	^ #workspaceIcon
]

{ #category : 'world menu' }
StRewriterRuleEditorPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Rewrite Rule Editor')
		action: [ self new open ];
		order: 30;
		parent: #Tools;
		help: self descriptionText;
		icon: self icon
]

{ #category : 'specs' }
StRewriterRuleEditorPresenter class >> title [

	^ 'Rewrite Basic Editor'
]

{ #category : 'layout' }
StRewriterRuleEditorPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		add: (SpPanedLayout newVertical
			add: searchForEditor;
			add: replaceWithEditor;
			yourself);
		add: (SpBoxLayout newTopToBottom
			add: isForMethodCheckbox expand: false;
			add: cheatSheet expand: true;
			add: transformAllClassesButton expand: false;
			add: transformSelectedClassesButton expand: false;
			add: expressionFinderButton expand: false;
			add: openMatcherButton expand: false;
			add: loadButton expand: false;
			yourself);
		positionOfSlider: 70 percent;
		yourself
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeButtons [

	loadButton := self instantiate:
		(StRewriterOpenRuleLoaderCommand forSpecContext: self) asButtonPresenter.
	openMatcherButton := self instantiate:
		(StRewriterOpenMatchToolCommand forSpecContext: self) asButtonPresenter.
	transformAllClassesButton := self instantiate:
		(StRewriterApplyRuleOnAllClassesCommand forSpecContext: self) asButtonPresenter.
	expressionFinderButton := self instantiate:
		(StRewriterOpenExpressionFinderCommand forSpecContext: self) asButtonPresenter.
	transformSelectedClassesButton := self instantiate:
		(StRewriterApplyRuleOnSelectedClassesCommand forSpecContext: self) asButtonPresenter
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeMethodCheckbox [

	isForMethodCheckbox := self newCheckBox.
	isForMethodCheckbox label: 'The rule is for a method?'
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializePresenters [

	self initializeMethodCheckbox.
	self initializeTextCheatSheet.
	self initializeRuleEditors.
	self initializeButtons.
	self initializeScopeSelectorPresenter
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeRuleEditors [

	searchForEditor := self instantiate: StRewriterSearchForPanelPresenter.
	replaceWithEditor := self instantiate: StRewriterReplaceWithPanelPresenter
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeScopeSelectorPresenter [

	scopeSelectorPresenter := self instantiate: StRewriterScopeSelectorPresenter
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeTextCheatSheet [

	cheatSheet := self instantiate: StRewriterCheatSheetPresenter
]

{ #category : 'initialization' }
StRewriterRuleEditorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 700 @ 500;
		windowIcon: self class icon;
		aboutText: self class descriptionText
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> isRuleForMethod [

	^ isForMethodCheckbox state
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> lhs [
	^ searchForEditor lhs
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> lhs: aCode [
	searchForEditor lhs: aCode
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> rhs [
	^ replaceWithEditor rhs
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> rhs: aCode [
	replaceWithEditor rhs: aCode
]

{ #category : 'accessing' }
StRewriterRuleEditorPresenter >> scopeSelectorPresenter [

	^ scopeSelectorPresenter
]
