"
Implements a presenter that allows get a list of critiques that broken the selected rules in the selected classes. 

It interacts with StCritiquePackageSelectorPresenter to get the list of selected packages.
I interact with StCritiqueRuleSelectorPresenter to get the list of selected rules.
I interact with StCritiquesCache to get the critiques saved as 'To-do' and marked as 'false positive'.

## Examples

`StClassCritiqueBrowserPresenter open`


"
Class {
	#name : 'StClassCritiqueBrowserPresenter',
	#superclass : 'StCritiqueBrowserPresenter',
	#category : 'NewTools-CodeCritiques-Base',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Base'
}

{ #category : 'menu' }
StClassCritiqueBrowserPresenter class >> openOnCurrentWorkingConfiguration [

	<script>
	CBCritiqueWorkingConfiguration exists
		ifTrue: [ StResetWindowPresenter new open ]
		ifFalse: [ StClassCritiqueRuleSelectorPresenter open ]
]

{ #category : 'private' }
StClassCritiqueBrowserPresenter >> applyRules [

	| process |

	self updateTree.
	checker environment: rbEnvironment.
	process := [ self processRules ] newProcess.
	process name: 'SmallLint'.
	process resume
]

{ #category : 'private' }
StClassCritiqueBrowserPresenter >> processRules [

	| packageCount nbPackage rules |
	
	nbPackage := rbEnvironment packages size.
	packageCount := 0.
	rules := self allRules.
	
	rbEnvironment classes do: [ :cls |
		| windowTitle |
		packageCount := packageCount + 1.
		windowTitle := String streamContents: [ :s |
			               s << 'run rules on ' << cls name << ' ('
			               << packageCount asString << '/'
			               << nbPackage asString << ')' ].
		self setTitle: windowTitle.
		checker
			classRules: rules;
			checkClass: cls ].
	checker rule: rules.
	self setTitle: self defaultTitle.
	cache packages: rbEnvironment.
	cache initCache.
	self rules: (self allRules select: [ :r | self hasBrokenRules: r ]).
	self rulesModel refresh.
	self rebuildLayout.
	self updateTree
]
