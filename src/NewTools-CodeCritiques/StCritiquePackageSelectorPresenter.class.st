"
I am a presenter that allows to select items from a list of packages in my left column and put that items on a selected list in my rigth column. I support selection for checkBox. 

If you click on 'Next', I will open the StCritiqueRuleSelectorPresenter.
I send selected packages from selected list to StCritiqueBrowserPresenter. 

You can open me whit:
`StCritiquePackageSelectorPresenter open`


"
Class {
	#name : #StCritiquePackageSelectorPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'nextButton',
		'chooserPackages'
	],
	#category : #'NewTools-CodeCritiques-Applier'
}

{ #category : #'instance creation' }
StCritiquePackageSelectorPresenter class >> open [

	<example>
	^ self new openWithSpec
]

{ #category : #accessing }
StCritiquePackageSelectorPresenter >> chooserPackages [

	^chooserPackages 
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> defaultTitle [

	^ 'Select packages'
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> initializeLayout [

	self layout: (SpBoxLayout newTopToBottom
			add: #chooserPackages;
			add: (SpBoxLayout newLeftToRight
					  addLast: #nextButton;
					  yourself)
			 height: 25;
			 yourself)
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> initializeNextButton [

	nextButton := self newButton.
	nextButton
		icon: (self iconNamed: #smallOk);
		label: 'Next';
		action: [ self nextAction ]
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> initializePresenters [

	chooserPackages := self setChooserPackages.
	self initializeNextButton.
	self initializeLayout
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: self defaultTitle;
		initialExtent: 450 @ 360
]

{ #category : #adding }
StCritiquePackageSelectorPresenter >> nextAction [

	| packages env |
	packages := chooserPackages targetList items.
	env := RBPackageEnvironment new packages: packages.
	StCritiqueRuleSelectorPresenter openWithEnvironment: env removeTestCase: false.
	self delete
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> nextButton [

	^nextButton
]

{ #category : #initialization }
StCritiquePackageSelectorPresenter >> setChooserPackages [
	
	| chooser |
	chooser := SpChooserPresenter
		   sourceItems: RPackageOrganizer default packages
		   chosenItems:
		   {  }
		   displayBlock: #packageName.
	chooser sourceList displayIcon: [ self iconNamed: #packageIcon ].
	chooser targetList displayIcon: [ self iconNamed: #packageIcon ].
	^ chooser 
]
