"
A simple CompasableModel to add new packages to the current package dependencies analysis.
It implies to be open from a PDPackageAnalyzerWindowPackageDependencies instance. 
"
Class {
	#name : 'StAddPackagePresenter',
	#superclass : 'StPresenter',
	#instVars : [
		'packageList',
		'buttonAddPackage',
		'dependenciesPresenter'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Core',
	#package : 'NewTools-DependencyAnalyser-UI',
	#tag : 'Core'
}

{ #category : 'specs' }
StAddPackagePresenter class >> defaultPreferredExtent [
	^ (600@600)
]

{ #category : 'specs' }
StAddPackagePresenter class >> title [

	^ 'Choose packages to add'
]

{ #category : 'protocol' }
StAddPackagePresenter >> actionOnAddPackage [

	| relationGraph packagesToAdd |
	buttonAddPackage action: [
		self selectedItemsFromPackageList ifNotEmpty: [
			relationGraph := self dependenciesPresenter relationGraph.
			packagesToAdd := self selectedItemsFromPackageList collect: [ :packageName | (StPackage onPackageNamed: packageName) beSeen ].
			relationGraph addPackages: packagesToAdd.
			self dependenciesPresenter
				refresh;
				resetDefaultSettings.
			self delete ] ]
]

{ #category : 'actions' }
StAddPackagePresenter >> buildList [
	| packagesAdded packagesNotAdded |
	packagesAdded := self dependenciesPresenter seenPackagesName.
	packagesNotAdded := self systemPackages.
	packagesNotAdded removeAll: packagesAdded.
	packageList sourceItems: packagesNotAdded
]

{ #category : 'initialization' }
StAddPackagePresenter >> connectPresenters [
	self actionOnAddPackage
]

{ #category : 'layout' }
StAddPackagePresenter >> defaultLayout [

	^ SpBoxLayout newTopToBottom
			add: packageList;
			add: buttonAddPackage expand: false;
			yourself
]

{ #category : 'accessing' }
StAddPackagePresenter >> dependenciesPresenter [
	^ dependenciesPresenter
]

{ #category : 'accessing' }
StAddPackagePresenter >> dependenciesPresenter: aPackageTreePresenter [
	dependenciesPresenter := aPackageTreePresenter.
	self buildList
]

{ #category : 'initialization' }
StAddPackagePresenter >> initializePresenters [

	buttonAddPackage := self newButton
		help: 'Add these packages to the current analysis';
		label: 'Add packages';
		icon: (self iconNamed: #add);
		yourself.

	packageList := self instantiate: SpChooserPresenter
]

{ #category : 'initialization' }
StAddPackagePresenter >> selectedItemsFromPackageList [
	^ packageList chosenItems
]

{ #category : 'accessing' }
StAddPackagePresenter >> systemPackages [

	^ (self packageOrganizer packages collect: [ :package | package name asString ]) asSortedCollection
]
