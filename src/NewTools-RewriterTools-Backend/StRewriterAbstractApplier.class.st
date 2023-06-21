"
I am the abstract class for applying a code transformation
"
Class {
	#name : #StRewriterAbstractApplier,
	#superclass : #Object,
	#category : #'NewTools-RewriterTools-Backend-Core'
}

{ #category : #api }
StRewriterAbstractApplier class >> applyTransformationChanges: changes [

	| refactoringJob |
	refactoringJob := [
		changes do: [ :change | RBRefactoryChangeManager instance performChange: change ] ] asJob.
	refactoringJob
		title: 'Refactoring';
		run
]

{ #category : #api }
StRewriterAbstractApplier class >> calculateAllChangesForRules: ruleHolderCollection [

	^ self subclassResponsibility
]

{ #category : #api }
StRewriterAbstractApplier class >> calculateChangesForClasses: classes transformationRules: ruleHolderCollection [

	^ self subclassResponsibility
]

{ #category : #api }
StRewriterAbstractApplier class >> defaultEngineApplier [

	^ StRewriterRBApplier
]
