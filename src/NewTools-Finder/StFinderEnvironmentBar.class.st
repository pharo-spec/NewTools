"
I am a widget for the ̀Finder̀ tool. I contain all widgets regarding the search environment.
"
Class {
	#name : 'StFinderEnvironmentBar',
	#superclass : 'SpPresenter',
	#instVars : [
		'chosenPackagesButton',
		'allPackagesButton',
		'statusLabel'
	],
	#category : 'NewTools-Finder-Widgets',
	#package : 'NewTools-Finder',
	#tag : 'Widgets'
}

{ #category : 'updating - widgets' }
StFinderEnvironmentBar >> activateAllPackages [

	allPackagesButton iconName: #radioButtonSelected.
	chosenPackagesButton iconName: #radioButtonUnselected
]

{ #category : 'updating - widgets' }
StFinderEnvironmentBar >> activateChosenPackages [

	allPackagesButton iconName: #radioButtonUnselected.
	chosenPackagesButton iconName: #radioButtonSelected
]

{ #category : 'layout' }
StFinderEnvironmentBar >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  spacing: 2;
		  vAlignCenter;
		  add: statusLabel withConstraints: [ :constraints |
				constraints expand: false ];
		  add: allPackagesButton;
		  add: chosenPackagesButton;
		  yourself
]

{ #category : 'initialization' }
StFinderEnvironmentBar >> initializePresenters [

	statusLabel := self newLabel.
	chosenPackagesButton := self newButton
		                        label: 'Packages…';
		                        iconName: #radioButtonUnselected;
		                        yourself.
	allPackagesButton := self newButton
		                     label: 'All Packages';
		                     iconName: #radioButtonSelected;
		                     yourself
]

{ #category : 'instance creation' }
StFinderEnvironmentBar >> status: aString [

	statusLabel label: aString
]

{ #category : 'events' }
StFinderEnvironmentBar >> whenAllPackagesSelectedDo: aBlock [

	allPackagesButton action: aBlock
]

{ #category : 'events' }
StFinderEnvironmentBar >> whenPackagesSelectedDo: aBlock [

	chosenPackagesButton action: aBlock
]
