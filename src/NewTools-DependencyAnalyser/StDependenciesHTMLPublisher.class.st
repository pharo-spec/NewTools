"
This class generates an HTML report of system dependencies in HTML format.

Example: 

 '/tmp/report.html' asFileReference writeStreamDo: [ :stream |
	 DADependenciesHTMLPublisher 
		publishReportFrom: (DADependencyChecker new transitiveDependenciesOf: #Kernel)
		stream: stream ]
"
Class {
	#name : 'StDependenciesHTMLPublisher',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'report'
	],
	#category : 'NewTools-DependencyAnalyser-HTMLReport',
	#package : 'NewTools-DependencyAnalyser',
	#tag : 'HTMLReport'
}

{ #category : 'publishing' }
StDependenciesHTMLPublisher class >> generateSystemReport [

	<script>

	| report |

	report := StDependencyChecker new computeImageDependencies.
'dependency-report.html' asFileReference writeStreamDo: [ :stream |
	 StDependenciesHTMLPublisher
		publishReportFrom: report
		stream: stream ]
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher class >> publishReportFrom: aCGODependencyReport stream: aStream [
	self basicNew
		initializeWithReport: aCGODependencyReport stream: aStream;
		publish
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> accordion: id name: name headingContent: heading body: body [
	stream
		<< '<div class="panel-group" id="' << id << '" role="tablist" aria-multiselectable="true">'.

	stream << '  <div class="panel panel-default">
    <div class="panel-heading" role="tab" id="heading' << name << '">
      <h4 class="panel-title">
        <a role="button" data-toggle="collapse" data-parent="#' << id << '" href="#collapse' << name << '" aria-expanded="true" aria-controls="collapse' << name << '">' ; lf.
	stream
		<< heading
<< '
        </a>
      </h4>
    </div>
    <div id="collapse' << name << '" class="panel-collapse collapse in" role="tabpanel" aria-labelledby="heading' << name << '">
      <div class="panel-body">
      		'.
	stream
		<< body
		<< '
      </div>
    </div>
  </div>'.

	stream
		<< '</div>'; lf
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> badgeFor: aString [
	^ '<span class="badge"> ' , aString , '</span>'
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> dangerLabel: aString [
	^ '<span class="label label-danger">' , aString , '</span>'
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> htmlForDependencies: dependencies of: aPackageName [
	^ String streamContents: [ :str |
		dependencies
			do: [ :dependency | str
				<< '<a href="#'
				<< dependency
				<< '">'
				<< (self htmlForDependency: dependency of: aPackageName)
				<< '</a>' ]
			separatedBy: [ str space ] ]
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> htmlForDependency: dependencyPackageName of: aPackageName [
	^ 	dependencyPackageName
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> htmlForPackage: aPackageName [
	^ 	aPackageName
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> imageVersionString [
	^ report imageVersion majorMinorVersion, ' update ' , report imageVersion highestUpdate printString
]

{ #category : 'initialization' }
StDependenciesHTMLPublisher >> initializeWithReport: aCGODependencyReport stream: aStream [
	super initialize.
	stream := aStream.
	report := aCGODependencyReport
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> javaScript: scriptFileName [
	stream
		<< '<script type="text/javascript" language="javascript" src="'
		<< scriptFileName
		<< '"></script>'; lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publish [
	self
		publishHTMLHeader;
		publishSetup;
		publishWarnings;
		publishDependenciesCaption;
		publishDependencies;
		publishDependenciesCaption;
		publishHTMLFooter.
	stream close
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publish: aPackageName dependencies: dependencies dependants: dependants [
	| dependantLinks |
	dependantLinks := dependants sorted collect: [ :name | '<a href="#', name , '">' , name , '</a>' ].

	stream <<
'						<tr>
							<td id="' << aPackageName << '">' << (self htmlForPackage: aPackageName) << '</td>
							<td>' << (self sizeBadgeFor: dependencies) << Character space
							<< (self htmlForDependencies: dependencies sorted of: aPackageName) << Character space
							<< (self sizeBadgeFor: dependants) << Character space << (Character space join: dependantLinks) << '</td>
						</tr>'; lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishDependencies [
	stream
		<<
			'				<table id="example" class="display" cellspacing="0" width="100%">
					<thead>
						<tr>
							<th>Package</th>
							<th>Dependencies</th>
							<th>Dependants</th>
						</tr>
					</thead>
					<tbody>';
		lf.
	report
		dependenciesAndKnownDependantsDo:
			[ :packageName :dependencies :dependants | self
				publish: packageName
				dependencies: dependencies
				dependants: dependants ].
	self publishPackagesToRemoveDependants.
	stream
		<<
			'					</tbody>
				</table>';
		lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishDependenciesCaption [
	self stream lf;
		<< (self warningLabel: 'Ignored dependency'); lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishHTMLFooter [
	self stream lf;
		<< '</div>'; lf;
		<< '</body>'; lf;
		<< '</html>'; lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishHTMLHeader [
	self stream
		<< '<!DOCTYPE html>'; lf;
		<< '<html lang="en">'; lf;
		<< '<head>'; lf;
		<< '<title>Dependencies Report: </title>'; lf.

	self styleSheet: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css'.
	self styleSheet: 'https://cdn.datatables.net/1.10.8/css/jquery.dataTables.min.css'.
	self javaScript: 'https://code.jquery.com/jquery-1.11.3.min.js'.
	self javaScript: 'https://cdn.datatables.net/1.10.8/js/jquery.dataTables.min.js'.
	self javaScript: 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js'.

	stream << '<script type="text/javascript" class="init">
$(document).ready(function() {
	$(''#example'').DataTable( {
		"paging": false,
		"aoColumns": [ null, { "bSearchable": false }, { "bSearchable": false } ]
	});
} );
	</script>'.

	self stream
		lf;
		<< '</head>'; lf;
		<< '<body>'; lf;
		<< '<div class="container">'; lf;
		<< '<h1>Dependency analysis</h1>'; lf
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishPackagesToRemoveDependants [
	"Standard dependency report do not care about packages to remove for the bootsrap.
	Nothing to do."
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishSetup [
	| body |
	body := String streamContents: [ :str |
		str
			<< 'Image version: <span class="label label-primary">';
			<< self imageVersionString;
			<< '</span></br> Analysis run on ';
			<< report analysisRunString ;
			<< '</br>' ].
	self accordion: 'accordionSetup' name: 'Setup' headingContent: 'Analysis setup' body: body
]

{ #category : 'publishing' }
StDependenciesHTMLPublisher >> publishWarnings [
	| body |
	body := String streamContents: [ :str |
		(report warnings sorted: [ :a :b | a package < b package ])
			do: [ :warning | str << warning messageText << '<br/>' ] ].
	self
		accordion: 'accordionWarnings'
		name: 'Warnings'
		headingContent: 'Warnings ' , (self sizeBadgeFor: report warnings)
		body: body.
	stream
		<< '</br>'; lf
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> sizeBadgeFor: aCollection [
	^ self badgeFor: aCollection size asString
]

{ #category : 'accessing' }
StDependenciesHTMLPublisher >> stream [
	^ stream
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> styleSheet: styleSheetUrl [
	stream
		<< '<link rel="stylesheet" type="text/css" href="'
		<< styleSheetUrl
		<< '">'; lf
]

{ #category : 'html utilities' }
StDependenciesHTMLPublisher >> warningLabel: aString [
	^ '<span class="label label-warning">' , aString , '</span>'
]
