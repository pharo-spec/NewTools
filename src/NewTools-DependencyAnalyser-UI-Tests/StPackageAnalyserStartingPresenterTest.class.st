"
I test `StPackageAnalyserStartingPresenter`, the first window of the dependency analyser, where the packages to analyse are chosen, at the presenter level, without opening it.

## Responsibility:

- Check that its package chooser is created through it, so that it belongs to it and uses its application.
- Check that the chooser offers all the packages of the image and that none is chosen at first.

## Internal Representation

- `presenter`: the presenter under test.
"
Class {
	#name : 'StPackageAnalyserStartingPresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Tests',
	#package : 'NewTools-DependencyAnalyser-UI-Tests'
}

{ #category : 'running' }
StPackageAnalyserStartingPresenterTest >> setUp [

	super setUp.
	presenter := StPackageAnalyserStartingPresenter new
]

{ #category : 'tests' }
StPackageAnalyserStartingPresenterTest >> testChooserIsOwnedByThePresenter [

	self assert: presenter choosePresenter owner identicalTo: presenter
]

{ #category : 'tests' }
StPackageAnalyserStartingPresenterTest >> testChooserOffersAllThePackages [

	self assert: presenter choosePresenter sourceList items size equals: presenter packageOrganizer packages size
]

{ #category : 'tests' }
StPackageAnalyserStartingPresenterTest >> testNoPackageIsChosenAtFirst [

	self assertEmpty: presenter selectedPackages
]
