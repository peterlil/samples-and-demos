# Step by step for Visual Studio Code

### Configure AAD B2C
#### Make an app registration for the simple webapp
Click on *App Registrations* and *New Registration*.
Enter a name for the application. 
Select *Accounts in any identity provider or organizational directory*.
Enter ```https://jwt.ms``` as the Redirect URI.
Check the *Grant admin consent to openid and offline_access permissions* box.
Click *Register*
Click on *Authentication* and *Add a platform*.
Select *Web* and enter ```https://jwt.se``` as Redirect URL.
Also add an additional URL: https://localhost:5001
Check the boxes for *Access token* and *ID tokens* and click *Configure*.

Go to the b2c tenant and click on *User flows*
TBD: Create Signup and sign in user flow

TBD: Create a user

### Create a vscode webapp project
Create a new .NET Core web project with ```dotnet new webapp -n aadb2c-webapp-webapi -o ./code/webapp -au IndividualB2C --aad-b2c-instance https://peterlilb2c.b2clogin.com/tfp/ --susi-policy-id B2C_1_susi -rp B2C_1_SSPR -ep B2C_1_SiPe --client-id 42e92133-c635-4bca-92d0-120e43735a81 --domain peterlilb2c.onmicrosoft.com -f net5.0```


Test it locally.
Test by publishing to Azure App Service (Linux):
- Create App Service Plan
- Create Web App

### Publish to Azure
#### Use the Azure login Action

Create a service principal for the repo.

    $name = 'http://[yourappname]'
    $role = 'contributor'
    $scope = '/subscriptions/[id]/resourceGroups/[rg]/'
    
    az ad sp create-for-rbac --name $name --role $role --scopes $scope --sdk-auth

Add the nuget package to the project:

    dotnet add package Microsoft.Identity.Web --version 1.3.0

Conclusions:
* For a simple webapp authenticating users, no secret is required for the app registration.
* When deployed to a WebApp, the WebApp does not need to configure auth.

### Create a vscode webapi project
Create the web api:
    
    dotnet new webapi -o webapi



# Links
[Quickstart: Create an ASP.NET Core web app in Azure](https://docs.microsoft.com/en-us/azure/app-service/quickstart-dotnetcore?pivots=platform-linux)\
[Tutorial: Get started with Razor Pages in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/tutorials/razor-pages/razor-pages-start?view=aspnetcore-5.0&tabs=visual-studio-code)\
[Dependency injection in ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core/fundamentals/dependency-injection?view=aspnetcore-5.0)\
[Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)\
[ASP.NET Web Apps](https://dotnet.microsoft.com/apps/aspnet/web-apps)
[Protect .NET Core API Using Azure AD B2C and MSAL](https://manojchoudhari.wordpress.com/2020/05/13/protect-net-core-api-using-azure-ad-b2c-and-msal/)
[Razor Pages vs MVC - How Do They Differ?](https://exceptionnotfound.net/razor-pages-how-does-it-differ-from-mvc-in-asp-net-core/)

