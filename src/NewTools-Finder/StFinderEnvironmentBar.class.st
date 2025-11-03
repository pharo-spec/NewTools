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
		                        action: [ self openPackageChooserDialog ];
		                        yourself.
	allPackagesButton := self newButton
		                     label: 'All Packages';
		                     iconName: #radioButtonSelected;
		                     action: [ self searchInAllPackages ];
		                     yourself.

	self updateStatus
]

{ #category : 'accessing' }
StFinderEnvironmentBar >> model [

	^ self owner model
]

{ #category : 'private' }
StFinderEnvironmentBar >> openPackageChooserDialog [
	"Opens a `SpChooserPresenter` dialog to allow the user to choose the packages to search in."

	((SpChooserPresenter sourceItems: self model unselectedPackages chosenItems: self model selectedPackages)
		 sourceLabel: 'Available packages';
		 targetLabel: 'Selected packages';
		 openDialog)
		title: 'Select packages for searching';
		okAction: [ :dialog | self searchInPackages: dialog presenter chosenItems ]
]

{ #category : 'private' }
StFinderEnvironmentBar >> searchInAllPackages [
	"Selects all packages for searching."

	self model selectAllPackages.
	"Maybe we could use a real radio button?"
	allPackagesButton iconName: #radioButtonSelected.
	chosenPackagesButton iconName: #radioButtonUnselected.
	self updateStatus
]

{ #category : 'private' }
StFinderEnvironmentBar >> searchInPackages: aCollection [
	"Sets the search environment in the model to the package names given in aCollection."

	self model selectedPackagesByName: aCollection.
	"Maybe this should use a real radio button?"
	allPackagesButton iconName: #radioButtonUnselected.
	chosenPackagesButton iconName: #radioButtonSelected.
	self updateStatus
]

{ #category : 'updating - widgets' }
StFinderEnvironmentBar >> updateStatus [

	statusLabel label: self model selectedPackages size asString , ' Packages selected'
]
