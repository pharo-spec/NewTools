"
I test `StAddPackagePresenter`, the dialog adding packages to a dependency analysis (opened by `StDependencyTreePresenter>>#actionOnAddPackage`), at the presenter level, without opening it.

## Responsibility:

- Check that its package chooser is created through it, so that it belongs to it and uses its application.
- Check that no package is chosen at first.

## Internal Representation

- `presenter`: the presenter under test, created without dependencies presenter.
"
Class {
	#name : 'StAddPackagePresenterTest',
	#superclass : 'TestCase',
	#instVars : [
		'presenter'
	],
	#category : 'NewTools-DependencyAnalyser-UI-Tests',
	#package : 'NewTools-DependencyAnalyser-UI-Tests'
}

{ #category : 'running' }
StAddPackagePresenterTest >> setUp [

	super setUp.
	presenter := StAddPackagePresenter new
]

{ #category : 'tests' }
StAddPackagePresenterTest >> testNoPackageIsChosenAtFirst [

	self assertEmpty: presenter selectedItemsFromPackageList
]

{ #category : 'tests' }
StAddPackagePresenterTest >> testPackageListIsOwnedByThePresenter [

	self assert: presenter packageList owner identicalTo: presenter
]
