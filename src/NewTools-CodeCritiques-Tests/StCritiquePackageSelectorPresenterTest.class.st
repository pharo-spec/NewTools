"
A StCritiquePackageSelectorPresenterTest is a test class for testing the behaivor of StCritiquePackageSelectorPresenter
"
Class {
	#name : #StCritiquePackageSelectorPresenterTest,
	#superclass : #TestCase,
	#category : #'NewTools-CodeCritiques-Tests'
}

{ #category : #initialization }
StCritiquePackageSelectorPresenterTest >> testInitializePresenters [

	| packagesSelectorPresenter |
	
	packagesSelectorPresenter := StCritiquePackageSelectorPresenter new.
	self
		assert: packagesSelectorPresenter chooserPackages class
		equals: SpChooserPresenter.
	self
		assert: packagesSelectorPresenter nextButton class
		equals: SpButtonPresenter.
]

{ #category : #initialization }
StCritiquePackageSelectorPresenterTest >> testOpen [

	| window |
	window := StCritiquePackageSelectorPresenter open.
	self assert: window isBuilt.
	window close
]
