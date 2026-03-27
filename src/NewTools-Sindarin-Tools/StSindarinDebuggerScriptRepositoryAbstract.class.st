"
StSindarinDebuggerScriptRepository is an abstract class that defines the logic for managing script repositories in the context of Sindarin debugger extensions.

Its main responsibilities include:
- Saving scripts by name and code.
- Retrieving the list of available script names in the repository.
- Loading the code of a script given its name.

Subclasses are expected to implement the class side `repositoryName` method, which specifies the name (or identifier) of the script repository, typically based on the project it is associated with.

"
Class {
	#name : 'StSindarinDebuggerScriptRepositoryAbstract',
	#superclass : 'Object',
	#classInstVars : [
		'scripts'
	],
	#category : 'NewTools-Sindarin-Tools-Model',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Model'
}

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> clearScripts [
	<script>
	scripts := Dictionary new.
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> loadScript: aString [
	^ self scripts at: aString ifAbsent: nil.
	
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> repositoryName [
	"Return the name of the repository."
	self subclassResponsibility
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> saveScript: aStringKey code: aStringValue [
	
	self scripts add: aStringKey -> aStringValue.
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> scripts [
	^ scripts ifNil: [ scripts := Dictionary new]
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepositoryAbstract class >> scriptsNames [
   ^ self scripts keys
]
