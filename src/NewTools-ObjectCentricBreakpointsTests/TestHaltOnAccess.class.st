Class {
	#name : #TestHaltOnAccess,
	#superclass : #TestCase,
	#category : #'NewTools-ObjectCentricBreakpointsTests'
}

{ #category : #running }
TestHaltOnAccess >> setUp [
	MetaLink uninstallAll
]

{ #category : #running }
TestHaltOnAccess >> tearDown [
	MetaLink uninstallAll
]
