# Fast Forward to Azure DevOps
The point with this session is to demonstrate how easy it can be to start from scratch with a project and add source control versioning, continouos integration and continouos delivery to Azure Web Apps. To start simple, fast with low environment friction, is important for the creative process and to be able to show and lobby for the ideas your and/or your team has. Being able to do so, but at the same time, creating a foundation from which you can continue to grow and more advanced stuff to as you actually need it, is also of course very important. There's not much to gain if you need to start over just becuase you need to scale your team as the idea turns in to an formal project.

## Coding the idea

Start new with a simple webapp (AspNet Core 3.1) in Visual Studio [1:21, 1:21]

Build and test the webapp locally [1:00, 2:21]

Add bootstrap css to _Layout.cshtml
```<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous">``` 

Add the jumbotron welcome message
```
<div class="jumbotron">
    <h1 class="display-4">Hello, dev community!</h1>
    <p class="lead">This is a simple hero unit, a simple jumbotron-style component for calling extra attention to featured content or information.</p>
    <hr class="my-4">
    <p>It uses utility classes for typography and spacing to space content out within the larger container.</p>
    <p class="lead">
        <a class="btn btn-primary btn-lg" href="#" role="button">Learn more</a>
    </p>
</div>
```


## Crete and initialize the Azure DevOps project
az devops project create --name <project-name> --description "Let's work together on this project." -p Agile -s git --verbose
15:12
Add source to project
(az repos list -p <project-name>)
az repos show -p <project-name> -r <repo-name>

Show project and repo
- Project: Empty project based on Agile process.
- Repo: Contains the project. Added .gitignore and .gitattributes
- Pipelines: Empty


# Create WebApp, CI/CD and deploy the app
Create Azure WebApp (Free Linux plan)
New to Azure, simples is to go to portal and create the web app there.


Create deployment pipeline through Deployment Center (dotnet AdoWebApp.dll)
15:33
Show the deployed app
15:34

Show the CI/CD pipeline that got created
->

Add Application Insights Telemetry through VS
Add Log Analytics Workspace
Add Application Insights

Make updates to the app
Show changes in GUI
15:40

Q/A
