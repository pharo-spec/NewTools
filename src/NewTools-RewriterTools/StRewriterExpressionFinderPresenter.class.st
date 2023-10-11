"
I am a presenter that finds all the ocurrenses of a pattern code in all the methods that are in the Pharo image.
"
Class {
	#name : 'StRewriterExpressionFinderPresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'patternCodePresenter',
		'searchButton',
		'cheatSheet',
		'searchOnAllClassesButton',
		'scopeSelectorPresenter'
	],
	#category : 'NewTools-RewriterTools-ExpressionFinder',
	#package : 'NewTools-RewriterTools',
	#tag : 'ExpressionFinder'
}

{ #category : 'world menu' }
StRewriterExpressionFinderPresenter class >> descriptionText [

	^ 'A tool to search the ocurrences of a rewrite rule within the Pharo image'
]

{ #category : 'accessing' }
StRewriterExpressionFinderPresenter class >> icon [

	^ self iconNamed: self iconName
]

{ #category : 'accessing' }
StRewriterExpressionFinderPresenter class >> iconName [

	^ #smallFind
]

{ #category : 'world menu' }
StRewriterExpressionFinderPresenter class >> menuCommandOn: aBuilder [

	<worldMenu>
	(aBuilder item: 'Expression Finder')
		action: [ self new open ];
		order: 31;
		parent: #Tools;
		icon: self icon;
		help: self descriptionText
]

{ #category : 'specs' }
StRewriterExpressionFinderPresenter class >> title [

	^ 'Expression Finder'
]

{ #category : 'initialization' }
StRewriterExpressionFinderPresenter >> connectPresenters [

	searchButton action: [ self searchExpression ].
	searchOnAllClassesButton action: [ self searchExpressionOnAllClasses ]
]

{ #category : 'layout' }
StRewriterExpressionFinderPresenter >> defaultLayout [

	^ SpPanedLayout newLeftToRight
		add: patternCodePresenter;
		add: (SpBoxLayout newTopToBottom
			add: cheatSheet expand: true;
			add: searchButton expand: false;
			add: searchOnAllClassesButton expand: false;
			yourself);
		positionOfSlider: 70 percent;
		yourself
]

{ #category : 'initialization' }
StRewriterExpressionFinderPresenter >> initializePresenters [

	patternCodePresenter := self instantiate: StRewriterSearchForPanelPresenter.
	cheatSheet := self instantiate: StRewriterCheatSheetPresenter.
	scopeSelectorPresenter := self instantiate: StRewriterScopeSelectorPresenter.
	searchButton := self newButton
		iconName: #smallFind;
		label: 'Find in all classes';
		yourself.
	searchOnAllClassesButton := self newButton
		iconName: #smallFind;
		label: 'Find in selected classes';
		yourself
]

{ #category : 'initialization' }
StRewriterExpressionFinderPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self class title;
		initialExtent: 600 @ 330;
		windowIcon: self class icon;
		askOkToClose: false
]

{ #category : 'accessing' }
StRewriterExpressionFinderPresenter >> patternCode [
	^ patternCodePresenter lhs
]

{ #category : 'accessing' }
StRewriterExpressionFinderPresenter >> patternCode: aString [

	patternCodePresenter lhs: aString
]

{ #category : 'action' }
StRewriterExpressionFinderPresenter >> searchExpression [

	| ruleHolder critiques |
	ruleHolder := StRewriterRuleHolder lhs: patternCodePresenter lhs rhs: ''.
	critiques := StRewriterRenrakuApplier obtainCritiquesOfAllMethodsForRules: { ruleHolder }.
	^ (StRewriterOccurrencesBrowserPresenter critiques: critiques) open
]

{ #category : 'action' }
StRewriterExpressionFinderPresenter >> searchExpressionOnAllClasses [

	| dialogWindow methods ruleHolder critiques |
	dialogWindow := scopeSelectorPresenter openDialog.
	dialogWindow okAction: [
		methods := scopeSelectorPresenter selectedClasses flatCollectAsSet: [ :each | each methods ].
		ruleHolder := StRewriterRuleHolder lhs: patternCodePresenter lhs rhs: ''.
		critiques := StRewriterRenrakuApplier obtainCritiquesOf: methods forRules: { ruleHolder }.
		(StRewriterOccurrencesBrowserPresenter critiques: critiques) open ]
]
