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
While still using Chrome, browse to `https://blueish1.jfrog.io` (replace `blueish1` with the name of your subscription) and log in with the credentials you created in step 2. 

When you are logged in, click the *Create a Repository* button as shown below. 
![The welcome to the JFrog Platform page is shown with a button for creating a repository.](./../../../img/jfrog/jfrog3.jpg)

Then select *Create Local Repository*.
![A page showing the options of creating a local repository, a remote repository or a virtual repository.](./../../../img/jfrog/jfrog4.jpg)

Continue by selecting the *NuGet* ikon to create a NuGet package repository.
![A page showing ikons for al supported repositories, 26 of them.](./../../../img/jfrog/jfrog5.jpg)

Now fill in the *Repository Key*, which essentially is the name of your repository, and check the *Force Authentication* checkbox so no anonymous connections can be made.
Nothing else needs to be filled in, so continue by clicking on *Save & Finish*.
![A page showing the New Repository form.](./../../../img/jfrog/jfrog6-01.jpg)

When the repository is created, just click on the X to close the message window.
![A confirmation message window.](./../../../img/jfrog/jfrog7.jpg)

#### 5. Delete default repos
Hover over the repositories and remove the ones that was created by default (*example-repo-local* and *jfrogpipelines*).
![Showing the list of repositories.](./../../../img/jfrog/jfrog8.jpg)

#### 6. Permissions
By default, you get a *readers* group, which all users are assigned to by default when they are created. The *readers* group has by default read access to repositories, builds and pipelines. 

Since we want to keep control and only give reading access to the NuGet repository to our users, we should stop new users from auto-joining the *readers* group and instead join a new group that we create, that only has read access to the NuGet Repository.

##### 6.1 Stop new users to auto-join the Reader group
Go to Administration->Groups and click *readers*. 
![Page showing how to navigate to the group readers in three clicks.](./../../../img/jfrog/jfrog9.jpg)
In the *readers* group settings, uncheck the box named *Automatically Join New Users to this Group* and click *Save*.
![Showing a checkbox.](./../../../img/jfrog/jfrog10.jpg)

##### 6.2 Create a new group
Still on the page listing groups, click on *New Group*.
![Showing the group list and there is a new group button.](./../../../img/jfrog/jfrog11.jpg)



# Remove default permissions

Default permissions are:



