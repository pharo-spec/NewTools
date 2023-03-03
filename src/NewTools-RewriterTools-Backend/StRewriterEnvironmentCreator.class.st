"
I am a class that creates an environment in which a set of rewrite rules can be applied.
"
Class {
	#name : #StRewriterEnvironmentCreator,
	#superclass : #Object,
	#category : #'NewTools-RewriterTools-Backend-Core'
}

{ #category : #api }
StRewriterEnvironmentCreator class >> scopeEnvironmentForAllPackages [

	^ RBPackageEnvironment packages: RPackageOrganizer default packages
]

{ #category : #api }
StRewriterEnvironmentCreator class >> scopeEnvironmentForClasses: classes [

	^ RBClassEnvironment classes: classes
]
