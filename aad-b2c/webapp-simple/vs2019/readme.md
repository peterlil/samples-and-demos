# Step by step

### 1. Configure AAD B2C
#### 1.1 Make an app registration for the simple webapp
Click on *App Registrations* and *New Registration*.
Enter a name for the application. 
Select *Accounts in any identity provider or organizational directory*.
Enter ```https://jwt.ms``` as the Redirect URI.
Check the *Grant admin consent to openid and offline_access permissions* box.
Click *Register*
Click on *Authentication* and *Add a platform*.
Select *Web* and enter ```https://jwt.se``` as Redirect URL.
Also add an additional URL: https://localhost:44311/signin-oidc
Check the boxes for *Access token* and *ID tokens* and click *Configure*.

Go to the b2c tenant and click on *User flows*
TBD: Create Signup and sign in user flow

TBD: Create a user

### 2. Create a Visual Studio 2019 project
Create a new project in *Visual Studio 2019* based on the *ASP.NET Core Web Application* project template.
Change *Authentication* from *No Authentication* to *Individual User Accounts*:
* Connect to an existing user store in the cloud
* Domain Name - Fill in your domain name of the b2c tenant. (Overview page of b2c)
* Application ID - Fill in the Application ID from the app registration you did.
* Callback Path - Leave as default.
* Sign-up or Sign-in Policy - Fill in the name of your sign-up and sign-in policy of your b2c tenant.
* Reset Password Policy - Fill in the name for the password reset policy of your b2c tenant.
* Edit Profile Policy -  If exists, fill in the name for the edit profile policy of your b2c tenant.

Create the project.


Test it locally.
Test by publishing to Azure App Service (Linux):
- Create App Service Plan
- Create Web App
- Publish


Conclusions:
* For a simple webapp authenticating users, no secret is required for the app registration.
* When deployed to a WebApp, the WebApp does not need to configure auth.