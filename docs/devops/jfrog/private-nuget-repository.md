# Set up a private (and free) NuGet repository in Azure

This article will show you a simple way of securely setting up a private NuGet feed over the Internet and at the time of writing, at no cost. 
First of all, use Google Chrome are even the new Chromium Edge is not supported with JFrog.

#### 1. Create the subscription

Start by signing up for a [free cloud subscription at JFrog](https://jfrog.com/) using Google Chrome.

Click on the red circled button below to create a free cloud subscription.
![Start page of JFrog with an option to create a free cloud subscription.](./../../../img/jfrog/jfrog1.jpg)

#### 2. Fill in the details. 
Make sure that Cloud is selected, and not self-hosted.
Also important as the title of this article, select **Microsoft Azure** as your cloud provider. 
Then fill in the fields as it's approporiate for you and click Proceed. Choose a wise name in the server details as this will be the address of your subscription and repository going forward. 
The article is using `blueish1` as an example.
![A screenshot showing the fields to fill in.](./../../../img/jfrog/jfrog2.jpg)

#### 3. Confirm your e-mail
You will get an e-mail sent to the address you entered in the form. Make sure to click on the link for activating yor subscription in the e-mail.

#### 4. Create a repository
While still using Chrome, browse to `https://blueish1.jfrog.com` (replace `blueish1` with the name of your subscription) and log in with the credentials you created in step 2. 

When you are logged in, click the *Create a Repository* button as shown below.
![The welcome to the JFrog Platform page is shown with a button for creating a repository.](./../../../img/jfrog/jfrog3.jpg)

#### 5. 
![.](./../../../img/jfrog/jfrog4.jpg)
![.](./../../../img/jfrog/jfrog5.jpg)
![.](./../../../img/jfrog/jfrog6.jpg)
![.](./../../../img/jfrog/jfrog7.jpg)




and make sure to select to host it in Azure.

Activate by the e-mail sent

Log in (still in Chrome)

# Delete default repos
Sign in to your subscription (https://<your subscription name>.jfrog.io) and navigate to Administration->Repositories. 
Hover over the repositories and remove the ones that was created by default.

# Add a new local repository
Create a new local repository and select package type NuGet when you are prompted.
When entering 'Repository Key' you should enter the name of your repository. It could be confusing that they are calling it key, when they actually mean name.

# Remove default permissions

Default permissions are:



