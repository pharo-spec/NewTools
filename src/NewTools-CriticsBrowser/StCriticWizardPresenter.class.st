Class {
	#name : #StCriticWizardPresenter,
	#superclass : #SpPresenter,
	#instVars : [
		'contentPresenter',
		'nextButtonPresenter',
		'backButtonPresenter',
		'wizardPresenters',
		'finishButtonPresenter'
	],
	#category : #'NewTools-CriticsBrowser'
}

{ #category : #actions }
StCriticWizardPresenter >> doBack [

	self replaceContentWith: (self wizardPresenters before: contentPresenter)
]

{ #category : #actions }
StCriticWizardPresenter >> doFinish [

	
]

{ #category : #actions }
StCriticWizardPresenter >> doNext [

	self replaceContentWith: (self wizardPresenters after: contentPresenter)
]

{ #category : #private }
StCriticWizardPresenter >> firstPresenter [
	
	^ self wizardPresenters first
]

{ #category : #initialization }
StCriticWizardPresenter >> initializePresenters [
	<script: 'self new openWithSpec'>

	self layout: (SpBoxLayout newTopToBottom
		add: (contentPresenter := self firstPresenter);
		addLast: (SpBoxLayout newLeftToRight 
			borderWidth: 5;
			hAlignEnd;
			add: (backButtonPresenter := self newButton) expand: false;
			add: (nextButtonPresenter := self newButton) expand: false;
			add: (finishButtonPresenter := self newButton) expand: false;
			yourself)).
			
		backButtonPresenter 
			label: 'Back';
			action: [ self doBack ].
		nextButtonPresenter 
			label: 'Next';
			action: [ self doNext ].
		finishButtonPresenter 
			label: 'Finish';
			action: [ self doFinish ]
]

{ #category : #private }
StCriticWizardPresenter >> lastPresenter [
	
	^ self wizardPresenters last
]

{ #category : #private }
StCriticWizardPresenter >> newWizardPresenters [

	^ {  
	StCriticPackageChooserPresenter new.
	StCriticRuleChooserPresenter new.
	}
]

{ #category : #private }
StCriticWizardPresenter >> replaceContentWith: aPresenter [

	self layout 
		replace: contentPresenter 
		with: aPresenter.
	contentPresenter := aPresenter.
	self updatePresenter
]

{ #category : #initialization }
StCriticWizardPresenter >> updatePresenter [

	contentPresenter = self firstPresenter 
		ifTrue: [ backButtonPresenter hide ].
		
	contentPresenter = self lastPresenter 
		ifTrue: [ 
			nextButtonPresenter hide.
			finishButtonPresenter show ]
		ifFalse: [
			nextButtonPresenter show.
			finishButtonPresenter hide ]
]

{ #category : #private }
StCriticWizardPresenter >> wizardPresenters [

	^ wizardPresenters ifNil: [
		wizardPresenters := self newWizardPresenters ]
]
