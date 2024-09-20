"
I am a command to make a class abstract by adding a method that returns whether the class is abstract
"
Class {
	#name : 'SycCmClassCritiqueCommand',
	#superclass : 'SycClassCmCommand',
	#category : 'NewTools-CodeCritiques-Commands',
	#package : 'NewTools-CodeCritiques',
	#tag : 'Commands'
}

{ #category : 'testing' }
SycCmClassCritiqueCommand >> canBeExecuted [ 

	^ context lastSelectedClass realClass notNil
]

{ #category : 'executing' }
SycCmClassCritiqueCommand >> execute [

	StCritiqueClassRuleSelectorPresenter 
		openWithEnvironment: (RBClassEnvironment new classes: { context lastSelectedClass realClass }) 
		removeTestCase: false. 

]

{ #category : 'accessing' }
SycCmClassCritiqueCommand >> icon [

	^ self iconNamed: #smallQA
]

{ #category : 'accessing' }
SycCmClassCritiqueCommand >> name [
	^ 'Class Critique Browser'
]

{ #category : 'accessing' }
SycCmClassCritiqueCommand >> order [
	^ 45
]
