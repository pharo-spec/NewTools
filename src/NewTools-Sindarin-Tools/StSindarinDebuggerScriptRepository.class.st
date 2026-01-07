"
StSindarinDebuggerScriptRepository is an abstract class that defines the logic for managing script repositories in the context of Sindarin debugger extensions.

Its main responsibilities include:
- Saving scripts by name and code.
- Retrieving the list of available script names in the repository.
- Loading the code of a script given its name.

Subclasses are expected to implement the class side `repositoryName` method, which specifies the name (or identifier) of the script repository, typically based on the project it is associated with.

"
Class {
	#name : 'StSindarinDebuggerScriptRepository',
	#superclass : 'Object',
	#classInstVars : [
		'scripts'
	],
	#category : 'NewTools-Sindarin-Tools-Model',
	#package : 'NewTools-Sindarin-Tools',
	#tag : 'Model'
}

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> clearScripts [
	<script>
	scripts := Dictionary new.
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> loadScript: aString [
	^ self scripts at: aString ifAbsent: nil.
	
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> repositoryName [
	"Return the name of the repository."
	self subclassResponsibility
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> saveScript: aStringKey code: aStringValue [
	
	self scripts add: aStringKey -> aStringValue.
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> scripts [
	^ scripts ifNil: [ scripts := Dictionary new]
]

{ #category : 'accessing' }
StSindarinDebuggerScriptRepository class >> scriptsNames [
   ^ self scripts keys
]
