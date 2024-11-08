"
Wrapper for settings containing a `Boolean` type.
"
Class {
	#name : 'StSettingBooleanPresenterItem',
	#superclass : 'StSettingPresenterItem',
	#category : 'NewTools-SettingsBrowser-Widgets',
	#package : 'NewTools-SettingsBrowser',
	#tag : 'Widgets'
}

{ #category : 'initialization' }
StSettingBooleanPresenterItem >> initializePresenters [ 

	setterPresenter := self newCheckBox
		whenActivatedDo: [ self updateSetting: self model value: true ];
		whenDeactivatedDo: [ self updateSetting: self model value: false ].
	super initializePresenters.

]

{ #category : 'initialization' }
StSettingBooleanPresenterItem >> updateSetting: aSettingDeclaration value: aBoolean [
	"Private - Callback for updating aSettingDeclaration with the new receiver's selected item"

	self model targetSelector
	 ifNil: [ 
		| modelTarget realTarget |
		modelTarget := 	self model target.
		realTarget := modelTarget isClass
			ifTrue: [ modelTarget name ]
			ifFalse: [ modelTarget ].
		(self class environment at: realTarget) 
			perform: self model setSelector
			with: aBoolean ] 
	ifNotNil: [
		(self model target perform: self model targetSelector) 
			perform: self model setSelector
			with: aBoolean ]

]

{ #category : 'accessing' }
StSettingBooleanPresenterItem >> value: aBoolean [

	self setterPresenter state: aBoolean
]
