Class {
	#name : #StCriticRuleChooserPresenter,
	#superclass : #StPackageChooserPresenter,
	#instVars : [
		'packageActionBar',
		'testPackages'
	],
	#category : #'NewTools-CriticsBrowser'
}

{ #category : #initialization }
StCriticRuleChooserPresenter >> initialize [

	testPackages := false.
	super initialize
]

{ #category : #initialization }
StCriticRuleChooserPresenter >> initializeLayout [
	
	self layout: (SpBoxLayout newTopToBottom
		spacing: 5;
		add: (SpPanedLayout newLeftToRight
			add: (SpBoxLayout newLeftToRight
				spacing: 5;
				add: (SpBoxLayout newTopToBottom 
					add: (packageList := (self instantiate: SpFilteringSelectableListPresenter));
					addLast: (packageActionBar := SpBoxLayout newLeftToRight) expand: false;
					yourself);
				add: (buttonBar := SpBoxLayout newTopToBottom) expand: false;
				yourself);
			add: (selectedPackagesList := (self instantiate: SpFilteringSelectableListPresenter));
			yourself);
		yourself)
]

{ #category : #initialization }
StCriticRuleChooserPresenter >> initializePackageList [
	
	super initializePackageList.
	packageList display: [ :each | each name ]
]

{ #category : #accessing }
StCriticRuleChooserPresenter >> packages [
	| rules rulesByGroup |
	
	rules := (ReRuleManager visibleRuleClasses 
		collect: [:aClass | aClass new]) 
		sorted: [ :a :b  | a name < b name ].
	rulesByGroup := ((rules groupedBy: #group) associations collect: [ :as |
		CriticBrowserRulesGroup named: as key rules: as value ]).
	rulesByGroup sort: [ :a :b | a name < b name ].
	
	^ rulesByGroup
]
