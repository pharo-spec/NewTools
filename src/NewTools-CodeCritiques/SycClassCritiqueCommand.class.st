"
I am a command to make a class abstract by adding a method that returns whether the class is abstract
"
Class {
	#name : 'SycClassCritiqueCommand',
	#superclass : 'SycSingleClassCommand',
	#category : 'NewTools-CodeCritiques-Commands',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Commands'
}

{ #category : 'testing' }
SycClassCritiqueCommand >> canBeExecuted [ 

	^ context lastSelectedClass realClass notNil
]

{ #category : 'executing' }
SycClassCritiqueCommand >> execute [

	StCritiqueClassRuleSelectorPresenter 
		openWithEnvironment: (RBClassEnvironment new classes: { context lastSelectedClass realClass }) 
		removeTestCase: false. 

]

{ #category : 'accessing' }
SycClassCritiqueCommand >> iconName [

	^ #smallQA
]

{ #category : 'accessing' }
SycClassCritiqueCommand >> name [
	^ 'Class Critique Browser'
]

{ #category : 'accessing' }
SycClassCritiqueCommand >> order [
	^ 60
]
