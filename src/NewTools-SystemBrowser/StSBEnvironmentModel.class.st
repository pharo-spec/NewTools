Class {
	#name : 'StSBEnvironmentModel',
	#superclass : 'StSBModel',
	#instVars : [
		'allPackagesQuery'
	],
	#category : 'NewTools-SystemBrowser-Model',
	#package : 'NewTools-SystemBrowser',
	#tag : 'Model'
}

{ #category : 'instance creation' }
StSBEnvironmentModel class >> newEnvironment: aNavigationEnvironment [

	^ self new 
		environment: aNavigationEnvironment;
		yourself
]

{ #category : 'accessing' }
StSBEnvironmentModel >> allPackages [ 

	^ ((self allPackagesQuery execute) items 
		collect: [ :each | StSBPackageModel newEnvironment: self environment package: each ])
		sorted: #name ascending
]

{ #category : 'private queries' }
StSBEnvironmentModel >> allPackagesQuery [

	^ allPackagesQuery ifNil: [ allPackagesQuery := self newAllPackagesQuery ]
]

{ #category : 'accessing' }
StSBEnvironmentModel >> name [

	^ nil
]

{ #category : 'private queries factory' }
StSBEnvironmentModel >> newAllPackagesQuery [

	^ ClyAllPackagesQuery sortedFrom: self systemScope
]

{ #category : 'accessing' }
StSBEnvironmentModel >> systemScope [

	^ self environment systemScope
]
