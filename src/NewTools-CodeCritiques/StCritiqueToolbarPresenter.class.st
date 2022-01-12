"
I am the toolbar for displayed critiques in the critique browser.

* If you select 'Browse', I will open system browser with the location of the critique.
* If you select 'Mark as wrong', I will put in grey color the selected critique and it will be saved as false positive in cache.
* If you select Transfrom, I will open StRewriteCritiqueChangesBrowserPresenter, just if the selected critique has the automatically resolve option.

I interact with StSingleCritiqueResultListPresenter and it's displayed critiques. 

You can open me whit:
`CBCritiqueToolbar open`.

"
Class {
	#name : #StCritiqueToolbarPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'critiqueHolder',
		'browseButton',
		'falsePositiveButton',
		'transformButton',
		'selectDiffButton',
		'cache',
		'ruleHolder'
	],
	#category : #'NewTools-CodeCritiques-Parts'
}

{ #category : #specs }
StCritiqueToolbarPresenter class >> defaultSpec [

	<spec>
	^ SpBoxLayout newLeftToRight
		  add: #browseButton;
		  add: #falsePositiveButton;
		  add: #transformButton;
		  yourself
]

{ #category : #specs }
StCritiqueToolbarPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #specs }
StCritiqueToolbarPresenter class >> title [

	^ 'Critique Toolbar'
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> addCritiqueToFalsePositive [

	critiqueHolder value ifNotNil: [ :item | 
		cache addFalsePositive: item forRule: ruleHolder value ]
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> browseCritique [

	critiqueHolder value ifNotNil: [ :elem | 
		^ elem sourceAnchor entity browse ]
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> cache: aCache [

	cache := aCache
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> critique: aCritique [

	critiqueHolder value: aCritique.
	transformButton visibleIf:
		(aCritique isNotNil and: [ aCritique providesChange ])
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> critiqueHolder [

	^ critiqueHolder
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> critiqueHolder: anObject [

	critiqueHolder := anObject
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> falsePositiveButton [

	^ falsePositiveButton
]

{ #category : #initialization }
StCritiqueToolbarPresenter >> initialize [

	super initialize.
	critiqueHolder := nil asValueHolder.
	ruleHolder := nil asValueHolder.
	browseButton := self newBrowseButton.
	transformButton := self newTransformButton.
	falsePositiveButton := self newFalsePositiveButton.
	self setFocusOrder
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> newBrowseButton [

	^ self newButton
		  label: 'Browse';
		  icon: (self iconNamed: #nautilus);
		  help: 'Explore and modify in System Browser';
		  action: [ self browseCritique ];
		  yourself
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> newFalsePositiveButton [

	^ self newButton
		  label: 'Mark as wrong';
		  icon: (self iconNamed: #stop);
		  action: [ self addCritiqueToFalsePositive ];
		  yourself
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> newTransformButton [

	^ self newButton
		  label: 'Transform';
		  icon: (self iconNamed: #repair);
		  help: 'Apply changes to solve issue';
		  action: [ self transformCritique ];
		  yourself
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> rule: aRule [

	ruleHolder value: aRule
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> ruleHolder [

	^ ruleHolder
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> ruleHolder: anObject [

	ruleHolder := anObject
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> setFocusOrder [

	self focusOrder
		add: browseButton;
		add: falsePositiveButton;
		add: transformButton;
		add: selectDiffButton
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> transformButton [

	^ transformButton
]

{ #category : #accessing }
StCritiqueToolbarPresenter >> transformCritique [

	critiqueHolder value ifNotNil: [ :critique | 
		(StRewriteCritiqueChangesBrowserPresenter changes:
			 { critique change }) open ]
]
