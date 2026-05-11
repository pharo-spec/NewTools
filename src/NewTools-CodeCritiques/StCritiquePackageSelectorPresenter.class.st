"
I am a presenter that allows to select items from a list of packages in my left column and put that items on a selected list in my rigth column. I support selection for checkBox. 

If you click on 'Next', I will open the StCritiqueRuleSelectorPresenter.
I send selected packages from selected list to StCritiqueBrowserPresenter. 

You can open me whit:
`StCritiquePackageSelectorPresenter open`


"
Class {
	#name : 'StCritiquePackageSelectorPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'nextButton',
		'chooserPackages'
	],
	#category : 'NewTools-CodeCritiques-Applier',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Applier'
}

{ #category : 'instance creation' }
StCritiquePackageSelectorPresenter class >> defaultPreferredExtent [ 

	^ 450 @ 360
]

{ #category : 'instance creation' }
StCritiquePackageSelectorPresenter class >> open [

	<example>
	^ self new open
]

{ #category : 'accessing' }
StCritiquePackageSelectorPresenter >> chooserPackages [

	^chooserPackages 
]

{ #category : 'layout' }
StCritiquePackageSelectorPresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		spacing: 5;
		add: chooserPackages;
		add: (SpBoxLayout newLeftToRight
				vAlignCenter;
				hAlignEnd;
				add: nextButton;
				yourself)
			expand: false;
		yourself
]

{ #category : 'initialization' }
StCritiquePackageSelectorPresenter >> initializeNextButton [

	nextButton := self newButton.
	nextButton
		icon: (self iconNamed: #smallOk);
		label: 'Next';
		action: [ self nextAction ]
]

{ #category : 'initialization' }
StCritiquePackageSelectorPresenter >> initializePresenters [

	chooserPackages := self setChooserPackages.
	self initializeNextButton
]

{ #category : 'actions' }
StCritiquePackageSelectorPresenter >> nextAction [

	| packages env |
	packages := chooserPackages targetList items.
	env := RBPackageEnvironment new packages: packages.
	StCritiqueRuleSelectorPresenter openWithEnvironment: env removeTestCase: false.
	self delete
]

{ #category : 'initialization' }
StCritiquePackageSelectorPresenter >> nextButton [

	^nextButton
]

{ #category : 'initialization' }
StCritiquePackageSelectorPresenter >> setChooserPackages [

	| chooser |
	chooser := SpChooserPresenter sourceItems: self packageOrganizer packages chosenItems: {  } displayBlock: #name.
	chooser sourceList displayIcon: [ self iconNamed: #package ].
	chooser targetList displayIcon: [ self iconNamed: #package ].
	^ chooser
]

{ #category : 'initialization' }
StCritiquePackageSelectorPresenter >> windowTitle [

	^ 'Select packages'
]
