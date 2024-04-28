Class {
	#name : 'ScopesTest',
	#superclass : 'TestCase',
	#category : 'NewTools-Scopes-Tests',
	#package : 'NewTools-Scopes-Tests'
}

{ #category : 'private' }
ScopesTest >> scopesManagerClass [
	^ ScopesManager
]

{ #category : 'tests' }
ScopesTest >> testClassScopeExcludesClassCreatedAPosteriori [

	| package scope newClass |
	"I create a scope containing all the classes in a package"
	package := ScClassA1 package.
	scope := self scopesManagerClass newScopeFrom: package definedClasses.

	"Check that this scope defines the same classes as in the package"
	self
		assert: scope definedClasses asSet
		equals: package definedClasses.

	[ "Add a new class to the package"
	newClass := Object classInstaller make: [ :builder |
		            builder
			            superclass: Object;
			            name: #ScClassA4;
			            package: package name ].

	"Check that the new class does not belong in the scope"
	self deny: (scope definedClasses includes: newClass) ] ensure: [
		newClass removeFromSystem ]
]

{ #category : 'tests' }
ScopesTest >> testPackageScopeIncludesClassCreatedAPosteriori [

	| package scope newClass |
	package := ScClassA1 package.
	"Create a new scope containing the previous package"
	scope := self scopesManagerClass newScopeFrom: { package }.

	"Check that this scope defines the same classes as in the package"
	self
		assert: scope definedClasses asSet
		equals: package definedClasses.

	[ "Add the new class to the package"
	newClass := Object classInstaller make: [ :builder |
		            builder
			            superclass: Object;
			            name: #ScClassA4;
			            package: package name ].

	"Check that the new class belongs to the scope"
	self assert: (scope definedClasses includes: newClass) ] ensure: [
		newClass removeFromSystem ].
	"Check that the new class does not belong to the scope anymore"
	self deny: (scope definedClasses includes: newClass)
]
